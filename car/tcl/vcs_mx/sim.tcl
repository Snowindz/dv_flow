set tcl_file "sim.tcl"
source $env(DV_CAR_ROOT)/tcl/cmn/cmn_proc.tcl
puts "# Source vcs_mx/$tcl_file"


##############################
# on_start
##############################
source $env(DV_CAR_ROOT)/tcl/verdi/dump_fsdb.tcl

# fsdb/vpd/vcd/evcd dump setup
# fsdb.tcl
# vpd.tcl
# vcd.tcl
# evcd.tcl

run_tcl_cmd $tcl_file "config endofsim noexit"

set user_cmds [list]
if { [info exists env(RGR_SIMV_ON_START_TCL_CMDS) } {
  set user_cmds [ split $env(RGR_SIMV_ON_START_TCL_CMDS) {;} ]
  puts "[$tcl_file] Info: found user defined cmd files from env RGR_SIMV_ON_START_TCL_CMDS"
}
foreach cmd $user_cmds {
  run_tcl_cmd $tcl_file $cmd
}



##############################
# run
##############################
# - common.tcl
# - dump_times.cl
# - sar.tcl
set sim_run_time ""
if { [info exist rgr_vars(__SIM_RUN_TIME) ] } {
  set sim_run_time $rgr_vars(__SIM_RUN_TIME)
}
run_tcl_cmd $tcl_file "run $sim_run_time"

##############################
# on_exit.tcl
##############################
# - common.tcl
# last save
# dump flush/off

set user_cmds [list]
if { [info exists env(RGR_SIMV_ON_EXIT_TCL_CMDS) } {
  set user_cmds [ split $env(RGR_SIMV_ON_EXIT_TCL_CMDS) {;} ]
  puts "[$tcl_file] Info: found user defined cmd files from env RGR_SIMV_ON_EXIT_TCL_CMDS"
}
foreach cmd $user_cmds {
  run_tcl_cmd $tcl_file $cmd
}



##############################
# quit.tcl
##############################
quit

