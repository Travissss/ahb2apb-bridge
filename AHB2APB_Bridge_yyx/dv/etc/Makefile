.PHONY:com sim clean

OUTPUT = ahb2apb_bridge

VCS =	vcs -sgq long:16m:1c -sverilog -timescale=1ns/1ns \
	-debug_all \
	+incdir+$(UVM_HOME)/src $(UVM_HOME)/src/uvm.sv \
	+UVM_TESTNAME=ahbl_mst_single_read32\
	-o ${OUTPUT}\
	-l compile.log\
	$(UVM_HOME)/src/dpi/uvm_dpi.cc -CFLAGS -DVCS
	#+define+UVM_OBJECT_MUST_HAVE_CONSTRUCTOR \

SIM = sgsub ./${OUTPUT} -sgq normal:4m:1c -sgfg -l simulation.log

com:
	${VCS} -f tb.f

sim:
	${SIM} +UVM_TESTNAME=ahbl_mst_single_read32 -gui

clean:
	rm -rf ./csrc *.daidir *.log simv* *.key
	

