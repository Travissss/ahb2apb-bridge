//////////////////////////////////////////////////////////////////////////////////
// Engineer: 		Travis
// 
// Create Date: 	01/15 Fri 17:24
// Filename: 		ahbl_mst_tight_transfer.sv
// class Name: 		ahbl_mst_tight_transfer
// Project Name: 	ahb2apb_bridge
// Revision 0.01 - File Created 
// Additional Comments:
// -------------------------------------------------------------------------------
// 	-> burst transfer
//////////////////////////////////////////////////////////////////////////////////

class ahbl_mst_tight_transfer extends ahb2apb_base_test;
	
	//------------------------------------------
	// Data, Interface, port  Members
	//------------------------------------------
	ahbl_mst_burst_seq		ahbl_mst_burst_seq_0;
	ahbl_mst_burst_seq		ahbl_mst_burst_seq_1;
	apb_slv_nrdy_seq		apb_slv_nrdy_seq_i;

	
	//Factory Registration
	//
	`uvm_component_utils(ahbl_mst_tight_transfer)
	
	//----------------------------------------------
	// Methods
	//----------------------------------------------
	// Standard UVM Methods:	
	extern function new(string name = "ahbl_mst_tight_transfer", uvm_component parent);
	extern virtual function void build_phase(uvm_phase phase);
	extern virtual task main_phase(uvm_phase phase);
	// User Defined Methods:
	
endclass

//Constructor
function ahbl_mst_tight_transfer::new(string name = "ahbl_mst_tight_transfer", uvm_component parent);
	super.new(name, parent);
endfunction

//Build_Phase
function void ahbl_mst_tight_transfer::build_phase(uvm_phase phase);
	super.build_phase(phase);
	ahbl_mst_burst_seq_0 = ahbl_mst_burst_seq::type_id::create("ahbl_mst_burst_seq_0");
	ahbl_mst_burst_seq_1 = ahbl_mst_burst_seq::type_id::create("ahbl_mst_burst_seq_1");
	apb_slv_nrdy_seq_i = apb_slv_nrdy_seq::type_id::create("apb_slv_nrdy_seq_i");
endfunction

//Main_Phase
task ahbl_mst_tight_transfer::main_phase(uvm_phase phase);
	int num_apb_seq;
	phase.raise_objection(this);
	super.main_phase(phase);
	#100us;
	fork
		begin
			ahbl_mst_burst_seq_0.start(env_i.ahbl_mst_agt_i.sqr_i);			
			ahbl_mst_burst_seq_1.start(env_i.ahbl_mst_agt_i.sqr_i);	
		end
		begin
			num_apb_seq = 0;
			while(1) begin
				apb_slv_nrdy_seq_i.start(env_i.apb_slv_agt_i.sqr_i);
				num_apb_seq++;
				if(num_apb_seq >= ahbl_mst_burst_seq_0.req.get_bst_beats()) begin
					num_apb_seq = 0;
					break;
				end
			end
			
			while(1) begin
				apb_slv_nrdy_seq_i.start(env_i.apb_slv_agt_i.sqr_i);
				num_apb_seq++;
				if(num_apb_seq >= ahbl_mst_burst_seq_1.req.get_bst_beats())
					break;
			end
		end
	join
	phase.drop_objection(this);
endtask

