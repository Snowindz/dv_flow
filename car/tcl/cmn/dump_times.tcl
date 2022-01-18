
set tcl_file "dump_times.tcl"
source $env(DV_CAR_ROOT)/tcl/cmn/cmn_proc.tcl
puts "# Source $tcl_file"

variable WAVES_DUMP_TIMES
set WAVES_DUMP_TIMES [get_rgr_var_list WAVES_DUMP_TIMES]


# off -> on -> off -> on
proc dump_switch {dump_off_cmd dump_on_cmd} {
    variable WAVES_DUMP_TIMES

    set dump_cmd $dump_off_cmd
    run_tcl_cmd $tcl_file $dump_cmd

    foreach dump_time $WAVES_DUMP_TIMES {
        set cmd "run $dump_time"
        run_tcl_cmd $tcl_file $cmd

        if { $dump_cmd == $dump_off_cmd } {
            set dump_cmd $dump_on_cmd
        } else {
            set dump_cmd $dump_off_cmd
        }
        run_tcl_cmd $tcl_file $dump_cmd
    }
}


# FSDB
if { [ info exists fsdb_dump_on ] && $fsdb_dump_on } {
    set fsdb_task_call ""
    if { $rgr_vars(SIM) == "ius" } {
      set fsdb_task_call "call "
    }

    if { [llength $WAVES_DUMP_TIMES] != 0 } {
        set dump_on   "${fsdb_task_call}fsdbDumpon"
        set dump_off  "${fsdb_task_call}fsdbDumpoff"
        dump_switch $dump_off $dump_on
    }
}



# VCD
if { [ info exists vcd_dump_on ] && $vcd_dump_on } {
    if { [llength $WAVES_DUMP_TIMES] != 0 } {
        if { $rgr_vars(SIM) == "modelsim" } {
            set dump_on   "vcd on"
            set dump_off  "vcd off"
        } elseif { $rgr_vars(SIM) == "vcs_mx" } {
            set dump_on   "call {\$dumpon}"
            set dump_off  "call {\$dumpoff}"
        } elseif { $rgr_vars(SIM) == "ius" } {
            set dump_on   "database -enable $vcd_dump_file"
            set dump_off  "database -disable $vcd_dump_file"
        }
        dump_switch $dump_off $dump_on
    }
}


# EVCD
if { [ info exists evcd_dump_on ] && $evcd_dump_on } {
    if { [llength $WAVES_DUMP_TIMES] != 0 } {
        if { $rgr_vars(SIM) == "modelsim" } {
            set dump_on   "vcd dumpportson"
            set dump_off  "vcd dumpportsoff"
        } elseif { $rgr_vars(SIM) == "vcs_mx" } {
            set dump_on   "call {\$dumpportson}"
            set dump_off  "call {\$dumpportsoff}"
        } elseif { $rgr_vars(SIM) == "ius" } {
            set dump_on   "database -enable $evcd_dump_file"
            set dump_off  "database -disable $evcd_dump_file"
        }
        dump_switch $dump_off $dump_on
    }
}


# WLF
if { [ info exists wlf_dump_on ] && $wlf_dump_on } {
    if { [llength $WAVES_DUMP_TIMES] != 0 } {
        set dump_on   "nolog -reset"
        set dump_off  "nolog -all"
        dump_switch $dump_off $dump_on
    }
}

# VPD
if { [ info exists vpd_dump_on ] && $vpd_dump_on } {
    if { [llength $WAVES_DUMP_TIMES] != 0 } {
        set dump_on   "dump -enable"
        set dump_off  "dump -disable"
        dump_switch $dump_off $dump_on
    }
}

# SHM
if { [ info exists vpd_dump_on ] && $vpd_dump_on } {
    if { [llength $WAVES_DUMP_TIMES] != 0 } {
        set dump_on   "database -enable $evcd_dump_file"
        set dump_off  "database -disable $evcd_dump_file"
        dump_switch $dump_off $dump_on
    }
}
