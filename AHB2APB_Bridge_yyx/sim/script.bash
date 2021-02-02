##################################################################################
## Engineer: 		Travis
## 
## Create Date: 	01/27/2021 Wed 20:41
## Filename: 		xxxxxx.sv
## class Name: 		xxxxxx
## Project Name: 	ahb2apb_bridge
## Revision 0.01 - File Created 
## Additional Comments:
## -------------------------------------------------------------------------------
## 	-> shell script to realize flexible test and regression test.


##################################################################################
##Name of files generated during simulation
OUTPUT = ahb2apb_bridge
CASEDAT = "	compile.log
						//simulation waveform
						//coverage
			"
						
##################################################################################
##Dir of SIM ENV files $ RTL
export DUT_ROOT = "/proj/fir0/wa/yyunxiao/yyx_downloads/git_download/ahb2apb_bridge/rtl"
export DV_ROOT = "/proj/fir0/wa/yyunxiao/yyx_downloads/git_download/ahb2apb_bridge/dv"

DUT = "-f $DUT_ROOT/cmsdk_ahb_to_apb.v"
TB = "-f $DV_ROOT/etc/tb.f"
CASEDIR = "-f $DV_ROOT/tc"

##################################################################################
##Compile & run options
##support SV, UVM, Verdi， FSDB
VCS_OPT = "	-sverilog 
			-timescale=1ns/1ns+incdir
			+$(UVM_HOME)/src $(UVM_HOME)/src/uvm.sv $(UVM_HOME)/src/dpi/uvm_dpi.cc -CFLAGS -DVCS
			+define+DUMP_FSDB
			-P ${VERDI_HOME}/share/PLI/VCS/LINUX/novas.tab ${VERDI_HOME}/share//PLI/VCS/LINUX/pli.a
			-debug_all"

COV_OPT = 	"-cm line+cond+fsm+tgl+branch+assert"