//////////////////////////////////////////////////////////////////////////////////
// Engineer: 		Travis
// 
// Create Date: 	11/18/2020
// Filename: 		apb_slv_sqr.svh
// class Name: 		apb_slv_sqr
// Project Name: 	ahb2apb_bridge
// Revision 0.01 - File Created 
// Additional Comments:
// -------------------------------------------------------------------------------
// 	-> Definition of apb_sequencer
//	-> Used to Create Abstraction for apb_sequencer Access
//////////////////////////////////////////////////////////////////////////////////

`ifndef APB_SLAVE_SQR_SV
`define APB_SLAVE_SQR_SV

class apb_slv_sqr extends uvm_sequencer #(apb_trans);

	//Factory Registration
	//
	`uvm_component_utils(apb_slv_sqr)
		
	//----------------------------------------------
	// Methods
	// ---------------------------------------------
	// Standard UVM Methods:	
	extern function new(string name = "apb_slv_sqr", uvm_component parent);
	// User Defined Methods:
	
endclass

//Constructor
function apb_slv_sqr::new(string name = "apb_slv_sqr", uvm_component parent);
	super.new(name, parent);
endfunction


`endif