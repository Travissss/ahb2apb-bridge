//////////////////////////////////////////////////////////////////////////////////
// Engineer: 		Travis
// 
// Create Date: 	11/17/2020 10:20:17 PM
// Filename: 		apb_mem.svh
// class Name: 		apb_mem
// Project Name: 	ahb2apb_bridge
// Revision 0.01 - File Created 
// Additional Comments:
// -------------------------------------------------------------------------------
// 	Save Transfered Package
//	
//////////////////////////////////////////////////////////////////////////////////

class apb_mem #(DW = 32, AW = 32) extends uvm_object;

	//Factory Registration
	//
	`uvm_object_param_utils(apb_mem)
	
	//------------------------------------------
	// Data Members
	//------------------------------------------
	logic [DW-1 : 0] mem [int];	   //assoc Array
	
	//------------------------------------------
	// Constraints
	//------------------------------------------

	//----------------------------------------------
	// Methods
	// ---------------------------------------------
	// Standard UVM Methods:	
	function new(string name = "apb_mem");
		super.new(name);
	endfunction

	// User Defined Methods:
	task put_data(int addr, logic[DW-1:0] data);
		this.mem[addr] = data;
		`uvm_info(get_full_name(), $sformatf("APB-Memory Write. Address: %0h. Data: %0h.", addr, data), UVM_MEDIUM)
	endtask
	
	function logic[DW-1:0] get_data(int addr);
		if(this.mem.exists(addr))begin
			get_data = this.mem[addr];
			`uvm_info(get_full_name(), $sformatf("APB-Memory pre-defined Read. Address: %0h. Data: %0h.", addr, get_data), UVM_MEDIUM)
		end
		else begin
			get_data = $urandom_range(32'hffff_ffff);
			`uvm_info(get_full_name(), $sformatf("APB-Memory un-defined Read. Address: %0h. Data: %0h.", addr, get_data), UVM_MEDIUM)
		end
	endfunction	
	
endclass