//////////////////////////////////////////////////////////////////////////////////
// Engineer: 		Travis
// 
// Create Date: 	12/21/2020 Mon 19:40
// Filename: 		reset_if.sv
// class Name: 		reset_if
// Project Name: 	ahb2apb_bridge
// Revision 0.01 - File Created 
// Additional Comments:
// -------------------------------------------------------------------------------
// 	-> Reset interface is using for
//////////////////////////////////////////////////////////////////////////////////

interface reset_if(input clk);
	logic	reset;
	
	task reset_dut;
		begin
			reset = 1'b0;
			#5ns;
			reset = 1'b1;
			#2ns;
			reset = 1'b0;
		end
	endtask

endinterface

