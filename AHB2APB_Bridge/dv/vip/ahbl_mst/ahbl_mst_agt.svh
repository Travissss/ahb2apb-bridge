//////////////////////////////////////////////////////////////////////////////////
// Engineer: 		Travis
// 
// Create Date: 	12/15/2020 TUE 23:46	
// Filename: 		ahbl_mst_agt.svh
// class Name: 		ahbl_mst_agt
// Project Name: 	ahb2apb_bridge
// Revision 0.01 - File Created 
// Additional Comments:
// -------------------------------------------------------------------------------
// 	->  agent
//////////////////////////////////////////////////////////////////////////////////

`ifndef APB_MST_AGT_SV
`define APB_MST_AGT_SV

class ahbl_mst_agt extends uvm_agent;


	
	//------------------------------------------
	// Data, Interface, port  Members
	//------------------------------------------
	virtual ahbl_if		vif;
	uvm_analysis_port	ap;
	//------------------------------------------
	// Sub Components
	//------------------------------------------
	ahbl_mst_drv		drv_i;
	ahbl_mst_mon		mon_i;
	ahbl_mst_sqr		sqr_i;
	
	//Factory Registration
	//
	`uvm_component_utils(ahbl_mst_agt)
	
	//----------------------------------------------
	// Methods
	// ---------------------------------------------
	// Standard UVM Methods:	
	extern function new(string name = "ahbl_mst_agt", uvm_component parent);
	extern virtual function void build_phase(uvm_phase phase);
	extern virtual function void connect_phase(uvm_phase phase);
	// User Defined Methods:
	
endclass

//Constructor
function ahbl_mst_agt::new(string name = "ahbl_mst_agt", uvm_component parent);
	super.new(name, parent);
endfunction

//Build_Phase
function void ahbl_mst_agt::build_phase(uvm_phase phase);
	super.build_phase(phase);
	ap = new("ap", this);
	if(!uvm_config_db#(virtual ahbl_if)::get(this, "", "vif", vif))
		`uvm_fatal("No vif", "error")

	mon_i = ahbl_mst_mon::type_id::create("mon_i", this);
	uvm_config_db#(virtual ahbl_if)::set(this, "mon_i", "vif", vif);
	if(!uvm_config_db#(uvm_active_passive_enum)::get(this, "", "is_active", is_active))
		`uvm_fatal("ahbl_mst_agt", "No is_active")
	if(is_active == UVM_ACTIVE) begin
		drv_i = ahbl_mst_drv::type_id::create("drv_i", this);
		sqr_i = ahbl_mst_sqr::type_id::create("sqr_i", this);
		uvm_config_db#(virtual ahbl_if)::set(this, "drv_i", "vif", vif);	
	end
	
endfunction

//Connect_phase
function void ahbl_mst_agt::connect_phase(uvm_phase phase);
	super.connect_phase(phase);
	if(is_active == UVM_ACTIVE)
		drv_i.seq_item_port.connect(sqr_i.seq_item_export);
endfunction

`endif