//////////////////////////////////////////////////////////////////////////////////
// Engineer: 		Travis
// 
// Create Date: 	11/17/2020
// Filename: 		apb_slv_mon.svh
// class Name: 		apb_slv_mon
// Project Name: 	ahb2apb_bridge
// Revision 0.01 - File Created 
// Additional Comments:
// -------------------------------------------------------------------------------
// 	-> Get Virtual Interface from ENV Configuration
//	-> Collect APB Transaction on to AHB-APB Bridge
//////////////////////////////////////////////////////////////////////////////////

`ifndef APB_SLAVE_MON_SV
`define APB_SLAVE_MON_SV
class apb_slv_mon extends uvm_monitor;

	//Factory Registration
	`uvm_component_utils(apb_slv_mon)
	
	//------------------------------------------
	// Data, Interface, port  Members
	//------------------------------------------
	virtual apb_if		vif;

	uvm_analysis_port#(apb_trans) 	ap;

	//----------------------------------------------
	// Methods
	// ---------------------------------------------
	// Standard UVM Methods:	
	extern function new(string name = "apb_slv_mon", uvm_component parent);
	extern virtual function void build_phase(uvm_phase phase);
	extern virtual task main_phase(uvm_phase phase);
	// User Defined Methods:
		
endclass

//Constructor
function apb_slv_mon::new(string name = "apb_slv_mon", uvm_component parent);
	super.new(name, parent);
endfunction

//Build_Phase
function void apb_slv_mon::build_phase(uvm_phase phase);
	super.build_phase(phase);
	ap = new("ap", this);
	if(!uvm_config_db #(virtual apb_if)::get(this,"","vif",vif))
		`uvm_fatal("No vif", "vif is not found")
endfunction

//Main_Phase
task apb_slv_mon::main_phase(uvm_phase phase);
	apb_trans pkt;
	while(1) begin
		@(vif.mon_cb);
		if(vif.mon_cb.penable && vif.mon_cb.pready && vif.mon_cb.psel && vif.mon_cb.presetn) begin
			pkt 		= apb_trans::type_id::create("pkt");
			pkt.paddr 	= vif.mon_cb.paddr		;
			pkt.pslverr	= vif.mon_cb.pslverr	;	
			pkt.penable	= vif.mon_cb.penable	;	
			pkt.pselx	= vif.mon_cb.psel		;
			pkt.pprot	= vif.mon_cb.pprot		;			
			pkt.kind	= vif.mon_cb.pwrite ? WRITE : READ;
			pkt.data	= vif.mon_cb.pwdata;
            pkt.prdata	= vif.mon_cb.prdata;
			ap.write(pkt);
		end
	end
endtask

`endif
