.PHONY:com sim clean

OUTPUT = ahb2apb_bridge

VCS =	vcs -sgq short:3m:1c -sverilog -timescale=1ns/1ns \
	-cm line+cond+fsm+tgl+branch+assert\
	-debug_all \
	+incdir+$(UVM_HOME)/src $(UVM_HOME)/src/uvm.sv \
	$(UVM_HOME)/src/dpi/uvm_dpi.cc -CFLAGS -DVCS\
	-P ${VERDI_HOME}/share/PLI/VCS/LINUX/novas.tab\
	${VERDI_HOME}/share//PLI/VCS/LINUX/pli.a		\
	+define+DUMP_FSDB\
	-o ${OUTPUT}\
	-l compile.log\
	+UVM_VERBOSITY=UVM_HIGH\
	-assert enable_diag -assert_dbgopt\
	#+define+UVM_OBJECT_MUST_HAVE_CONSTRUCTOR \
	#SNPS_VCS_OPT+= -debug_access+cbk\
	+UVM_TESTNAME=ahbl_mst_single_write32_apb_slv_nrdy

SIM = sgsub ./${OUTPUT} +fsdb+glitch=0 +fsdb+sva_index_info +fsdb+sva_status -sgq short:3m:1c -sgfg -l simulation.log\
	-cm line+cond+fsm+tgl+branch+assert\

com:
	${VCS} -f tb.f

sim:
	${SIM}  +UVM_TESTNAME=ahbl_mst_burst_apb_slv_slverr\
	



clean:
	rm -rf ./csrc *.daidir *.log ${OUTPUT}* *.key

verdi:
	verdi -sgq long:8m:1c +v2k -sverilog  -f tb.f -ssf -cov -covdir ${OUTPUT}.vdb ./ahb2apb_bridge.fstb &

none:
	${SIM} +UVM_TESTNAME=ahbl_mst_single_read32\
	${SIM} +UVM_TESTNAME=ahbl_mst_single_write32_apb_slv_nrdy\
	${SIM} +UVM_TESTNAME=ahbl_mst_burst\
	${SIM} +UVM_TESTNAME=ahbl_mst_tight_transfer
