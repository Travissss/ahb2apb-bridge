-timescale=1ns/1ns/1n

+incdir+$DV_ROOT/env
+incdir+$DV_ROOT/vip/ahbl_mst
+incdir+$DV_ROOT/vip/apb_slv

//Source file
$DV_ROOT/../rtl/cmsdk_ahb_to_apb.v
$DV_ROOT/vip/ahbl_mst/ahbl_mst_pkg.svh
$DV_ROOT/vip/apb_slv/apb_slv_pkg.svh
$DV_ROOT/env/ahb2apb_pkg.sv
$DV_ROOT/env/ahb2apb_base_test.sv
$DV_ROOT/tb/reset_if.sv
$DV_ROOT/tb/ahb2apb_tb.sv
$DV_ROOT/seqlib/ahbl_mst_seqlib.sv
$DV_ROOT/seqlib/apb_slv_seqlib.sv
-f $DV_ROOT/etc/tc.f




