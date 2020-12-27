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

	//------------------------------------------
	// Constraints
	//------------------------------------------

	
	//----------------------------------------------
	// Methods
	// ---------------------------------------------
	// Standard UVM Methods:	
	extern function new(string name = "ahb2apb_base_test", uvm_component parent);
	extern virtual function void build_phase(uvm_phase phase);
	extern virtual task main_phase(uvm_phase phase);
	// User Defined Methods:
	
endclass

//Constructor
function void ahb2apb_base_test::new(string name = "ahb2apb_base_test", uvm_component parent)
	super.new(name, parent);
endfunction

//Build_Phase
function void ahb2apb_base_test::build_phase(uvm_phase phase);
	super.build_phase(phase);
endfunction

//Main_Phase
task ahb2apb_base_test::main_phase(uvm_phase phase);

endtask

`endif