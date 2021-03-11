//////////////////////////////////////////////////////////////////////////////////
// Engineer: 		Travis
// 
// Create Date: 	12/23/2020 Wed 21:36
// Filename: 		ahb2apb_base_test.svh
// class Name: 		ahb2apb_base_test
// Project Name: 	ahb2apb_bridge
// Revision 0.01 - File Created 
// Additional Comments:
// -------------------------------------------------------------------------------
// 	-> test top include ahb2apb_env,
//////////////////////////////////////////////////////////////////////////////////

import ahb2apb_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"
class ahb2apb_base_test extends uvm_test;


	
	//------------------------------------------
	// Data, Interface, port  Members
	//------------------------------------------
	virtual reset_if	reset_if_i;
	
	//------------------------------------------
	// Sub Components
	//------------------------------------------
	ahb2apb_env	env_i;
	
	//Factory Registration
	//
	`uvm_component_utils(ahb2apb_base_test)

	//----------------------------------------------
	// Methods
	// ---------------------------------------------
	// Standard UVM Methods:	
	extern function new(string name = "ahb2apb_base_test", uvm_component parent);
	extern virtual function void build_phase(uvm_phase phase);
	extern virtual function void start_of_simulation_phase(uvm_phase phase);
	extern virtual task main_phase(uvm_phase phase);
	extern virtual function void report_phase(uvm_phase phase);
	// User Defined Methods:
	extern function int num_uvm_errors();
endclass

//Constructor
function ahb2apb_base_test::new(string name = "ahb2apb_base_test", uvm_component parent);
	super.new(name, parent);
endfunction

//Build_Phase
function void ahb2apb_base_test::build_phase(uvm_phase phase);
	super.build_phase(phase);
	env_i = ahb2apb_env::type_id::create("env_i", this);

	uvm_config_db#(uvm_active_passive_enum)::set(this,"env_i.ahbl_mst_agt_i", "is_active", UVM_ACTIVE);
	uvm_config_db#(uvm_active_passive_enum)::set(this,"env_i.apb_slv_agt_i", "is_active", UVM_ACTIVE);
	if(!uvm_config_db#(virtual reset_if)::get(this, "", "vif", reset_if_i))
		`uvm_fatal("No reset_if", "reset_if_i is not set!")
endfunction

//start_of_simulation_phase
function void ahb2apb_base_test::start_of_simulation_phase(uvm_phase phase);
	super.start_of_simulation_phase(phase);
	uvm_top.print_topology();
endfunction
	
//Main_Phase
task ahb2apb_base_test::main_phase(uvm_phase phase);
	reset_if_i.reset_dut;
	
	phase.phase_done.set_drain_time(this, 15us);
endtask

function void ahb2apb_base_test::report_phase(uvm_phase phase);
	super.report_phase(phase);
	if(num_uvm_errors == 0)begin
		`uvm_info(get_type_name(), "Simulation Passed!", UVM_NONE)
	end
	else begin
		`uvm_info(get_type_name(), "Simulation Failed!", UVM_NONE)
	end
endfunction

function int ahb2apb_base_test::num_uvm_errors();
	uvm_report_server server;
	if(server == null)
		server = get_report_server();
	return server.get_severity_count(UVM_ERROR);
endfunction
