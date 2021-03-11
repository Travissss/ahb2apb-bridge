//////////////////////////////////////////////////////////////////////////////////
// Engineer: 		Travis
// 
// Create Date: 	12/17/2020 Thu 20:53
// Filename: 		func_cov.sv
// class Name: 		func_cov
// Project Name: 	ahb2apb_bridge
// Revision 0.01 - File Created 
// Additional Comments:
// -------------------------------------------------------------------------------
// 	-> Collect coverage info
//////////////////////////////////////////////////////////////////////////////////

class func_cov extends uvm_object;
	//ahbl_trans	ahb_pkt;
	//apb_trans		apb_pkt;
	
	covergroup cg with function sample(ahbl_trans ahb_pkt, apb_trans apb_pkt);
		option.per_instance = 1;
		haddr: coverpoint ahb_pkt.haddr [15:0] {bins a1		= {16'h0000};
												bins a2		= {16'h0001};
												bins a3		= {16'hffff};
												bins a4		= {16'hfffe};
												bins a5[4] 	= {[16'h0002 : 16'hfffd]};
												}
		hwrite		:	coverpoint ahb_pkt.hwrite;
		hburst		:	coverpoint ahb_pkt.hburst;
		hsize		:	coverpoint ahb_pkt.hsize;  
		clk_ratio	:	coverpoint ahb_pkt.clk_ratio[3:0]{	bins c0	= {4'h1};
															bins c1	= {4'h2};
															bins c2	= {4'h4};
															bins c3	= {4'h8};
															}  
	
		cross haddr, hwrite, hburst, hsize;
	endgroup
	//----------------------------------------------
	// Methods
	// ---------------------------------------------
	// Standard UVM Methods:	
	function new(string name = "func_cov");
		super.new(name);
		cg = new();
		cg.set_inst_name({get_full_name(), ".", name, ".cg"});
	endfunction
	// User Defined Methods:
	
endclass

