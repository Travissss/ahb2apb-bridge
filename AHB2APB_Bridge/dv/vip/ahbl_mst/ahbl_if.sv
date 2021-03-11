//////////////////////////////////////////////////////////////////////////////////
// Engineer: 		Travis
// 
// Create Date: 	12/03/2020 23:35:17 PM
// Filename: 		ahbl_if.sv
// class Name: 		ahbl_if
// Project Name: 	ahb2apb_bridge
// Revision 0.01 - File Created 
// Additional Comments:
// -------------------------------------------------------------------------------
// 	-> Connect media in UVC
//////////////////////////////////////////////////////////////////////////////////

interface ahbl_if(input hclk, input hresetn);
	logic 			hsel;
	logic	[31:0]	haddr;
	logic	[1:0]	htrans;
	logic	[2:0]	hsize;
	logic	[2:0]	hburst;
	logic	[3:0]	hprot;
	logic			hwrite;
	logic	[31:0]	hwdata;
	
	logic	[31:0]	hrdata;
	logic			hready;
	logic			hresp;
	bit		[3:0]	clk_ratio;
	
	clocking mst_cb@(posedge hclk);
		// default input #1 output #1;
		input	hresetn;
		output	hsel;
		output	haddr;
		output	htrans;
		output	hsize;
		output	hburst;
		output	hprot;
		output	hwrite;
		output	hwdata;
		output 	clk_ratio;
		
		input 	hrdata;
		input 	hready;
		input 	hresp;
	endclocking
	
	clocking mon_cb@(posedge hclk);
		// default input #1 output #1;
		input 	hresetn;
		input 	hsel;
		input 	haddr;
		input 	htrans;
		input 	hsize;
		input 	hburst;
		input 	hprot;
		input 	hwrite;
		input 	hwdata;
		
		input 	hrdata;
		input 	hready;
		input 	hresp;
		input 	clk_ratio;
	endclocking

endinterface

