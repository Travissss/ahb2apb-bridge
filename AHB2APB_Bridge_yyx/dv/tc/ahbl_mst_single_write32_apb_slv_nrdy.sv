//////////////////////////////////////////////////////////////////////////////////
// Engineer: 		Travis
// 
// Create Date: 	01/12 Mon 20:36
// Filename: 		ahbl_mst_single_write32_apb_slv_nrdy.sv
// class Name: 		ahbl_mst_single_write32_apb_slv_nrdy
// Project Name: 	ahb2apb_bridge
// Revision 0.01 - File Created 
// Additional Comments:
// -------------------------------------------------------------------------------
// 	-> Single, write, word test case, apb with not ready state
//////////////////////////////////////////////////////////////////////////////////

class ahbl_mst_single_write32_apb_slv_nrdy extends ahb2apb_base_test;
	
	//------------------------------------------
	// Data, Interface, port  Members
	//------------------------------------------
	ahbl_mst_single_write32_seq		ahbl_mst_single_write32_seq_i;
	apb_slv_nrdy_seq					apb_slv_nrdy_seq_i;

	
	//Factory Registration
	//
	`uvm_component_utils(ahbl_mst_single_write32_apb_slv_nrdy)
	
	//----------------------------------------------
	// Methods
	// ---------------------------------------------
	// Standard UVM Methods:	
	extern function new(string name = "ahbl_mst_single_write32_apb_slv_nrdy", uvm_component parent);
	extern virtual function void build_phase(uvm_phase phase);
	extern virtual task main_phase(uvm_phase phase);
	// User Defined Methods:
	
endclass

//Constructor
function ahbl_mst_single_write32_apb_slv_nrdy::new(string name = "ahbl_mst_single_write32_apb_slv_nrdy", uvm_component parent);
	super.new(name, parent);
endfunction

//Build_Phase
function void ahbl_mst_single_write32_apb_slv_nrdy::build_phase(uvm_phase phase);
	super.build_phase(phase);
	ahbl_mst_single_write32_seq_i = ahbl_mst_single_write32_seq::type_id::create("ahbl_mst_single_write32_seq_i");
	apb_slv_nrdy_seq_i = apb_slv_nrdy_seq::type_id::create("apb_slv_nrdy_seq_i");
endfunction

//Main_Phase
task ahbl_mst_single_write32_apb_slv_nrdy::main_phase(uvm_phase phase);
	phase.raise_objection(this);
	super.main_phase(phase);
	#100us;
	ahbl_mst_single_write32_seq_i.start(env_i.ahbl_mst_agt_i.sqr_i);
	apb_slv_nrdy_seq_i.start(env_i.apb_slv_agt_i.sqr_i);
	
	phase.drop_objection(this);
endtask

