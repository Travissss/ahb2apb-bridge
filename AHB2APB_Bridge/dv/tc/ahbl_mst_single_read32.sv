//////////////////////////////////////////////////////////////////////////////////
// Engineer: 		Travis
// 
// Create Date: 	12/29/2020 Tue 16:40
// Filename: 		ahbl_mst_single_read32.sv
// class Name: 		ahbl_mst_single_read32
// Project Name: 	ahb2apb_bridge
// Revision 0.01 - File Created 
// Additional Comments:
// -------------------------------------------------------------------------------
// 	-> Single, read, word test case, including the same sequence
//////////////////////////////////////////////////////////////////////////////////

class ahbl_mst_single_read32 extends ahb2apb_base_test;
	
	//------------------------------------------
	// Data, Interface, port  Members
	//------------------------------------------
	ahbl_mst_single_read32_seq		ahbl_mst_single_read32_seq_i;
	apb_slv_rdy_seq					apb_slv_rdy_seq_i;

	
	//Factory Registration
	//
	`uvm_component_utils(ahbl_mst_single_read32)
	
	//----------------------------------------------
	// Methods
	// ---------------------------------------------
	// Standard UVM Methods:	
	extern function new(string name = "ahbl_mst_single_read32", uvm_component parent);
	extern virtual function void build_phase(uvm_phase phase);
	extern virtual task main_phase(uvm_phase phase);
	// User Defined Methods:
	
endclass

//Constructor
function ahbl_mst_single_read32::new(string name = "ahbl_mst_single_read32", uvm_component parent);
	super.new(name, parent);
endfunction

//Build_Phase
function void ahbl_mst_single_read32::build_phase(uvm_phase phase);
	super.build_phase(phase);
	ahbl_mst_single_read32_seq_i = ahbl_mst_single_read32_seq::type_id::create("ahbl_mst_single_read32_seq_i");
	apb_slv_rdy_seq_i = apb_slv_rdy_seq::type_id::create("apb_slv_rdy_seq_i");
endfunction

//Main_Phase
task ahbl_mst_single_read32::main_phase(uvm_phase phase);
	phase.raise_objection(this);
	super.main_phase(phase);
	#100us;
	ahbl_mst_single_read32_seq_i.start(env_i.ahbl_mst_agt_i.sqr_i);
	apb_slv_rdy_seq_i.start(env_i.apb_slv_agt_i.sqr_i);
	
	phase.drop_objection(this);
endtask

