set tcl_file "save_retain_last.tcl"
source $env(DV_CAR_ROOT)/tcl/cmn/cmn_proc.tcl
#puts "# Source $tcl_file"

if { [ info exist rgr_vars(SAR_RETAIN_LAST_SAVE) ] } {
    set save_pts $rgr_vars(SAR_SAVE_POINTS_LIST)
    set save_pts_cnt [llength $rgr_vars(SAR_SAVE_POINTS_LIST)]
    set del_cnt [expr { $save_pts_cnt - 1 }]
    puts "# $tcl_file: SAR_RETAIN_LAST_SAVE, total save points:$save_pts, remove cnt:$del_cnt"
    puts "# $tcl_file: list of points saved: $save_pts"
    for {set i 0} {$i < $del_cnt} {incr i} {
        set sfile [lindex $save_pts $i]
        set cmd "exec rm -rf $sfile $sfile.ucli $sfile.FILES"
        run_tcl_cmd $tcl_file $cmd
    }
}
