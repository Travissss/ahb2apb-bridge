//////////////////////////////////////////////////////////////////////////////////
// Engineer: 		Travis
// 
// Create Date: 	12/23/2020 Wed 21:13
// Filename: 		ahbl_mst_seqlib.sv
// class Name: 		ahbl_mst_seqlib
// Project Name: 	ahb2apb_bridge
// Revision 0.01 - File Created 
// Additional Comments:
// -------------------------------------------------------------------------------
// 	-> ahbl sequence library
//////////////////////////////////////////////////////////////////////////////////

`ifndef AHBL_MST_SEQLIB_SV
`define AHBL_MST_SEQLIB_SV


//////////////////////////////////////////////////////////////////////////////////
// 	-> basic sequence
//////////////////////////////////////////////////////////////////////////////////
class ahbl_mst_basic_seq extends uvm_sequence #(ahbl_trans);

	ahbl_trans req;
	//Factory Registration
	//
	`uvm_object_utils(ahbl_mst_basic_seq)

	//----------------------------------------------
	// Methods
	// ---------------------------------------------
	// Standard UVM Methods:	
	function new(string name = "ahbl_mst_basic_seq");
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
// 	-> sequence with burst state?
//////////////////////////////////////////////////////////////////////////////////
class ahbl_mst_burst_seq extends ahbl_mst_basic_seq;

	//Factory Registration
	//
	`uvm_object_utils(ahbl_mst_burst_seq)

	//----------------------------------------------
	// Methods
	// ---------------------------------------------
	// Standard UVM Methods:	
	function new(string name = "ahbl_mst_burst_seq");
		super.new(name);
	endfunction
	
	virtual task body();
		`uvm_do_with(req, {	hsel == 1'b1; //})
							hburst inside {[2:7]};
							})

	endtask
		
endclass

//////////////////////////////////////////////////////////////////////////////////
// 	-> single word read sequence
//////////////////////////////////////////////////////////////////////////////////
class ahbl_mst_single_read32_seq extends ahbl_mst_basic_seq;

	//Factory Registration
	//
	`uvm_object_utils(ahbl_mst_single_read32_seq)

	//----------------------------------------------
	// Methods
	// ---------------------------------------------
	// Standard UVM Methods:	
	function new(string name = "ahbl_mst_single_read32_seq");
		super.new(name);
	endfunction
	
	virtual task body();
		`uvm_do_with(req, {	hsel 	== 1'b1;
							htrans 	== ahbl_mst_pkg::NSEQ;
							hsize	== ahbl_mst_pkg::WORD;
							hburst	== ahbl_mst_pkg::SINGLE;
							hwrite	== 1'b0;})
	endtask
		
endclass


//////////////////////////////////////////////////////////////////////////////////
// 	-> single word write sequence
//////////////////////////////////////////////////////////////////////////////////
class ahbl_mst_single_write32_seq extends ahbl_mst_basic_seq;

	//Factory Registration
	//
	`uvm_object_utils(ahbl_mst_single_write32_seq)

	//----------------------------------------------
	// Methods
	// ---------------------------------------------
	// Standard UVM Methods:	
	function new(string name = "ahbl_mst_single_write32_seq");
		super.new(name);
	endfunction
	
	virtual task body();
		`uvm_do_with(req, {	hsel	== 1'b1;
							htrans	== ahbl_mst_pkg::NSEQ;
							hsize	== ahbl_mst_pkg::WORD;
							hburst	== ahbl_mst_pkg::SINGLE;
							hwrite	== 1'b1;})
	endtask
		
endclass
`endif
