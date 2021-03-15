//////////////////////////////////////////////////////////////////////////////////
// Engineer: 		Travis
// 
// Create Date: 	12/03/2020
// Filename: 		ahbl_mst_drv.svh
// class Name: 		ahbl_mst_drv
// Project Name: 	ahb2apb_bridge
// Revision 0.01 - File Created 
// Additional Comments:
// -------------------------------------------------------------------------------
// 	-> Get Virtual Interface from ENV Configuration
//	-> Drive AHB Transaction on to AHB-APB Bridge
//////////////////////////////////////////////////////////////////////////////////
`ifndef AHB_MST_DRV_SV
`define AHB_MST_DRV_SV

class ahbl_mst_drv extends uvm_driver #(ahbl_trans);

	//------------------------------------------
	// Data, Interface, port  Members
	//------------------------------------------
	virtual ahbl_if vif;
	
	protected ahbl_trans pkt_apha = null;		//packet address-phase
	protected ahbl_trans pkt_dpha = null;		//packet data-phase
	
	//Factory Registration
	//
	`uvm_component_utils(ahbl_mst_drv)

	//----------------------------------------------
	// Methods
	// ---------------------------------------------
	// Standard UVM Methods:	
	extern function new(string name = "ahbl_mst_drv", uvm_component parent);
	extern virtual function void build_phase(uvm_phase phase);
	extern virtual task main_phase(uvm_phase phase);
	// User Defined Methods:
	extern task drive_lcyc_pkt_dpha(ref ahbl_trans pkt);
	extern task drive_lcyc_pkt_apha(ref ahbl_trans pkt);
	extern task drive_lcyc_pkt_idle();
endclass

//Constructor
function ahbl_mst_drv::new(string name = "ahbl_mst_drv", uvm_component parent);
	super.new(name, parent);
endfunction

//Build_Phase
function void ahbl_mst_drv::build_phase(uvm_phase phase);
	super.build_phase(phase);
	if(!uvm_config_db#(virtual ahbl_if)::get(this,"","vif",vif))
		`uvm_fatal("my_driver", "Error in Getting interface")
endfunction

//Main_Phase
task ahbl_mst_drv::main_phase(uvm_phase phase);
	while(1) begin
		@(vif.mst_cb);
		if(!vif.mst_cb.hresetn) begin
			vif.mst_cb.hsel 	<= 1'b0;
			vif.mst_cb.haddr 	<= 32'b0; 
			vif.mst_cb.htrans	<= IDLE;
			vif.mst_cb.hsize	<= BYTE;
			vif.mst_cb.hburst	<= SINGLE;
			vif.mst_cb.hprot	<= 4'b0;
			vif.mst_cb.hwrite	<= 1'b0;
			vif.mst_cb.hwdata	<= 32'b0;					
			vif.mst_cb.clk_ratio<= 4'h1;
			pkt_dpha = null;
			pkt_apha = null;
		end
		else begin
			//transfer data
			if(pkt_dpha != null) begin	
				drive_lcyc_pkt_dpha(pkt_dpha);
				if(vif.mst_cb.hready & (pkt_dpha.hburst == SINGLE | pkt_dpha.last_beat())) begin
					seq_item_port.item_done();
					pkt_dpha = null;
					pkt_apha = null;
				end
			end
			
			if(pkt_apha != null) begin
			//transfer address
				drive_lcyc_pkt_apha(pkt_apha);
			end
			else begin
				seq_item_port.try_next_item(pkt_apha);
				if(pkt_apha != null) begin
					drive_lcyc_pkt_apha(pkt_apha);
					pkt_apha.print();
					`uvm_info(get_type_name(), "ahbl_mst_drv successfully get a new AddressPhase pkt", UVM_LOW)
				end	
				else begin
					drive_lcyc_pkt_idle();
					//`uvm_info(get_type_name(), "ahbl_mst_drv didn't get a new AddressPhase pkt", UVM_LOW)
				end
			end
		end
	end
endtask

task ahbl_mst_drv::drive_lcyc_pkt_dpha(ref ahbl_trans pkt);
	if(vif.mst_cb.hready) 
		vif.mst_cb.hwdata <= pkt.hwrite ? pkt.nxt_hrwdata() : 32'd0;
endtask

task ahbl_mst_drv::drive_lcyc_pkt_apha(ref ahbl_trans pkt);
	if((vif.mst_cb.hready)) begin
		vif.mst_cb.hsel 	<= pkt.hsel;
		vif.mst_cb.haddr 	<= ((pkt.htrans_ro() != IDLE)&(pkt.htrans_ro() != BUSY)) ? pkt.nxt_haddr() : vif.haddr;
		vif.mst_cb.htrans	<= pkt.nxt_htrans();
		vif.mst_cb.hsize	<= pkt.hsize;
		vif.mst_cb.hburst	<= pkt.hburst;
		vif.mst_cb.hprot	<= pkt.hprot;
		vif.mst_cb.hwrite	<= pkt.hwrite;
		vif.mst_cb.clk_ratio<= pkt.clk_ratio;
		this.pkt_dpha <= this.pkt_apha;
	end
endtask

task ahbl_mst_drv::drive_lcyc_pkt_idle();
	vif.mst_cb.hsel 	<= 1'b0;
	vif.mst_cb.haddr 	<= 32'b0; 
	vif.mst_cb.htrans	<= IDLE;
	vif.mst_cb.hsize	<= BYTE;
	vif.mst_cb.hburst	<= SINGLE;
 	vif.mst_cb.hprot	<= 4'b0;
	vif.mst_cb.hwrite	<= 1'b0;
 	vif.mst_cb.clk_ratio<= 4'h1;
endtask
`endif
