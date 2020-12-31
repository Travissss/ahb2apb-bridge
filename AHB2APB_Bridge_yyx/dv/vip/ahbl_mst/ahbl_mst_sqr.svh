//////////////////////////////////////////////////////////////////////////////////
// Engineer: 		Travis
// 
// Create Date: 	12/04/2020
// Filename: 		ahbl_mst_sqr.svh
// class Name: 		ahbl_mst_sqr
// Project Name: 	ahb2apb_bridge
// Revision 0.01 - File Created 
// Additional Comments:
// -------------------------------------------------------------------------------
// 	-> Definition of ahbl_sequencer
//////////////////////////////////////////////////////////////////////////////////

`ifndef AHBL_MST_SQR_SV
`define AHBL_MST_SQR_SV
class ahbl_mst_sqr extends uvm_sequencer #(ahbl_trans);
	
	//Factory Registration
	//
	`uvm_component_utils(ahbl_mst_sqr)
		
	//----------------------------------------------
	// Methods
	// ---------------------------------------------
	// Standard UVM Methods:	
	extern function new(string name = "ahbl_mst_sqr", uvm_component parent);
	// User Defined Methods:


endclass

//Constructor
function ahbl_mst_sqr::new(string name = "ahbl_mst_sqr", uvm_component parent);
	super.new(name, parent);
endfunction

`endif