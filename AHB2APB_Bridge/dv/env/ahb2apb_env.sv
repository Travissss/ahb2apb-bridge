//////////////////////////////////////////////////////////////////////////////////
// Engineer: 		Travis
// 
// Create Date: 	12/21/2020 Mon 20:25
// Filename: 		ahb2apb_env.svh
// class Name: 		ahb2apb_env
// Project Name: 	ahb2apb_bridge
// Revision 0.01 - File Created 
// Additional Comments:
// -------------------------------------------------------------------------------
// 	-> Environment contains ahb_agt apb_agt and scoreboard
//////////////////////////////////////////////////////////////////////////////////

`ifndef AHB2APB_ENV_SV
`define AHB2APB_ENV_SV

class ahb2apb_env extends uvm_env;

	//------------------------------------------
	// Data, Interface, port  Members
	//------------------------------------------
	uvm_tlm_analysis_fifo #(ahbl_trans)	ahbl_fifo;
	uvm_tlm_analysis_fifo #(apb_trans)	apb_fifo;
	
	//------------------------------------------
	// Sub Components
	//------------------------------------------
	ahbl_mst_agt 	ahbl_mst_agt_i;
	apb_slv_agt		apb_slv_agt_i;
	ahb2apb_scb		ahb2apb_scb_i;
		
	//Factory Registration
	//
	`uvm_component_utils(ahb2apb_env)

	//----------------------------------------------
	// Methods
	// ---------------------------------------------
	// Standard UVM Methods:	
	extern function new(string name = "ahb2apb_env", uvm_component parent);
	extern virtual function void build_phase(uvm_phase phase);
	extern virtual function void connect_phase(uvm_phase phase);
	
endclass

//Constructor
function ahb2apb_env::new(string name = "ahb2apb_env", uvm_component parent);
	super.new(name, parent);
endfunction

//Build_Phase
function void ahb2apb_env::build_phase(uvm_phase phase);
	super.build_phase(phase);
	ahbl_mst_agt_i	= ahbl_mst_agt::type_id::create("ahbl_mst_agt_i", this);
	apb_slv_agt_i	= apb_slv_agt::type_id::create("apb_slv_agt_i", this);
	ahb2apb_scb_i	= ahb2apb_scb::type_id::create("ahb2apb_scb_i", this);
	ahbl_fifo	= new("ahbl_fifo", this);
	apb_fifo	= new("apb_fifo", this);
	
endfunction

//
function void ahb2apb_env::connect_phase(uvm_phase phase);
	super.connect_phase(phase);
	ahbl_mst_agt_i.mon_i.ap.connect(ahbl_fifo.analysis_export);
	apb_slv_agt_i.mon_i.ap.connect(apb_fifo.analysis_export);
	
	ahb2apb_scb_i.ahbl_port.connect(ahbl_fifo.blocking_get_export);
	ahb2apb_scb_i.apb_port.connect(apb_fifo.blocking_get_export);
endfunction

`endif