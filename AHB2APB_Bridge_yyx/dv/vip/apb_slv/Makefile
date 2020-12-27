.PHONY:com sim clean

OUTPUT = apb_slv_top

VCS = vcs -sverilog +v2k -timerscale=1ns/1ns 	\
	-debug_all -debug_access					\
	-o ${OUTPUT}								\
	-l compile.log								\

SIM = ${OUTPUT} -l run.log

com:
	${VCS} apb_slv_pkg.svh

sim:
	${SIM}

clean:
	rm -rf ./csrc *.daidir *.log simv* *.key
