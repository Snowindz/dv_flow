
set tcl_file "save_restore.tcl"
source $env(DV_CAR_ROOT)/tcl/cmn/cmn_proc.tcl
puts "# Source $tcl_file"


# before restore, back-up the variables WAVES_FSDB* WAVES_VPD* ... during
# session save stage
set rgr_vars_backup_indexes [array names rgr_vars WAVES_*]
set rgr_vars_backup(WAVES_DUMP_ON) 0
foreach index $rgr_vars_backup_indexes {
  set rgr_vars_backup($index) $rgr_vars($index)
}

# // lichao ... 11/25/2021, added to support muli-save rotation
set save_rotate_num 0
set save_rotate_i   0
if { [info exists env(SAR_SAVE_ROTATE_NUM)] } {
  set save_rotate_num $env(SAR_SAVE_ROTATE_NUM)
  puts "# $tcl_file : MULTIPLE SAVE ROTATE, SAR_SAVE_ROTATE_NUM = $save_rotate_num"
}


# Reusing SAR_SAVE_RESTORE as global ctrl for below precedures
if {[info exists rgr_vars(SAR_SAVE_RESTORE)]} { 
  #########################
  ## SAVE
  #########################
  if { [info exists rgr_vars(SAR_DC_INVOKE_FLAG)] } {
    puts "# $tcl_file : VCS SAVE RESTORE : SAR_DC_INVOKE_FLAG : Taking a snapshot of simulation @ $now"
    run_tcl_cmd $tcl_file "save $rgr_vars(SAR_SAVE_FILE).$now"
    puts [exec date]
    run_tcl_cmd $tcl_file "run"
  }

  if { [info exists rgr_vars(SAR_SAVE_ABS)] } {
    puts "# $tcl_file : ABSOLUTE SAVE"
    stop -absolute $rgr_vars(SAR_SAVE_ABS) -command {
      run_tcl_cmd $tcl_file "run 0"

      puts "# $tcl_file : VCS SAVE RESTORE : SAR_SAVE_ABS : Taking a snapshot of simulation @ $now"
      run_tcl_cmd $tcl_file "save $rgr_vars(SAR_SAVE_FILE)"
      puts [exec date]
    } 
    run_tcl_cmd "run"
  }
  
  if { [info exists rgr_vars(SAR_SAVE_EVENT)] } {
    puts "# $tcl_file : EVENT SAVE based on $rgr_vars(SAR_SAVE_EVENT)"
    stop -event $rgr_vars(SAR_SAVE_EVENT) -command {
      run_tcl_cmd $tcl_file "run 0"
      puts "# $tcl_file : VCS SAVE RESTORE : SAR_SAVE_EVENT Taking a snapshot of simulation @ $now"

      run_tcl_cmd $tcl_file "save $rgr_vars(SAR_SAVE_FILE)"
      puts [exec date]
      run_tcl_cmd $tcl_file "run"
    }
  }
  
  
  # multi-save w/ rotate
  if { [info exists rgr_vars(SAR_MULTI_SAVE_PERIOD)] } {
    puts "# $tcl_file : MULTIPLE SAVE"
    set rgr_vars(SAR_SAVE_POINTS_LIST) [list]
    stop -absolute $rgr_vars(SAR_MULTI_SAVE_START) -command {
      puts "# $tcl_file : SAR_MULTI_SAVE_START: Taking a snapshot of simulation @ $now"
      
      set save_snapshot  $rgr_vars(SAR_SAVE_FILE).$now
      if { $save_rotate_num != 0 } {
        set save_rotate_i   0
        set save_snapshot   $rgr_vars(SAR_SAVE_FILE).${save_rotate_i}.$now
      }
      set cmd "save $save_snapshot"
      run_tcl_cmd $tcl_file $cmd
      puts [exec date]
      lappend rgr_vars(SAR_SAVE_POINTS_LIST) $save_snapshot
      puts "# $tcl_file : Running at $now with save points : $rgr_vars(SAR_SAVE_POINTS_LIST)"
  
  
      stop -relative $rgr_vars(SAR_MULTI_SAVE_PERIOD) -repeat -continue -command {
        puts [exec date]
        puts "# $tcl_file : VCS SAVE : SAR_MULTI_SAVE_PERIOD Taking a snapshot of simulation @ $now"
  
        set save_snapshot  $rgr_vars(SAR_SAVE_FILE).$now

        if { $save_rotate_num != 0 } {
          set save_rotate_i   [expr $save_rotate_i + 1]
          if { $save_rotate_i == $save_rotate_num } {
            set save_rotate_i   0
          } 
          set save_snapshot   $rgr_vars(SAR_SAVE_FILE).${save_rotate_i}.$now
          # Remove old files 
          set save_rmv  [glob -nocomplain $rgr_vars(SAR_SAVE_FILE).${save_rotate_i}.*]
          if { [llength $save_rmv] > 0 } {
            puts "# $tcl_file : LC_SAR_MULTI_SAVE_ROTATE: remove old snapshot $save_rmv"
            set cmd "exec rm -rf $save_rmv"
            run_tcl_cmd $tcl_file $cmd
            # remove it from the list
            set ix [lsearch -exact $rgr_vars(SAR_SAVE_POINTS_LIST)]
            if {$ix >= 0} {
              set rgr_vars(SAR_SAVE_POINTS_LIST) [lreplace $rgr_vars(SAR_SAVE_POINTS_LIST) $ix $ix]
            }
          }
        }
  
        set cmd "save $save_snapshot"
        run_tcl_cmd $tcl_file $cmd
  
        puts [exec date]
        lappend rgr_vars(SAR_SAVE_POINTS_LIST) $save_snapshot
        puts "Running at $now with save points : $rgr_vars(SAR_SAVE_POINTS_LIST)"
      }
  
      set cmd "run"
      run_tcl_cmd $tcl_file $cmd
    }
  }

  ##############
  ## RESTORE
  ##############
  if { [info exists rgr_vars(SAR_RESTORE_FILE)] } {
    puts "#${tcl_file} : SAR_RESTORE_FILE       = $rgr_vars(SAR_RESTORE_FILE)"
  
    puts [exec date]
    set cmd "restore $rgr_vars(SAR_RESTORE_FILE)"
    run_tcl_cmd $tcl_file $cmd
    puts "#${tcl_file} : RESTORING SAVE POINT at $now"
  
    set cmd "run 0"
    run_tcl_cmd $tcl_file $cmd
    
    # Restore variables after restore
    puts "#${tcl_file} : print rgr_vars after restoration for debug:"
    foreach index $rgr_vars{
      puts "\t\t rgr_vars($index)\t\t=>\t]t$rgr_vars($index)"
    }
    foreach index $rgr_vars_backup_indexes {
      set rgr_vars($index) $rgr_vars_backup($index)
    }
  
    # Restore DOFILE 
    if { [info exists env(SAR_RESTORE_DOFILES)] } {
      puts "#${tcl_file} : SAR_RESTORE_DOFILES = $env(SAR_RESTORE_DOFILES)"
      set restore_dofiles [ split $env(SAR_RESTORE_DOFILES) ]
      if { [ llength $restore_dofiles ] != 0 } {
        #puts "#${tcl_file} : enter for loop for restore_dofiles " 
        foreach restore_dofile $restore_dofiles {
          if { [file exists ${restore_dofile}] } { 
            puts "#${tcl_file} : call $restore_dofile" 
            do $restore_dofile
          } else {
            puts "#Warning: ${tcl_file}: $restore_dofile not exist!"  
          }
        }
      }
    }
  
    # Restore w/ FSDB dump
    if { [info exists rgr_vars(SAR_RESTORE_WITH_DUMP)] } {
      set rgr_vars(WAVES_FSDB_FILE)    $rgr_vars(SAR_RESTORE_DUMP_FILE)
      set rgr_vars(WAVES_DUMP_ON)      1
      puts "#${tcl_file} : Sourcing $env(DV_CAR_ROOT)/tcl/verdi/dump_fsdb.tcl ..."
      source $env(DV_CAR_ROOT)/tcl/verdi/dump_fsdb.tcl
      puts "#${tcl_file} : RESTORING SAVE POINT at $now with FSDB enabled, fsdb_dump_on = $fsdb_dump_on"
      puts [exec date]
    }
  
    # Restore w/ VPD dump
    if { [info exists rgr_vars(SAR_RESTORE_WITH_VPD)] } {
      set rgr_vars(WAVES_VPD_FILE) $rgr_vars(SAR_RESTORE_DUMP_VPD_FILE)
      set rgr_vars(WAVES_DUMP_ON)  1
      puts "#${tcl_file} : $env(DV_CAR_ROOT)/tcl/vcs_mx/dump_vpd.tcl ..."
      source $env(DV_CAR_ROOT)/tcl/vcs_mx/dump_vpd.tcl
      puts "#${tcl_file} : RESTORING SAVE POINT at $now with VPD enabled, vpd_dump_on: $vpd_dump_on"
      puts [exec date]
    }

    # Restore w/ VCD/EVCD dump: TBD
    puts "#${tcl_file} : source $env(DV_CAR_ROOT)/tcl/cmn/dump_times.tcl ..."
    source $env(DV_CAR_ROOT)/tcl/cmn/dump_times.tcl
  } 

}
