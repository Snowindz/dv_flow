
set tcl_file "dump_evcd.tcl"
source $env(DV_CAR_ROOT)/tcl/cmn/cmn_proc.tcl
puts "# Source $tcl_file"

set evcd_dump_on 0
if { [ info exists rgr_vars(WAVES_EVCD_FILE) ] } {
  if { ! [ info exists rgr_vars(WAVES_DUMP_ON) ] || ( $rgr_vars(WAVES_DUMP_ON) == 1 ) } {
    set evcd_dump_on 1
  }
}

if { $evcd_dump_on == 0 } {
  exit 0
}

set evcd_dump_file $rgr_vars(WAVES_EVCD_FILE)
set WAVES_EVCD_SCOPES [get_rgr_var_list WAVES_EVCD_SCOPES]

if { [llength WAVES_EVCD_SCOPES] != 0 } {
    set cmd "call {\$dumpports("
    set cmd_args "$WAVES_EVCD_SCOPES \"$evcd_dump_file\""
    append cmd [join [split $cmd_args] ","]
    append cmd ")}"
    run_tcl_cmd $tcl_file $cmd

} else {
    puts "# $tcl_file: Error: WAVES_EVCD_SCOPES must be defined for EVCD dump"
    puts "# $tcl_file: "
    puts "# $tcl_file: exiting ..."
    quit
}
