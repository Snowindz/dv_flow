# Common TCL procs

# Avoid of dumplication call
if { [ info exists __cmn_proc__tcl ] == 1 } {
  exit 0
}
 
set __cmn_proc__tcl 1

variable rgr_vars


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
  

# return v from rgr_var
proc get_rgr_var_bool {v} {
    variable rgr_vars
    set $v 0
    if { [ info exists rgr_vars($v) ] && $rgr_vars($v) != 0 } { 
        set $v 1
    }
    return [subst $$v]
}

proc get_rgr_var {v} {
    variable rgr_vars
    set $v ''
    if { [ info exists rgr_vars($v) ] } { 
        set $v rgr_vars($v)
    }
    return [subst $$v]
}

proc get_rgr_var_list {v} {
    variable rgr_vars
    set $v [list]
    if { [ info exists rgr_vars($v) ] && [llength $rgr_vars($v) > 0 ] } { 
        set $v [ split $rgr_vars($v) ]
    }
    return [subst $$v]
}


  
  
  
  
