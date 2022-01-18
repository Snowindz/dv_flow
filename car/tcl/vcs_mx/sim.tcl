puts "# Source vcs_mx/sim.do"

set env(DV_RGR_ROOT) $rgr_vars(DV_RGR_ROOT)
source $rgr_vars(DV_CAR_ROOT)/tcl/$rgr_vars(SIM)/on_start.tcl
source $rgr_vars(DV_CAR_ROOT)/tcl/$rgr_vars(SIM)/run.tcl
source $rgr_vars(DV_CAR_ROOT)/tcl/$rgr_vars(SIM)/on_exit.tcl
source $rgr_vars(DV_CAR_ROOT)/tcl/$rgr_vars(SIM)/quit.tcl
