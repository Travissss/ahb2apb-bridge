//////////////////////////////////////////////////////////////////////////////////
// Engineer: 		Travis
// 
// Create Date: 	11/13/2020
// Filename: 		apb_transaction.svh
// class Name: 		apb_tran
// Project Name: 	ahb2apb_bridge
// Revision 0.01 - File Created
// Additional Comments:
// -------------------------------------------------------------------------------
//////////////////////////////////////////////////////////////////////////////////

class apb_trans extends uvm_sequence_item;
	rand logic [31:0] 	paddr;		//APB Address bus
	rand logic [31:0] 	data;		//Write data;
	rand logic [31:0] 	prdata;		//Read data;
	rand logic [2:0] 	pprot;		//Protection type. normal, privileged, or secure protection leve
	rand logic [3:0] 	pstrb;		//Write strobes. This signal indicates which byte lanes to update during a write transfer. 
	rand kind_t 		kind;		//Direction, 1 : write, 0 : read;
	rand bit			pslverr;	//Transfer failure when high;
	rand bit 			penable;	//Enable, low in setup stage, high in access stage;
	rand bit 			pselx;		//high in both setup and access stage
	rand int unsigned 	nready_num;
	
	//Factory Registration
	`uvm_object_utils_begin(apb_trans)
		`uvm_field_int(paddr, UVM_ALL_ON)
		`uvm_field_int(data, UVM_ALL_ON)
		`uvm_field_int(prdata, UVM_ALL_ON)	
		`uvm_field_int(pprot, UVM_ALL_ON)
		`uvm_field_int(pstrb, UVM_ALL_ON)
		`uvm_field_enum(kind_t, kind, UVM_ALL_ON)
		`uvm_field_int(pslverr, UVM_ALL_ON)
		`uvm_field_int(penable, UVM_ALL_ON)	
		`uvm_field_int(pselx, UVM_ALL_ON)
		`uvm_field_int(nready_num, UVM_ALL_ON)
	`uvm_object_utils_end
	
	//----------------------------------------------
	// Methods
	// ---------------------------------------------
	// Standard UVM Methods:
	function new(string name = "apb_trans");
		super.new(name);
	endfunction
	
endclass





























