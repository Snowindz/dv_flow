set this_tcl_file "sim.tcl"
puts "# Source vcs_mx/$this_tcl_file"

#set env(DV_RGR_ROOT) $rgr_vars(DV_RGR_ROOT)
##############################
# on_start
##############################
# common.tcl

# fsdb/vpd/vcd/evcd dump setup
# fsdb.tcl
# vpd.tcl
# vcd.tcl
# evcd.tcl

config endofsim noexit
set user_cmds [list]
if { [info exists env(RGR_SIMV_ON_START_TCL_CMDS) } {
  set user_cmds [ split $env(RGR_SIMV_ON_START_TCL_CMDS) {;} ]
  puts "[$this_tcl_file] Info: found user defined cmd files from env RGR_SIMV_ON_START_TCL_CMDS"
}
foreach cmd_file $user_cmds {
  eval $cmd_file
}



##############################
# run
##############################
# - common.tcl
# - dump_times.cl
# - sar.tcl
set rgr_sim_run_time ""
if { [info exist rgr_vars(__SIM_RUN_TIME) ] } {
set rgr_sim_run_time $rgr_vars(__SIM_RUN_TIME)
}
run $rgr_sim_run_time

##############################
# on_exit.tcl
##############################
# - common.tcl
# last save
# dump flush/off

set user_cmds [list]
if { [info exists env(RGR_SIMV_ON_EXIT_TCL_CMDS) } {
  set user_cmds [ split $env(RGR_SIMV_ON_EXIT_TCL_CMDS) {;} ]
  puts "[$this_tcl_file] Info: found user defined cmd files from env RGR_SIMV_ON_EXIT_TCL_CMDS"
}
foreach cmd_file $user_cmds {
  eval $cmd_file
}


##############################
# quit.tcl
##############################
quit

