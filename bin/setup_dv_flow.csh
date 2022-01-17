#!/bin/csh

#

# common c-shell setup for CAR & RGR tool chains
###################################
## dv_flow tool pkg
###################################
setenv DV_TOOL_VERSION    1.0.0
setenv DV_TOOL_ROOT       ./dv_flow
setenv CAR_CMD            car
setenv RGR_CMD            rgr
setenv DV_CAR_ROOT        $DV_TOOL_ROOT/${CAR_CMD}; # required by: $DV_CAR_ROOT/flows/sim_artist.mk
setenv DV_RGR_TOOT        $DV_TOOL_ROOT/${RGR_CMD}


###################################
## external tool version, libs
###################################
# required by: $DV_CAR_ROOT/flows/common.mk
setenv PERL_VERSION     3.10
setenv PERL_ROOT        /sw/perl/$PERL_VERSION
#`envmgr -a PERL5LIB $PERL_PATH` # TBD for envmgr

setenv PYTHONVERSION    3.4.0
setenv PYTHON_ROOT      /sw/python/$PYTHONVERSION
#`envmgr -a PYTHONPATH $PYTHON_ROOT` # TBD for envmgr

# required by: $DV_CAR_ROOT/flows/tools.mk
setenv VCS_VERSION      vcs-mx_2019.06-SP2-2
setenv VCS_HOME         /sw/synopsys/vcs/${VCS_VERSION}

setenv NOVAS_VERSION    /sw/synopsys/verdi/


# May required by: $DV_CAR_ROOT/flows/hvl.mk, TB_SPEC_PATHS
#setenv WORKSPACE      <you workspace path>

