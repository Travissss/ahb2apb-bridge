//////////////////////////////////////////////////////////////////////////////////
// Engineer: 		Travis
// 
// Create Date: 	11/17/2020
// Filename: 		apb_slv_agt.svh
// class Name: 		apb_slv_agt
// Project Name: 	ahb2apb_bridge
// Revision 0.01 - File Created 
// Additional Comments:
// -------------------------------------------------------------------------------
// 	-> Contains Handle for APB Driver and Monitor
//////////////////////////////////////////////////////////////////////////////////

`ifndef APB_SLAVE_AGT_SV
`define APB_SLAVE_AGT_SV

class apb_slv_agt extends uvm_agent;

	//Factory Registration
	//
	` uvm_component_utils(apb_slv_agt)
	
	//------------------------------------------
	// Data, Interface, port  Members
	//------------------------------------------
	virtual apb_if 		vif;
	uvm_analysis_port 	ap;
	//------------------------------------------
	// Sub Components
	//------------------------------------------
	apb_slv_sqr sqr_i;
	apb_slv_drv drv_i;
	apb_slv_mon mon_i;
	
	//----------------------------------------------
	// Methods
	// ---------------------------------------------
	// Standard UVM Methods:	
	extern function new(string name = "apb_slv_agt", uvm_component parent);
	extern virtual function void build_phase(uvm_phase phase);
	extern virtual function void connect_phase(uvm_phase phase);
	// User Defined Methods:
	
endclass

//Constructor
function apb_slv_agt::new(string name = "apb_slv_agt", uvm_component parent);
	super.new(name, parent);
endfunction

//Build_Phase
function void apb_slv_agt::build_phase(uvm_phase phase);
	super.build_phase(phase);
	ap = new("ap", this);
	if(!uvm_config_db#(virtual apb_if)::get(this, "", "vif", vif))
		`uvm_fatal("NO vif", " vif is not found")
	

	if(!uvm_config_db#(uvm_active_passive_enum)::get(this, "", "is_active", is_active))
		`uvm_fatal("apb_slv_agt", "No is_active")
	
	if(is_active == UVM_ACTIVE) begin
		sqr_i = apb_slv_sqr::type_id::create("sqr_i", this);
		drv_i = apb_slv_drv::type_id::create("drv_i", this);
		uvm_config_db#(virtual apb_if)::set(this, "drv_i", "vif", vif);
	end
		
		mon_i = apb_slv_mon::type_id::create("mon_i", this);
		uvm_config_db#(virtual apb_if)::set(this, "mon_i", "vif", vif);
endfunction

//Connect_Phase
function void apb_slv_agt::connect_phase(uvm_phase phase);
	super.connect_phase(phase);
	if(is_active == UVM_ACTIVE) begin
		drv_i.seq_item_port.connect(sqr_i.seq_item_export);
	end
//		this.ap = mon_i.ap;		can not assign? if assign suc, need to change port connect relationship in ahb2apb_env;
endfunction


`endif