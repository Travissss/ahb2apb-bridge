//////////////////////////////////////////////////////////////////////////////////
// Engineer: 		Travis
// 
// Create Date: 	11/13/2020
// Filename: 		apb_slv_drv.svh
// class Name: 		apb_slv_drv
// Project Name: 	ahb2apb_bridge
// Revision 0.01 - File Created 
// Additional Comments:
// -------------------------------------------------------------------------------
// 	-> Get Virtual Interface from ENV Configuration
//	-> Drive APB Transaction on to AHB-APB Bridge
//////////////////////////////////////////////////////////////////////////////////

`ifndef APB_SLAVE_DRV_SV
`define APB_SLAVE_DRV_SV

class apb_slv_drv extends uvm_driver;


	
	//------------------------------------------
	// Data, Interface, port  Members
	//------------------------------------------
	virtual apb_if		vif;
	apb_mem#(32, 32) 	mem;
	apb_trans			pkt;
	
	//Factory Registration
	//
	`uvm_component_utils(apb_slv_drv)

	//----------------------------------------------
	// Methods
	// ---------------------------------------------
	// Standard UVM Methods:	
	extern function new(string name = "apb_slv_drv", uvm_component parent);
	extern virtual function void build_phase(uvm_phase phase);
	extern virtual task main_phase(uvm_phase phase);
	// User Defined Methods:
	extern virtual task drive_one_pkt(apb_trans pkt);
	
endclass

//Constructor
function apb_slv_drv::new(string name = "apb_slv_drv", uvm_component parent);
	super.new(name, parent);
endfunction

//Build_Phase
function void apb_slv_drv::build_phase(uvm_phase phase);
	super.build_phase(phase);
	pkt = apb_trans::type_id::create("pkt");
	mem = apb_mem #(32, 32)::type_id::create("mem");
	if(!uvm_config_db#(virtual apb_if)::get(this,"","vif",vif)) begin
		`uvm_fatal("my_driver","Error in Getting interface")
	end
endfunction

//Main_Phase
task apb_slv_drv::main_phase(uvm_phase phase);
	vif.slv_cb.pready <= 1'b1;
	vif.slv_cb.pslverr <= 1'b0;
	while(1) begin
		@(vif.slv_cb);
		if(!vif.slv_cb.penable & vif.slv_cb.psel) begin
			seq_item_port.get_next_item(pkt);
			drive_one_pkt(pkt);
			seq_item_port.item_done();
		end
	end
endtask

//drive_one_pkt
task apb_slv_drv::drive_one_pkt(apb_trans pkt);
	int nready_cnt;
	nready_cnt = pkt.nready_num;
	while(nready_cnt != 0) begin
		vif.slv_cb.pready <= 1'b0;	
		nready_cnt--;	
		@(vif.slv_cb);
	end
	vif.slv_cb.pready <= 1'b1;
	vif.slv_cb.pslverr <= pkt.pslverr;
	if(vif.slv_cb.pwrite)
		if(!pkt.pslverr)
			mem.put_data(vif.slv_cb.paddr, vif.slv_cb.pwdata);
	else
		if(!vif.slv_cb.pslverr)
			vif.slv_cb.prdata <= mem.get_data(vif.slv_cb.paddr);
		else
			vif.slv_cb.prdata <= 32'hffff_ffff;
endtask
`endif