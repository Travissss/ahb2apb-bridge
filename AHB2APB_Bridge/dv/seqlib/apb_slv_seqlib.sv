//////////////////////////////////////////////////////////////////////////////////
// Engineer: 		Travis
// 
// Create Date: 	12/22/2020 Tue 21:09
// Filename: 		apb_slv_seqlib.sv
// class Name: 		apb_slv_seqlib
// Project Name: 	ahb2apb_bridge
// Revision 0.01 - File Created 
// Additional Comments:
// -------------------------------------------------------------------------------
// 	-> sequence library
//////////////////////////////////////////////////////////////////////////////////

`ifndef APB_SLV_SEQLIB_SV
`define APB_SLV_SEQLIB_SV


//////////////////////////////////////////////////////////////////////////////////
// 	-> basic sequence
//////////////////////////////////////////////////////////////////////////////////
class apb_slv_basic_seq extends uvm_sequence #(apb_trans);

	apb_trans req;
	//Factory Registration
	//
	`uvm_object_utils(apb_slv_basic_seq)

	//----------------------------------------------
	// Methods
	// ---------------------------------------------
	// Standard UVM Methods:	
	function new(string name = "apb_slv_basic_seq");
		super.new(name);
	endfunction
	
	virtual task pre_body();
		if(starting_phase != null) begin
			starting_phase.raise_objection(this);
		end
	endtask
	
	virtual task post_body();
		if(starting_phase != null) begin
			starting_phase.drop_objection(this);
		end
	endtask
	
endclass

//////////////////////////////////////////////////////////////////////////////////
// 	-> no wait state sequence
//////////////////////////////////////////////////////////////////////////////////
class apb_slv_rdy_seq extends apb_slv_basic_seq;

	//Factory Registration
	//
	`uvm_object_utils(apb_slv_rdy_seq)

	//----------------------------------------------
	// Methods
	// ---------------------------------------------
	// Standard UVM Methods:	
	function new(string name = "apb_slv_rdy_seq");
		super.new(name);
	endfunction
	
	virtual task body();
		`uvm_do_with(req, {	pslverr		== 1'b0;
							nready_num 	== 0;})
	endtask
		
endclass

//////////////////////////////////////////////////////////////////////////////////
// 	-> sequence with wait state
//////////////////////////////////////////////////////////////////////////////////
class apb_slv_nrdy_seq extends apb_slv_basic_seq;

	//Factory Registration
	//
	`uvm_object_utils(apb_slv_nrdy_seq)

	//----------------------------------------------
	// Methods
	// ---------------------------------------------
	// Standard UVM Methods:	
	function new(string name = "apb_slv_nrdy_seq");
		super.new(name);
	endfunction
	
	virtual task body();
		`uvm_do_with(req, {	pslverr		== 1'b0;
							nready_num 	inside {[1:5]};})
	endtask
		
endclass


//////////////////////////////////////////////////////////////////////////////////
// 	-> sequence with error and wait states
//////////////////////////////////////////////////////////////////////////////////
class apb_slv_slverr_seq extends apb_slv_basic_seq;

	//Factory Registration
	//
	`uvm_object_utils(apb_slv_slverr_seq)

	//----------------------------------------------
	// Methods
	// ---------------------------------------------
	// Standard UVM Methods:	
	function new(string name = "apb_slv_slverr_seq");
		super.new(name);
	endfunction
	
	virtual task body();
		`uvm_do_with(req, {	pslverr		== 1'b1;
							nready_num 	inside {[1:5]};})
	endtask
		
endclass
`endif