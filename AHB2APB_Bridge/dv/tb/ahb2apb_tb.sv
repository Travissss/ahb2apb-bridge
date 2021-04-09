

//////////////////////////////////////////////////////////////////////////////////
// Engineer: 		Travis
// 
// Create Date: 	12/21/2020 Mon 
// Filename: 		ahb2apb_tb.v
// class Name: 		ahb2apb_tb
// Project Name: 	ahb2apb_bridge
// Revision 0.01 - File Created 
// Additional Comments:
// -------------------------------------------------------------------------------
// 	-> Test bench include interface, DUT. And need to set interface
//////////////////////////////////////////////////////////////////////////////////

`include "uvm_macros.svh"
import uvm_pkg::*;
import ahbl_mst_pkg::*;
import apb_slv_pkg::*;

module ahb2apb_tb();
	parameter 		HCLK_PERIOD = 100ns;		//10MHz
	bit 	[1:0] 	tmp_var;
	logic	[3:0]	HCLK_PCLK_RATIO;

	reg				hclk;
	wire			pclk;
	wire			hresetn;
	wire			presetn;
	reg		[3:0]	hclk_cnt;
	reg				pclk_en;
	reg				pclk_en_r;
	wire 			apb_active;

//Interfaces;
ahbl_if		ahbl_if_i(hclk, hresetn);
apb_if		apb_if_i(pclk, presetn);
reset_if	reset_if_i(hclk);

initial begin

	tmp_var = $urandom_range(0, 3);

end
//generate HCLK_PCLK_RATIO randomly;

//assign HCLK_PCLK_RATIO = ((ahbl_if_i.clk_ratio == 0) ? 1: ((ahbl_if_i.clk_ratio == 1) ? 2 :((ahbl_if_i.clk_ratio == 2) ? 4 : 8)));
// assign HCLK_PCLK_RATIO = ahbl_if_i.clk_ratio;

always@(hclk)
begin
	case(tmp_var)
		0:HCLK_PCLK_RATIO = 1;
		1:HCLK_PCLK_RATIO = 2;
		2:HCLK_PCLK_RATIO = 4;
		3:HCLK_PCLK_RATIO = 8;
	endcase
	
end

//generate hclk with HCLK_PERIOD/2;
initial begin
	hclk = 1'b0;
	forever begin
		#(HCLK_PERIOD/2);
		hclk = ~hclk;
	end
end

//generate hresetn, presetn;
assign hresetn = ~reset_if_i.reset;
assign presetn = hresetn;

//generate pclken for pclk
always@(posedge hclk or negedge hresetn)
begin
	if(!hresetn)
		hclk_cnt <= 4'b0;
	else if(hclk_cnt == HCLK_PCLK_RATIO - 1'b1)
		hclk_cnt <= 4'b0;
	else 
		hclk_cnt <= hclk_cnt + 1'b1;
end

always@(negedge hclk or negedge hresetn)
begin
	if(!presetn)
		pclk_en <= 1'b0;
	else if(hclk_cnt == HCLK_PCLK_RATIO - 1'b1)
		pclk_en <= 1'b1;
	else 
		pclk_en <= 1'b0;
end

always@(*) begin
	#1ns;
	pclk_en_r = pclk_en;
end

//generate pclk	
assign pclk = pclk_en_r & hclk;
	
cmsdk_ahb_to_apb #(
	.ADDRWIDTH		(16),
	.REGISTER_RDATA	(1),
	.REGISTER_WDATA	(0)
) DUT (
			.HCLK		( hclk					),    
			.HRESETn	( hresetn				), 
			.PCLKEN		( pclk_en				),  
						  
			.HSEL		( ahbl_if_i.hsel		),    
			.HADDR		( ahbl_if_i.haddr[15:0]	),   
			.HTRANS		( ahbl_if_i.htrans		),  
			.HSIZE		( ahbl_if_i.hsize		),   
			.HPROT		( ahbl_if_i.hprot		),	   
			.HWRITE		( ahbl_if_i.hwrite		),  
			.HREADY		( ahbl_if_i.hready		),  
			.HWDATA		( ahbl_if_i.hwdata		),  
						  
/*output*/	.HREADYOUT	( ahbl_if_i.hready		),
/*output*/	.HRDATA		( ahbl_if_i.hrdata		),  
/*output*/	.HRESP		( ahbl_if_i.hresp		),   
						  
/*output*/	.PADDR		( apb_if_i.paddr[15:0]	),   
/*output*/	.PENABLE	( apb_if_i.penable		), 
/*output*/	.PWRITE		( apb_if_i.pwrite		),  
/*output*/	.PSTRB		( apb_if_i.pstrb		),   
/*output*/	.PPROT		( apb_if_i.pprot		),   
/*output*/	.PWDATA		( apb_if_i.pwdata		),  
/*output*/	.PSEL		( apb_if_i.psel			),    
						  
/*output*/	.APBACTIVE	( apbactive			),
						  
			.PRDATA		( apb_if_i.prdata		),  
			.PREADY		( apb_if_i.pready		),  
			.PSLVERR	( apb_if_i.pslverr		)
);
	
	
assign apb_if_i.paddr[31:16] = 16'b0;

initial begin
	uvm_config_db#(virtual ahbl_if)::set(null, "uvm_test_top.env_i.ahbl_mst_agt_i", "vif", ahbl_if_i);
	uvm_config_db#(virtual apb_if)::set(null, "uvm_test_top.env_i.apb_slv_agt_i", "vif", apb_if_i);
	uvm_config_db#(virtual reset_if)::set(null, "uvm_test_top", "vif", reset_if_i);
	run_test();
end

//----------------------------------------------
// Assertion examples 
// ---------------------------------------------
property p_psel_high_then_apbactive_high;
	@(posedge pclk) disable iff(!hresetn)
	apb_if_i.psel |-> apbactive;
	//apb_if_i.psel |-> apbactive;
endproperty

property p_apbactive_high_then_psel_high;
	@(posedge pclk) disable iff(!hresetn)
	$rose(apbactive) |=> apb_if_i.psel; 
endproperty

property p_hresp_hready;
	@(posedge hclk) disable iff(!hresetn)
	ahbl_if_i.hresp |-> ahbl_if_i.hready && !$past(ahbl_if_i.hready);
endproperty

a_psel_high_then_apbactive_high : assert property(p_psel_high_then_apbactive_high);
a_apbactive_high_then_psel_high : assert property(p_apbactive_high_then_psel_high);
a_hresp_hready 					: assert property(p_hresp_hready);
//----------------------------------------------
// covergroups
// ---------------------------------------------

covergroup cg_hclk_pclk_ratio();
	option.per_instance = 1;
	option.name = "cg_hclk_pclk_ratio";
	
	hclk_pclk_ratio: coverpoint HCLK_PCLK_RATIO[3:0] {
		bins h0 = {4'h1};
		bins h1 = {4'h2};
		bins h2 = {4'h4};
		bins h3 = {4'h8};}
endgroup

//covergroup cg_tmp_var_ratio();
//	option.per_instance = 1;
//	option.name = "cg_tmp_var_ratio";
//	
//	tmp_var_ratio: coverpoint tmp_var;
//endgroup
cg_hclk_pclk_ratio cg_hclk_pclk_ratio_i = new() ;
//cg_tmp_var_ratio cg_tmp_var_ratio_i = new();

always@(posedge hresetn)begin 
	cg_hclk_pclk_ratio_i.sample();
	//cg_tmp_var_ratio_i.sample();
end
`ifdef  DUMP_FSDB
initial begin
	$fsdbDumpfile("ahb2apb_bridge.fsdb");
	$fsdbDumpvars;
	$fsdbDumpSVA;
end
`endif
endmodule
