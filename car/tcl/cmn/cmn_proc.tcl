# Common TCL procs
# Avoid of dumplication call
if { [ info exists __cmn_proc__tcl ] == 1 } {
  exit 0
}
 
set __cmn_proc__tcl 1

# Run cmd and check result
# - tclfile: the tcl file called
# - cmd: cmd executed inside tclfile
proc run_tcl_cmd { tclfile cmd } {
  set run_cmd_ts [clock format [clock seconds] -format "%a %b %d %H:%M:%S %Z %Y"]
  puts "#\[$run_cmd_ts] $tclfile: $cmd"  
  if { [ catch { eval $cmd } msg ] > 0 } {
    puts "# $tclfile: Error: $cmd : $msg"
    puts "# $tclfile: exiting ..."
    quit
  }
  
  if { [ lindex $cmd 0 ] != "set" && $msg != "" } {
    puts "$msg"
  }
}
  
  
  
  
  
  
  
