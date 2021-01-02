//////////////////////////////////////////////////////////////////////////////////
// Engineer: 		Travis
// 
// Create Date: 	12/23/2020 Wed 22:01
// Filename: 		ahb2apb_pkg.svh
// class Name: 		ahb2apb_pkg
// Project Name: 	ahb2apb_bridge
// Revision 0.01 - File Created
// Additional Comments:
// -------------------------------------------------------------------------------
//////////////////////////////////////////////////////////////////////////////////

package ahb2apb_pkg;
	`include "uvm_macros.svh"
	import uvm_pkg::*;
	
	import ahbl_mst_pkg::*;
	import apb_slv_pkg::*;
	
	`include "func_cov.sv"
	`include "ahb2apb_scb.svh"
	`include "ahb2apb_env.sv"


endpackage