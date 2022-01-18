# Common TCL procs
# Avoid of dumplication call
if { [ info exists __cmn_proc__tcl ] == 1 } {
  exit 0
}
 
set __cmn_proc__tcl 1

# Run cmd and check result
# - tcl_file: the tcl file called
# - run_cmd: cmd executed in tcl_file
proc run_cmd { tcl_file run_cmd } {
  set run_cmd_ts [clock format [clock seconds] -format "%a %b %d %H:%M:%S %Z %Y"]
  puts "#\[$run_cmd_ts] $tcl_file: $run_cmd"
  
  # run cmd and catch the result
  if { [ catch { eval $run_cmd } msg ] > 0 } {
    puts "# $tcl_file: Error: $run_cmd : $msg"
    puts "# $tcl_file: exiting ..."
    quit
  }
  
  if { [ lindex $run_cmd 0 ] != "set" && $msg != "" } {
    puts "$msg"
  }
}
  
  
  
  
  
  
  
