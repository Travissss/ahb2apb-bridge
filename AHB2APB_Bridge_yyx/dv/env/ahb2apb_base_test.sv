//////////////////////////////////////////////////////////////////////////////////
// Engineer: 		Yunxiao
// 
// Create Date: 	12/23/2020 Wed 21:36
// Filename: 		ahb2apb_base_test.svh
// class Name: 		ahb2apb_base_test
// Project Name: 	ahb2apb_bridge
// Revision 0.01 - File Created 
// Additional Comments:
// -------------------------------------------------------------------------------
// 	-> test top include ahb2apb_env,
//////////////////////////////////////////////////////////////////////////////////

`ifndef APB_SLAVE_DRV_SV
`define APB_SLAVE_DRV_SV

import ahb2apb_pkg::*;
class ahb2apb_base_test extends uvm_test;


	
	//------------------------------------------
	// Data, Interface, port  Members
	//------------------------------------------
	virtual reset_if	reset_if_i;
	
	//------------------------------------------
	// Sub Components
	//------------------------------------------
	ahb2apb_env	ahb2apb_env_i;
	
	//Factory Registration
	//
	`uvm_component_utils(ahb2apb_base_test)

	//----------------------------------------------
	// Methods
	// ---------------------------------------------
	// Standard UVM Methods:	
	extern function new(string name = "ahb2apb_base_test", uvm_component parent);
	extern virtual function void build_phase(uvm_phase phase);
	extern virtual function void start_of_simulation_phase(uvm_phase phase);
	extern virtual task main_phase(uvm_phase phase);
	extern virtual function void report_phase(uvm_phase phase);
	// User Defined Methods:
	extern function int num_uvm_errors();
endclass

//Constructor
function void ahb2apb_base_test::new(string name = "ahb2apb_base_test", uvm_component parent)
	super.new(name, parent);
endfunction

//Build_Phase
function void ahb2apb_base_test::build_phase(uvm_phase phase);
	super.build_phase(phase);
	ahb2apb_env_i = ahb2apb_env::type_id::create("ahb2apb_env_i", this);
	
	ahb2apb_env_i.ahbl_mst_agt_i.is_active = UVM_ACTIVE;
	ahb2apb_env_i.apb_slv_agt_i.is_active = UVM_ACTIVE;
	
	if(!config_db#(virtual reset_if)::get(this, "", "vif", reset_if_i))
		`uvm_fatal("No reset_if", "reset_if_i is not set!")
endfunction

//Main_Phase
task ahb2apb_base_test::main_phase(uvm_phase phase);

endtask

`endif