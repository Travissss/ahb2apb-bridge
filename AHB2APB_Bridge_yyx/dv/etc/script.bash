##################################################################################
## Engineer: 		Travis
## 
## Create Date: 	01/27/2021 Wed 20:41
## Filename: 		script.bash
## class Name: 		xxxxxx
## Project Name: 	ahb2apb_bridge
## Revision 0.01 - File Created 
## Additional Comments:
## -------------------------------------------------------------------------------
## 	-> shell script to realize flexible test and regression test.


##################################################################################
##Name of files generated during simulation
OUTPUT="ahb2apb_bridge"
CASEDAT="	simulation.log
			$OUTPUT.fsdb			
			$OUTPUT.vdb				
			"
						
##################################################################################
##Dir of SIM ENV files $ RTL
export DUT_ROOT="/proj/fir0/wa/yyunxiao/yyx_downloads/git_download/ahb2apb_bridge/rtl"
export DV_ROOT="/proj/fir0/wa/yyunxiao/yyx_downloads/git_download/ahb2apb_bridge/dv"
export UVM_HOME="/proj/cadsim/datacom/bin/uvm/October_17_2014/uvm-1.2"
export VERDI_HOME_X="proj/eda/SYNOPSYS/VERDI3/O-2018.09-SP1-1"
DUT="-f $DUT_ROOT/rtl.f"
TB="-f $DV_ROOT/etc/tb.f"
CASEDIR=$DV_ROOT/tc

echo "DV_ROOT is: $DV_ROOT" 
echo "CASEDIR is: $CASEDIR" 
echo "All the Testcase includes: $ListL1" 
##################################################################################
##Compile & run options
##support SV, UVM, Verdi? FSDB
VCS_OPT="	-sverilog 
			-timescale=1ns/1ns
			+incdir+${UVM_HOME}/src ${UVM_HOME}/src/uvm.sv ${UVM_HOME}/src/dpi/uvm_dpi.cc -CFLAGS -DVCS
			-debug_all
			-l compile.log "

FSDB_OPT="	+define+DUMP_FSDB
			-P ${VERDI_HOME_X}/share/PLI/VCS/LINUX/novas.tab ${VERDI_HOME_X}/share//PLI/VCS/LINUX/pli.a"

SIM_OPT="	sgsub ./${OUTPUT}
			-sgq short:1m:1c -sgfg -l simulation.log"

WAV_OPT="	+fsdb+glitch=0 +fsdb+sva_index_info +fsdb+sva_status" 

COV_OPT="-cm line+cond+fsm+tgl+branch+assert"

##################################################################################
## Others
ResDir=result
Slog_file=sim.log
Sreport_file=sim.rpt	
LOGFILE=simulation.log



##################################################################################
## sim_one
FAILED=0
sim_one(){
	TestCaseName=$1
	
	echo "">$Slog_file
	echo "################################################" | tee -a $Slog_file
	echo -n "`date +%F`"  | tee -a $Slog_file
	echo "`date +$T`" | tee -a $Slog_file
	echo "BEGIN SIMULATION TESTCASE $TestCaseName ......" | tee -a $Slog_file
	
	if [ "$SEED_DEF" == "" ]; then
		#SEED=8848 
		SEED=`date +%N` 
	fi
	
	# Sim prepare
	if [ ! -d $ResDir/$TestCaseName"_"$SEED ]; then
		mkdir $ResDir/$TestCaseName"_"$SEED
	fi
	
	for casedatfile in $CASEDAT
	do
		if [ -d $ResDir/$TestCaseName"_"$SEED ]; then
			if [ -f $ResDir/$TestCaseName"_"$SEED/$casedatfile ]; then
				rm $ResDir/$TestCaseName"_"$SEED/$casedatfile
			fi
			if [ -d $ResDir/$TestCaseName"_"$SEED/$casedatfile ]; then
				rm -rf $ResDir/$TestCaseName"_"$SEED/$casedatfile
			fi
		fi
	done
	
	# Sim run
	
	if [ $COV_DEF ]; then
		echo "SIMULATION SEED :: $SEED" | tee -a $Slog_file | tee -a $Sreport_file
		echo "Simulation Command is $SIM_OPT"	
	
		$SIM_OPT $COV_OPT +UVM_TESTNAME=$TestCaseName +ntb_random_seed=$SEED
	else 
		echo "SIMULATION SEED :: $SEED" | tee -a $Slog_file | tee -a $Sreport_file
		echo "Simulation Command is $SIM_OPT"	
	
		$SIM_OPT +UVM_TESTNAME=$TestCaseName +ntb_random_seed=$SEED
	fi
	
#	if [ $WAV_DEF ]; then
#		SIM_OPT="$SIM_OPT $WAV_OPT"
#	fi

	
	#Sim run done
	cat $LOGFILE >> $Slog_file
	
	#pass_string=`sed -n '/^UVM_INFO.*Simulation Passed!/p' $LOGFILE`
	pass_string=`sed -n '/UVM_INFO.*Simulation Passed!/p' $LOGFILE`
	echo "pass_string :: $pass_string" | tee -a $Slog_file
	
	echo -n "$TestCaseName SIMULATION RESULT: " | tee -a $Slog_file
	
	if [ "$pass_string" != "" ]; then
		echo "PASSED" | tee -a $Slog_file
		FAILED=0
	else
		echo "FAILED" | tee -a $Slog_file
		FAILED=1
	fi
	
	for casedatfile in $CASEDAT
	do
		if [ -d $ResDir/$TestCaseName"_"$SEED ]; then
			cp $casedatfile $ResDir/$TestCaseName"_"$SEED/. -rf
		fi
	done
	
	echo -n "`date +%F`"  | tee -a $Slog_file
	echo "`date +$T`" | tee -a $Slog_file
	echo "END SIMULATION TESTCASE $TestCaseName ......" | tee -a $Slog_file
	echo "################################################" | tee -a $Slog_file	

	cp $Slog_file $ResDir/$TestCaseName"_"$SEED/.
	return $FAILED
}
#end of sim_one


