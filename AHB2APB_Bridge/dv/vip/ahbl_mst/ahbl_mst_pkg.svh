
//////////////////////////////////////////////////////////////////////////////////
// Engineer: 		Travis
// 
// Create Date: 	12/16/2020 WED 10:38
// Filename: 		ahbl_mst_pkg.svh
// class Name: 		ahbl_mst_pkg
// Project Name: 	ahb2apb_bridge
// Revision 0.01 - File Created
// Additional Comments:
// -------------------------------------------------------------------------------
//////////////////////////////////////////////////////////////////////////////////
	`ifndef AHBL_MST_PKG_SV
	`define AHBL_MST_PKG_SV

	`include "ahbl_if.sv" 

	package ahbl_mst_pkg;
		import uvm_pkg::*;
		`include "uvm_macros.svh"
		typedef enum logic [1:0] {	IDLE = 2'b00, 
									BUSY = 2'b01,
									NSEQ = 2'b10,
									SEQ	 = 2'b11} htrans_t;
		typedef enum logic [2:0] {	SINGLE 	= 3'b000,
									INCR	= 3'b001,
									WRAP4	= 3'b010,
									INCR4	= 3'b011,
									WRAP8	= 3'b100,
									INCR8	= 3'b101,
									WRAP16	= 3'b110,
									INCR16	= 3'b111
									} hburst_t;
		
		typedef enum logic [2:0] {	BYTE 	= 3'b000,  
									HWORD	= 3'b001,
									WORD	= 3'b010} hsize_t;	
		
		`include "ahbl_trans.svh"
		`include "ahbl_mst_drv.svh"
		`include "ahbl_mst_sqr.svh"
		`include "ahbl_mst_mon.svh"
		`include "ahbl_mst_agt.svh"

	endpackage

	`endif



