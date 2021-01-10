.PHONY:com sim clean

OUTPUT = ahb2apb_bridge

VCS =	vcs -sgq long:16m:1c -sverilog -timescale=1ns/1ns \
	-debug_all \
	+incdir+$(UVM_HOME)/src $(UVM_HOME)/src/uvm.sv \
	+UVM_TESTNAME=ahbl_mst_single_read32\
	-P ${VERDI_HOME}/share/PLI/VCS/LINUX/novas.tab\
	${VERDI_HOME}/share//PLI/VCS/LINUX/pli.a		\
	-o ${OUTPUT}\
	-l compile.log\
	$(UVM_HOME)/src/dpi/uvm_dpi.cc -CFLAGS -DVCS\
	+define+DUMP_FSDB\
	-fstb\
	#+define+UVM_OBJECT_MUST_HAVE_CONSTRUCTOR \
	SNPS_VCS_OPT+= -debug_access+cbk\

SIM = sgsub ./${OUTPUT} -sgq normal:4m:1c -sgfg -l simulation.log

com:
	${VCS} -f tb.f

sim:
	${SIM} +UVM_TESTNAME=ahbl_mst_single_read32

clean:
	rm -rf ./csrc *.daidir *.log ${OUTPUT}* *.key

verdi:
	verdi -sgq long:8m:1c +v2k -sverilog -f tb.f -ssf ./ahb2apb_bridge.fstb &
