//////////////////////////////////////////////////////////////////////////////////
// Engineer: 		Travis
// 
// Create Date: 	12/01/2020
// Filename: 		ahbl_trans.svh
// class Name: 		ahbl_trans
// Project Name: 	ahb2apb_bridge
// Revision 0.01 - File Created
// Additional Comments:
// -------------------------------------------------------------------------------
//////////////////////////////////////////////////////////////////////////////////
class ahbl_trans extends uvm_sequence_item;
	rand logic 				hsel;
	rand logic 		[31:0] 	haddr = 32'b0;
	rand htrans_t 			htrans = NSEQ;
	rand hsize_t			hsize = BYTE;
	rand hburst_t			hburst = WRAP4;
	rand logic		[3:0]	hprot = 4'b0;
	rand logic				hwrite = 1'b0;
	rand logic		[31:0]	hrwdata = 32'b0;
	rand logic				hresp = 1'b0;
	rand logic				hreadyout = 1'b1;

	rand logic		[3:0]	clk_ratio = 4'h1;
	
	protected rand int unsigned	bst_beats;
	protected rand logic [31:0] haddr_q[$];
	protected rand logic [31:0] hrwdata_q[$];
	protected rand htrans_t		htrans_q[$];
	
	protected int unsigned		haddr_idx	=	0;
	protected int unsigned		hrwdata_idx = 	0;
	protected int unsigned		htrans_idx	= 	0;
	
	//Factory Registration
	`uvm_object_utils_begin(ahbl_trans)
		`uvm_field_int			(hsel,				UVM_ALL_ON)
		`uvm_field_int			(haddr, 			UVM_ALL_ON)
		`uvm_field_enum			(htrans_t,	htrans, UVM_ALL_ON)
		`uvm_field_enum			(hsize_t,	hsize, 	UVM_ALL_ON)
		`uvm_field_enum			(hburst_t,	hburst, UVM_ALL_ON)
		`uvm_field_int			(hprot, 			UVM_ALL_ON)
		`uvm_field_int			(hwrite, 			UVM_ALL_ON)
		`uvm_field_int			(hrwdata, 			UVM_ALL_ON)
		`uvm_field_int			(hreadyout,			UVM_ALL_ON)
		`uvm_field_int			(clk_ratio,			UVM_ALL_ON)
		`uvm_field_int			(hresp,				UVM_ALL_ON)
		
		`uvm_field_int			(bst_beats,	      	UVM_ALL_ON)
		`uvm_field_queue_int	(haddr_q,          	UVM_ALL_ON)
		`uvm_field_queue_int	(hrwdata_q,        	UVM_ALL_ON)
		`uvm_field_queue_enum	(htrans_t,	htrans_q,         	UVM_ALL_ON)
							                 	
		`uvm_field_int			(haddr_idx,	      	UVM_ALL_ON)
		`uvm_field_int			(hrwdata_idx,      	UVM_ALL_ON)
		`uvm_field_int			(htrans_idx,      	UVM_ALL_ON)
		
		
		
	`uvm_object_utils_end
	
	//------------------------------------------
	// Constraints
	//------------------------------------------
	constraint haddr_constr{
		(hsize == HWORD)-> (haddr[0] == 1'b0);
		(hsize == WORD)	-> (haddr[1:0] == 2'b0);	 	
		solve hsize before haddr;
	}
	
	constraint hsize_constr{
		(hsize <= 2);	//Bit-width == 32, so hsize == BYTE/HWORD/WORD
	}
	
	constraint htrans_constr{
		htrans == IDLE -> (hburst == SINGLE);
		solve htrans before hburst;
	}
	
	constraint hburst_constr{
		(hburst == SINGLE) -> (bst_beats == 1);
		(hburst == WRAP4 ) -> (bst_beats == 4);
		(hburst == WRAP8 ) -> (bst_beats == 8);
		(hburst == WRAP16) -> (bst_beats == 16);
		(hburst == INCR4 ) -> (bst_beats == 4);
		(hburst == INCR8 ) -> (bst_beats == 8);
		(hburst == INCR16) -> (bst_beats == 16);
		solve hburst before bst_beats;
	}
	
	constraint queue_constr{
		haddr_q.size() 		== bst_beats;
		hrwdata_q.size() 	== bst_beats;
		htrans_q.size() 	== bst_beats;
		solve bst_beats before haddr_q;
		solve bst_beats before hrwdata_q;
		solve bst_beats before htrans_q;
	}

	logic [3:0] array_ratio[] ='{4'h1,4'h2,4'h4,4'h8};	
	constraint clk_ratio_constr{
		clk_ratio inside array_ratio;	
	}

	//----------------------------------------------
	// Methods
	// ---------------------------------------------
	// Standard UVM Methods:	
	function new(string name = "ahbl_tran");
		super.new(name);
	endfunction
	
	function void post_randomize();
		int i;
		haddr_q[0] 		= haddr;
		htrans_q[0]		= NSEQ;
		hrwdata_q[0] 	= hrwdata;
		for (i = 1; i < bst_beats; i++) begin
			haddr_q[i] 	= haddr_q[i-1] + (2**hsize);
			htrans_q[i]	= SEQ; 
		end
	endfunction
	
	// User Defined Methods:
	virtual function logic [31:0] nxt_haddr();
		haddr_idx++;
		return haddr_q[haddr_idx - 1];
	endfunction
	
	virtual function logic [31:0] nxt_hrwdata();
		hrwdata_idx++;
		return hrwdata_q[hrwdata_idx - 1];
	endfunction

	virtual function logic [31:0] nxt_htrans();
		htrans_idx++;
		return htrans_q[htrans_idx - 1];
	endfunction	
	
	virtual function logic [31:0] htrans_ro();
		htrans_ro = htrans_q[htrans_idx];
		return htrans_ro;
	endfunction	
	
	virtual function bit last_beat();
		return (htrans_idx == htrans_q.size());
	endfunction
	
	virtual function int get_bst_beats();
		return(bst_beats);
	endfunction
	
endclass
