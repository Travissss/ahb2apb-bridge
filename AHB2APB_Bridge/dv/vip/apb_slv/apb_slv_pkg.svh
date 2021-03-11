//////////////////////////////////////////////////////////////////////////////////
// Engineer: 		Travis
// 
// Create Date: 	11/13/2020 Wed 16:36
// Filename: 		apb_slv_pkg.svh
// class Name: 		apb_slv_pkg
// Project Name: 	ahb2apb_bridge
// Revision 0.01 - File Created
// Additional Comments:
// -------------------------------------------------------------------------------
//////////////////////////////////////////////////////////////////////////////////
	`ifndef APB_SLAVE_PKG_SV
	`define APB_SLAVE_PKG_SV

	`include "apb_if.sv" 

	package apb_slv_pkg;
		import uvm_pkg::*;
		`include "uvm_macros.svh"
		typedef enum {READ, WRITE} kind_t;
		
		`include "apb_mem.svh"
		`include "apb_trans.svh"
		`include "apb_slv_drv.svh"
		`include "apb_slv_sqr.svh"
		`include "apb_slv_mon.svh"
		`include "apb_slv_agt.svh"

	endpackage

	`endif