##################################################################################
## sim_all
err_cnt=0
sim_cnt=0

sim_all(){	
if [ $RepeatCount -eq 0 ]; then
	err_cnt=0
	sim_cnt=0
	
	if [ -d INCA_libs ]; then
		rm -rf INCA_libs
	fi
	
	if [ -d $ResDir ]; then
			rm $ResDir/* -rf	#clean last-time results 
	else 
		mkdir $ResDir
	fi
	
	if [ -f $Sreport_file ]; then
		echo -n '' > $Sreport_file
	fi
fi	
echo "The Testcase $TESTCASE will be simulated"

i=0
for TestcaseName in $TESTCASE
do
	echo "Simulation $TestcaseName"
	if  sim_one $TestcaseName ; then
		sim_cnt=`expr $sim_cnt + 1`
		echo "$TestcaseName Passed" >>$Sreport_file
	else
		err_cnt=`expr $err_cnt + 1`
		sim_cnt=`expr $sim_cnt + 1`
		echo "$TestcaseName Failed" >>$Sreport_file
	fi
	i=`expr $i + 1`		
done

echo "" | tee -a $Sreport_file
echo "(per round) : SUMMARY " | tee -a $Sreport_file
echo -n "(per round) : ALL SIMULATION $sim_cnt TESTCASE, " | tee -a $Sreport_file

if [ "$sim_cnt" -gt "0" -a "$err_cnt" -eq "0" ]; then
	echo "ALL TESTCASE PASSED!" | tee -a $Sreport_file
else
	echo "$err_cnt TESTCASE FAILED!" | tee -a $Sreport_file
fi

}
#end of sim_all


for i
do
	case $1 in
	-a)
		ALLSim=1;
		shift;;
	
	-rpt)
		RepeatSim=1;shift;
		if [ $1 != "" ]; then
			RepeatTimes=$1
			shift
		else
			echo "Command Error: No Repeat Timers Following the <-rpt> Parameter"
			echo -e $Usage
			exit
		fi
		;;
	
	-cov)
		COV_DEF=1;shift;;

	-fsdb)
		WAV_DEF=1;shift;;
		
	-seed)
		SEED_DEF=1; shift;
		if [ $1 != "" ]; then
			SEED=$1
			shift
		fi
		;;

	-com)
		COM_DEF=1;shift;;

	-urg)
		URG_DEF=1;shift;;

	*)
		TESTCASEIN="$TESTCASEIN $1";shift;;
	esac
done

if [ $COM_DEF ]; then

	if [ $COV_DEF ]; then
		VCS_OPT="$VCS_OPT $COV_OPT"
	fi
	
	if [ $WAV_DEF ]; then
		VCS_OPT="$VCS_OPT $FSDB_OPT"
	fi


	vcs -sgq short:1m:1c $VCS_OPT $TB -o ${OUTPUT} -assert enable_diag -assert_dbgopt
	echo "Compile Finished"

fi

	echo "SIMULATION SEED :: $SEED" | tee -a $Slog_file | tee -a $Sreport_file


if [ $ALLSim ]; then
	ListL1=`ls $CASEDIR`
	for FileNameL1 in $ListL1
	do
		testname=${FileNameL1%\.sv}		#remove ".sv"
		TESTCASE="$TESTCASE $testname"
	done
elif [ "TESTCASEIN" != "" ]; then
	for TestCase in $TESTCASEIN
	do
		TESTCASE="$TESTCASE $TestCase"
	done
fi

i=0
echo "####Simulate all testcases including :" | tee -a $Sreport_file
for TestcaseName in $TESTCASE
do
	echo "###$TestcaseName" | tee -a $Sreport_file
	i=`expr $i + 1`
done

RepeatCount=0
if [ $RepeatSim ]; then
	while [ $RepeatCount -lt $RepeatTimes ]
	do
		sim_all $RepeatCount
		RepeatCount=`expr $RepeatCount + 1`
		echo "Simulation $RepeatCount times finished !" | tee -a $Sreport_file
		echo "########################################" | tee -a $Sreport_file
		echo " " | tee -a $Sreport_file
		echo " " | tee -a $Sreport_file
	done
else 
	sim_all $RepeatCount		#if not Repeat, sim_all 0	
fi



##################################################################################
#
# Coverage merging
#

if [ $COV_DEF ]; then
	if [ -d $ResDir/cov_rpt ]; then
		rm $ResDir/cov_rpt/* -rf
	else 
		mkdir $ResDir/cov_rpt
	fi
	
	cd $ResDir
	cd -
fi

if [ $URG_DEF ]; then
	rm -rf *.vdb
	for Testcase_urg in $TESTCASE
	do
		echo "merge coverage command::urg -dir result/$Testcase_urg"_[0-9]"*/*.vdb -dbname ./$Testcase_urg -sgq short:3m:1c"
		urg -dir result/$Testcase_urg"_[0-9]"*/*.vdb -dbname ./$Testcase_urg -sgq short:3m:1c
	done
	echo "urg -sgq short:3m:1c -dir */*.vdb -report both"  
	urg -sgq short:3m:1c -dir *.vdb -report both  

	echo "firefox ./both/tests.html"  
	firefox ./both/tests.html  
fi
cp $Sreport_file $ResDir/.

exit
