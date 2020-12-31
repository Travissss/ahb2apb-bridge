
.PHONY:com sim clean

OUTPUT = ahb2apb_bridge

VCS =	vcs -sverilog -timescale=1ns/1ns \
	+acc +vpi \
	+define+UVM_OBJECT_MUST_HAVE_CONSTRUCTOR \
	+incdir+$(UVM_HOME)/src $(UVM_HOME)/src/uvm.sv \
	$(UVM_HOME)/src/dpi/uvm_dpi.cc -CFLAGS -DVCS

SIM = ${OUTPUT} -l run.log

com:
	${VCS} -f filelist.f

sim:
	${SIM}

clean:
	rm -rf ./csrc *.daidir *.log simv* *.key
