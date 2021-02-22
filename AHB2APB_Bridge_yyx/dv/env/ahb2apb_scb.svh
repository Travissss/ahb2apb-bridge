
//////////////////////////////////////////////////////////////////////////////////
// Engineer: 		Travis
// 
// Create Date: 	12/17/2020 Thu 10:30
// Filename: 		ahb2apb_scb.svh
// class Name: 		ahb2apb_scb
// Project Name: 	ahb2apb_bridge
// Revision 0.01 - File Created 
// Additional Comments:
// -------------------------------------------------------------------------------
// 	-> Compare AHBL pkt with apb pkt 
//////////////////////////////////////////////////////////////////////////////////

class ahb2apb_scb extends uvm_scoreboard;


	
	//------------------------------------------
	// Data, Interface, port  Members
	//------------------------------------------
	uvm_blocking_get_port #(apb_trans) 	apb_port;
	uvm_blocking_get_port #(ahbl_trans)	ahbl_port;
	
	func_cov	fcov;

	//Factory Registration
	//
	`uvm_component_utils(ahb2apb_scb)

	//----------------------------------------------
	// Methods
	// ---------------------------------------------
	// Standard UVM Methods:	
	extern function new(string name = "ahb2apb_scb", uvm_component parent);
	extern virtual function void build_phase(uvm_phase phase);
	extern virtual task main_phase(uvm_phase phase);
	// User Defined Methods:
	extern virtual task check_pkt();
endclass

//Constructor
function ahb2apb_scb::new(string name = "ahb2apb_scb", uvm_component parent);
	super.new(name, parent);
endfunction

//Build_Phase
function void ahb2apb_scb::build_phase(uvm_phase phase);
	super.build_phase(phase);
	apb_port = new("apb_port", this);
	ahbl_port = new("ahbl_port", this);
	fcov = new("fcov");
endfunction

//Main_Phase
task ahb2apb_scb::main_phase(uvm_phase phase);
	check_pkt();
endtask

task ahb2apb_scb::check_pkt();
	apb_trans	apb_pkt;
	ahbl_trans	ahbl_pkt;
	bit 		err_flag;
	
	while(1) begin
		err_flag = 0;
		ahbl_port.get(ahbl_pkt);
		apb_port.get(apb_pkt);
		
		fcov.cg.sample(ahbl_pkt, apb_pkt);
		//------------------------------------------
		//Check address:
		//------------------------------------------
		
		if(ahbl_pkt.haddr[15:2] != apb_pkt.paddr[15:2])  begin
			`uvm_error(get_type_name(), $sformatf("address mismatch! ahb-addr[15:2][%0h], apb-addr[15:2][%0h]",ahbl_pkt.haddr[15:2], apb_pkt.paddr[15:2]))
			err_flag = 1;
		end
		//------------------------------------------
		//Check data:
		//------------------------------------------
		if(ahbl_pkt.hwrite)
			if(ahbl_pkt.hrwdata != apb_pkt.data) begin
				`uvm_error(get_type_name(), $sformatf("write data mismatch! ahb-data = %0h, apb-data = %0h",ahbl_pkt.hrwdata, apb_pkt.data))
				err_flag = 1;
			end
		else if(!ahbl_pkt.hwrite)
			if(ahbl_pkt.hrwdata != apb_pkt.prdata) begin
				`uvm_error(get_type_name(), $sformatf("read data mismatch! ahb-data = %0h, apb-prdata = %0h",ahbl_pkt.hrwdata, apb_pkt.prdata))
				err_flag = 1;
			end	
		//------------------------------------------
		//Check read of write:
		//------------------------------------------
		if(ahbl_pkt.hwrite == (apb_pkt.kind == apb_slv_pkg::READ)) begin
			`uvm_error(get_type_name(), "AHB-packet and APB-packet read/write mismatch! ahb-write, apb-read")
			err_flag = 1;	
		end
		
		//------------------------------------------
		if(!ahbl_pkt.hwrite == (apb_pkt.kind == apb_slv_pkg::WRITE)) begin
			`uvm_error(get_type_name(), "AHB-packet and APB-packet read/write mismatch! ahb-read, apb-write")
			err_flag = 1;	
		end
		
		
		//------------------------------------------
		//Check hprot and pprot signal:
		//------------------------------------------
		/* 
			HPROT[3]:Modifiable
			HPROT[2]:Bufferable
			HPROT[1]:Privileged
			HPROT[0]:Data/Opcode */
					
		//user or priviledged
		if(ahbl_pkt.hprot[1] != apb_pkt.pprot[0]) begin
			`uvm_error(get_type_name(), $sformatf("hprot/pprot mismatch ahbl[1] =%0h ,apb[0] = %0h ", ahbl_pkt.hprot[1], apb_pkt.pprot[0] ))
			err_flag = 1;
		end

		//secure or non-secure
		if(ahbl_pkt.hprot[0] == apb_pkt.pprot[2]) begin                     
			`uvm_error(get_type_name(), $sformatf("hprot/pprot mismatch ahbl[0] = %0h , apb[2] = %0h ",  ahbl_pkt.hprot[0], apb_pkt.pprot[2]))
			err_flag = 1;
		end
		
		//------------------------------------------
		//check hsize and pstrb when it is a write access
		//------------------------------------------
		if((ahbl_pkt.hsize == WORD) & (apb_pkt.pstrb != 4'b1111))begin
			`uvm_error(get_type_name(), $sformatf("hsize/haddr/pstrb mismatch! ahbl-size:WORD, apb-pstrb:%4b", apb_pkt.pstrb))
			err_flag = 1;
		end
		
		if(	((ahbl_pkt.hsize == HWORD) & !ahbl_pkt.haddr[1] & (apb_pkt.pstrb != 4'b0011)) 
			| ((ahbl_pkt.hsize == HWORD) & ahbl_pkt.haddr[1] & (apb_pkt.pstrb != 4'b1100)))begin
			`uvm_error(get_type_name(), $sformatf("hsize/haddr/pstrb mismatch! ahbl-size:HWORD, ahbl-addr[1]:%d, apb-pstrb:%4b", ahbl_pkt.haddr[1], apb_pkt.pstrb))
			err_flag = 1;
		end
		
		if(	  ((ahbl_pkt.hsize == BYTE) & (ahbl_pkt.haddr[1:0] == 2'b00) & (apb_pkt.pstrb != 4'b0001)) 
			| ((ahbl_pkt.hsize == BYTE) & (ahbl_pkt.haddr[1:0] == 2'b01) & (apb_pkt.pstrb != 4'b0010))
			| ((ahbl_pkt.hsize == BYTE) & (ahbl_pkt.haddr[1:0] == 2'b10) & (apb_pkt.pstrb != 4'b0100))
			| ((ahbl_pkt.hsize == BYTE) & (ahbl_pkt.haddr[1:0] == 2'b11) & (apb_pkt.pstrb != 4'b1000)))begin
			`uvm_error(get_type_name(), $sformatf("hsize/haddr/pstrb mismatch! ahbl-size:BYTE, ahbl-addr[1:0]:%d, apb-pstrb:%4b", ahbl_pkt.haddr[1], apb_pkt.pstrb))
			err_flag = 1;
		end
		//------------------------------------------
		//check  hresp and pslverr
		//------------------------------------------
		if(ahbl_pkt.hresp != apb_pkt.pslverr) begin
			`uvm_error(get_type_name(), $sformatf("hresp/pslverr mismatch hresp:[%0h], pslverr:[%0h]", ahbl_pkt.hresp, apb_pkt.pslverr ))
			err_flag = 1;
		end
		
		if(ahbl_pkt.hresp != apb_pkt.pslverr) begin
			`uvm_error(get_type_name(), $sformatf("hresp/pslverr mismatch hresp:[%0h], pslverr:[%0h]", ahbl_pkt.hresp, apb_pkt.pslverr ))
			err_flag = 1;
		end
		//final-display if correct
		if(err_flag)
			`uvm_error(get_type_name(), "Pkt comparing failed")
		else 
			`uvm_info(get_type_name(), "Pkt comparing passed", UVM_LOW)
		#20ns;
	end

endtask:check_pkt
