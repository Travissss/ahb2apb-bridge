//////////////////////////////////////////////////////////////////////////////////
// Engineer: 		Travis
// 
// Create Date: 	12/14/2020 22:16
// Filename: 		ahbl_mst_mon.svh
// class Name: 		ahbl_mst_mon
// Project Name: 	ahb2apb_bridge
// Revision 0.01 - File Created 
// Additional Comments:
// -------------------------------------------------------------------------------
// 	-> Collect AHB Transaction on to AHB-APB Bridge
//////////////////////////////////////////////////////////////////////////////////

`ifndef AHBL_MST_MON_SV
`define AHBL_MST_MON_SV

class ahbl_mst_mon extends uvm_monitor;


	
	//------------------------------------------
	// Data, Interface, port  Members
	//------------------------------------------
	virtual ahbl_if		vif;
	ahbl_trans			pkt;
	uvm_analysis_port #(ahbl_trans)	ap;

	//Factory Registration
	//
	`uvm_component_utils(ahbl_mst_mon)
	
	//----------------------------------------------
	// Methods
	// ---------------------------------------------
	// Standard UVM Methods:	
	extern function new(string name = "ahbl_mst_mon", uvm_component parent);
	extern virtual function void build_phase(uvm_phase phase);
	extern virtual task main_phase(uvm_phase phase);
	// User Defined Methods:
	extern virtual task samp_apha(ref ahbl_trans pkt);
	extern virtual task samp_dpha(ref ahbl_trans pkt);
	
endclass

//Constructor
function ahbl_mst_mon::new(string name = "ahbl_mst_mon", uvm_component parent);
	super.new(name, parent);
endfunction

//Build_Phase
function void ahbl_mst_mon::build_phase(uvm_phase phase);
	ap = new("ap", this);
	if(!uvm_config_db#(virtual ahbl_if)::get(this, "", "vif", vif))
		`uvm_fatal("Error", "No vif")
endfunction

//Main_Phase
task ahbl_mst_mon::main_phase(uvm_phase phase);
	while(1) begin
		@(vif.mon_cb);
		if(!vif.mon_cb.hresetn)
			pkt = null;
		else begin
			if(vif.mon_cb.hready & vif.mon_cb.htrans[1]) begin
				if(pkt != null) begin
					samp_dpha(pkt);
					ap.write(pkt);
					pkt = null;
				end
				
				if(vif.mon_cb.hsel & vif.mon_cb.htrans[1]) 
					samp_apha(pkt);                             
			end
		end
	end
endtask

task ahbl_mst_mon::samp_dpha(ref ahbl_trans pkt);
	pkt.hrwdata = vif.mon_cb.hwrite ? vif.mon_cb.hwdata : vif.mon_cb.hrdata;
	pkt.hresp	= vif.mon_cb.hresp;
endtask

task ahbl_mst_mon::samp_apha(ref ahbl_trans pkt); 
	pkt = ahbl_trans::type_id::create("pkt");
	pkt.hsel	= vif.mon_cb.hsel	;
	pkt.haddr 	= vif.mon_cb.haddr 	;
	pkt.htrans 	= htrans_t'(vif.mon_cb.htrans);	
	pkt.hsize 	= hsize_t'(vif.mon_cb.hsize);
	pkt.hburst 	= hburst_t'(vif.mon_cb.hburst);	
	pkt.hprot 	= vif.mon_cb.hprot 	;
	pkt.hwrite 	= vif.mon_cb.hwrite ;	
	pkt.clk_ratio = vif.clk_ratio;
endtask
`endif
