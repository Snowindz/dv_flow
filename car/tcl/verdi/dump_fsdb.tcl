set tcl_file "dump_fsdb.tcl"
source $env(DV_CAR_ROOT)/tcl/cmn/cmn_proc.tcl
puts "# Source vcs_mx/$tcl_file"

set fsdb_dump_on 0
if { [info exists env(WAVES_FSDB_FILE)] } {
  if { [info exists env(WAVES_DUMP_ON)] && ($env(WAVES_DUMP_ON) ==1) } {
    set fsdb_dump_on 1
  }
}

if { $fsdb_dump_on } {



}
