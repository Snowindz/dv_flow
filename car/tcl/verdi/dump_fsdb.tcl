
set tcl_file "dump_fsdb.tcl"
source $env(DV_CAR_ROOT)/tcl/cmn/cmn_proc.tcl
puts "# Source vcs_mx/$tcl_file"

set fsdb_dump_on 0
# define WAVES_FSDB_FILE
if { [ info exists rgr_vars(WAVES_FSDB_FILE) ] } {
  if { [ info exists rgr_vars(WAVES_DUMP_ON) ] } {
    set fsdb_dump_on $rgr_vars(WAVES_DUMP_ON)
  } else {
    set fsdb_dump_on 1
  }
}

if { $fsdb_dump_on == 0 } {
  exit 0
}

set fsdb_dump_file $rgr_vars(WAVES_FSDB_FILE)
set fsdb_task_call ""
if { $rgr_vars(SIM) == "ius" } {
  set fsdb_task_call "call "
}

# dump options
set WAVES_FSDB_DUMP_SVA [get_rgr_var_bool WAVSS_FSDB_DUMP_SVA]
set WAVES_FSDB_DUMP_ALL [get_rgr_var_bool WAVES_FSDB_DUMP_ALL]
set WAVES_FSDB_DUMP_REG_ONLY [get_rgr_var_bool WAVES_FSDB_DUMP_REG_ONLY]
set WAVES_FSDB_DUMP_IO_ONLY [get_rgr_var_bool WAVES_FSDB_DUMP_IO_ONLY]

set WAVES_FSDB_LST_FILES [get_rgr_var_list WAVES_FSDB_LST_FILES]
set WAVES_FSDB_SUPPRESS_FILES [get_rgr_var_list WAVES_FSDB_SUPPRESS_FILES]

set WAVES_FSDB_AUTOSWITCH_FILE_SIZE [get_rgr_var_list WAVES_FSDB_AUTOSWITCH_FILE_SIZE]
set WAVES_FSDB_AUTOSWITCH_MAX_FILES [get_rgr_var_list WAVES_FSDB_AUTOSWITCH_MAX_FILES]

# SCOPE/DEPTHS
# TBD: use global WAVES_DUMP_SCOPES/DEPTHS (independent of fsdb/vpd/vcd)
set WAVES_FSDB_SUPPRESS_SCOPES [get_rgr_var_list WAVES_FSDB_SUPPRESS_SCOPES]
set WAVES_FSDB_SCOPES [get_rgr_var_list WAVES_FSDB_SCOPES]
set WAVES_FSDB_DEPTHS [get_rgr_var_list WAVES_FSDB_DEPTHS]


if { $WAVES_FSDB_AUTOSWITCH_FILE_SIZE > 0 } {
  set cmd "${fsdb_task_call}fsdbAutoSwitchDumpfile $WAVES_FSDB_AUTOSWITCH_FILE_SIZE $fsdb_dump_file $WAVES_FSDB_AUTOSWITCH_MAX_FILES $fsdb_dump_file.log"
  run_tcl_cmd $tcl_file $cmd
}

foreach sfile $WAVES_FSDB_SUPPRESS_FILES  {
    set cmd "${fsdb_task_call}fsdbSuppress $sfile"
    run_tcl_cmd $tcl_file $cmd
}

foreach sfile $WAVES_FSDB_LST_FILES {
    set cmd ""
    if { $rgr_vars(SIM) == "vcs_mx" } {
        set cmd "${fsdb_task_call}fsdbDumpvarsToFile $sfile"
    } else {
        set cmd "${fsdb_task_call}fsdbDumpvarsByFile $sfile"
    }
    run_tcl_cmd $tcl_file $cmd
}

if { [llength $WAVES_FSDB_SUPPRESS_SCOPES] != 0 } {
    foreach scope $WAVES_FSDB_SUPPRESS_SCOPES {
        set cmd "${fsdb_task_call}fsdbSuppress $scope"
        run_tcl_cmd $tcl_file $cmd
    }
}

if { [llength $WAVES_FSDB_SCOPES] != 0 } {

    if { [llength $WAVES_FSDB_SCOPES] != [llength $WAVES_FSDB_DEPTHS] } {
        puts "# $tcl_file: Error: WAVES_FSDB_SCOPES/WAVES_FSDB_DEPTHS list length not match"
        puts "# $tcl_file: "
        puts "# $tcl_file:    WAVES_FSDB_SCOPES=$WAVES_FSDB_SCOPES"
        puts "# $tcl_file:    WAVES_FSDB_DEPTHS=$WAVES_FSDB_DEPTHS"
        puts "# $tcl_file: exiting ..."
        quit
    }


    foreach scope $WAVES_FSDB_SCOPES depth $WAVES_FSDB_DEPTHS {
        set cmd "${fsdb_task_call}fsdbDumpvars $depth"
        if { $scope != ":" && $scope != "/"} {
            append cmd " $scope"
        }
        if { $rgr_vars(SIM) != "vcs_mx" } {
            if { $WAVES_FSDB_DUMP_ALL } { append cmd " +all" }
            if { $WAVES_FSDB_DUMP_REG_ONLY } { append cmd " +Reg_only" }
            if { $WAVES_FSDB_DUMP_IO_ONLY } { append cmd " +IO_only" }
        }
        run_tcl_cmd $tcl_file $cmd
    }

    if { $WAVES_FSDB_DUMP_SVA } { 
        set cmd "${fsdb_task_call}fsdbDumpSVA"
        run_tcl_cmd $tcl_file $cmd
    }
}



