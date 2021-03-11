//////////////////////////////////////////////////////////////////////////////////
// Engineer: 		Travis
// 
// Create Date: 	11/15/2020 20:37:17 PM
// Filename: 		apb_if.sv
// class Name: 		apb_if
// Project Name: 	ahb2apb_bridge
// Revision 0.01 - File Created 
// Additional Comments:
// -------------------------------------------------------------------------------
// 	-> Connect media in UVC
//////////////////////////////////////////////////////////////////////////////////

interface apb_if (input pclk, input presetn);
	logic			psel;
	logic			penable;
	logic			pwrite;
	logic			pready;
	logic			pslverr;
	logic [3:0]		pstrb;
	logic [2:0]		pprot;
	logic [31:0]	paddr;
	logic [31:0]	pwdata;
	logic [31:0]	prdata;
	
	clocking slv_cb@(posedge pclk);
	// default input #1 output #1;
		input presetn;
		input psel;
		input penable;
		input pwrite;
		input pstrb;
		input paddr;
		input pwdata;
		input pprot;
		
		output prdata;
		output pready;
		output pslverr;		
	endclocking
	
	clocking mon_cb@(posedge pclk);
	// default input #1 output #1;
		input presetn;
		input psel;
		input penable;
		input pwrite;
		input pstrb;
		input paddr;
		input pwdata;
		input pprot;
		
		input prdata;
		input pready;
		input pslverr;		
	endclocking
	
endinterface