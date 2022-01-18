set tcl_file "dump_fsdb.tcl"
source $env(DV_CAR_ROOT)/tcl/cmn/cmn_proc.tcl
puts "# Source vcs_mx/$tcl_file"

set fsdb_dump_on 0
# define WAVES_FSDB_FILE
if { [ info exists rgr_vars(WAVES_FSDB_FILE) ] } {
  if { [info exists rgr_vars(WAVES_DUMP_ON)] } {
    set fsdb_dump_on $rgr_vars(WAVES_DUMP_ON)
  } else {
    set fsdb_dump_on 1
  }
}

if { $fsdb_dump_on == 0 } {
  exit 0
}

set fsdb_task_call ""
if { $rgr_vars(SIM) == "ius" } {
  set fsdb_task_call "call "
}

set WAVES_FSDB_DUMP_SVA [get_rgr_var_bool WAVSS_FSDB_DUMP_SVA]
set WAVES_FSDB_DUMP_ALL [get_rgr_var_bool WAVES_FSDB_DUMP_ALL]
set WAVES_FSDB_DUMP_REG_ONLY [get_rgr_var_bool WAVES_FSDB_DUMP_REG_ONLY]
set WAVES_FSDB_DUMP_IO_ONLY [get_rgr_var_bool WAVES_FSDB_DUMP_IO_ONLY]

set WAVES_FSDB_DUMP_LST_FILES [get_rgr_var_list WAVES_FSDB_DUMP_LST_FILES]
set WAVES_FSDB_DUMP_LST_FILES [get_rgr_var_list WAVES_FSDB_DUMP_LST_FILES]




