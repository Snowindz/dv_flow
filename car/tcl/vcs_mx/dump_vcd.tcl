
set tcl_file "dump_vcd.tcl"
source $env(DV_CAR_ROOT)/tcl/cmn/cmn_proc.tcl
puts "# Source $tcl_file"

set vcd_dump_on 0
if { [ info exists rgr_vars(WAVES_VCD_FILE) ] } {
  if { ! [ info exists rgr_vars(WAVES_DUMP_ON) ] || ( $rgr_vars(WAVES_DUMP_ON) == 1 ) } {
    set vcd_dump_on 1
  }
}

if { $vcd_dump_on == 0 } {
  exit 0
}

set vcd_dump_file $rgr_vars(WAVES_VCD_FILE)
                                
set WAVES_VCD_SCOPES [get_rgr_var_list WAVES_VCD_SCOPES]
set WAVES_VCD_DEPTHS [get_rgr_var_list WAVES_VCD_DEPTHS]

set cmd "call {\$dumpfile(\"$WAVES_VCD_FILE\")}"
run_tcl_cmd $tcl_file $cmd

if { [llength WAVES_VCD_SCOPES] != 0 } {
    if { [llength WAVES_VCD_SCOPES] != [llength WAVES_VCD_DEPTHS] } {
        puts "# $tcl_file: Error: WAVES_VCD_SCOPES/WAVES_VCD_DEPTHS list length not match"
        puts "# $tcl_file: "
        puts "# $tcl_file:    WAVES_VCD_SCOPES=$WAVES_VCD_SCOPES"
        puts "# $tcl_file:    WAVES_VCD_DEPTHS=$WAVES_VCD_DEPTHS"
        puts "# $tcl_file: exiting ..."
        quit
    }


    foreach scope $WAVES_VCD_SCOPES depth $WAVES_VCD_DEPTHS {
        if { $scope == "/" } {
            set cmd "call {\$dumpvars($depth)}"
        } else {
            set cmd "call {\$dumpvars($depth, $scope)}"
        }
        run_tcl_cmd $tcl_file $cmd
    }
} else {
    set cmd "call {\$dumpvars()}"
    run_tcl_cmd $tcl_file $cmd
}
