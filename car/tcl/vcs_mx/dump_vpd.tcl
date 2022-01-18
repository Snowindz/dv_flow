
set tcl_file "dump_vpd.tcl"
source $env(DV_CAR_ROOT)/tcl/cmn/cmn_proc.tcl
puts "# Source $tcl_file"

set vpd_dump_on 0
if { [ info exists rgr_vars(WAVES_VPD_FILE) ] } {
  if { ! [ info exists rgr_vars(WAVES_DUMP_ON) ] || ( $rgr_vars(WAVES_DUMP_ON) == 1 ) } {
    set vpd_dump_on 1
  }
}

if { $vpd_dump_on == 0 } {
  exit 0
}

set vpd_dump_file $rgr_vars(WAVES_VPD_FILE)
                                
 
set WAVES_VPD_SCOPES [get_rgr_var_list WAVES_VPD_SCOPES]
set WAVES_VPD_DEPTHS [get_rgr_var_list WAVES_VPD_DEPTHS]
set ENABLE_PA_SIM    [get_rgr_var_bool ENABLE_PA_SIM]

set cmd "dump -file $WAVES_VPD_FILE -type VPD"
run_tcl_cmd $tcl_file $cmd

if { [llength WAVES_VPD_SCOPES] != 0 } {
    if { [llength WAVES_VPD_SCOPES] != [llength WAVES_VPD_DEPTHS] } {
        puts "# $tcl_file: Error: WAVES_VPD_SCOPES/WAVES_VPD_DEPTHS list length not match"
        puts "# $tcl_file: "
        puts "# $tcl_file:    WAVES_VPD_SCOPES=$WAVES_VPD_SCOPES"
        puts "# $tcl_file:    WAVES_VPD_DEPTHS=$WAVES_VPD_DEPTHS"
        puts "# $tcl_file: exiting ..."
        quit
    }


    foreach scope $WAVES_VPD_SCOPES depth $WAVES_VPD_DEPTHS {
        set cmd "dump -add $scope -depth $depth -fid VPD0"
        run_tcl_cmd $tcl_file $cmd
    }

    if { $ENABLE_PA_SIM } { 
        set cmd "vpd -power on -fid VPD0"
        run_tcl_cmd $tcl_file $cmd
    }
}
