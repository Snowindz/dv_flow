#######################################################
# Pub Vars
#######################################################
####################
# common vars
####################
$(call __register_var,SIM,vcs_mx)

# default simulator
SIM := $(strip ${SIM})
$(call __register_var,COMPILE_VERDI,0)


####################
# VCS-MX RTL compile setup
####################
__MAKE_WORK_CMD[others]	?= ${MKDIR}
__MAP_WORK_CMD[vcs_mx] 	?= ${__VCSMAP}
__MAP_FILE_NAME[vcs_mx]	?= synopsys_sim.setup

# tool options defined in project makefile or command line
$(call __register_opts_vars,VHDLAN)
$(call __register_opts_vars,VLOGAN)
$(call __register_opts_vars,VCSMAP)
$(call __register_opts_vars,SYSCAN)
$(call __register_opts_vars,VCS)
$(call __register_opts_vars,SIMV)
$(call __register_opts_vars,VCS_MX_GCC)
$(call __register_opts_vars,VCS_MX_G++)

# synopsys_sim.setup options
SYNOPSYS_SIM_SETUP_OPTS ?=
SYNOPSYS_SIM_SETUP_OPTS_ ?=

#Lichao: VCS_HOME 		?=
#Lichao: VCS_VERSION 		?=

SIM_CONFIG_FILE 	?=
VCS_CONFIG_FILE 	?=

#######################################################
# Internal Vars
#######################################################
__SYNOPSYS_SIM_SETUP_OPTS = $(foreach __opt,${SYNOPSYS_SIM_SETUP_OPTS} ${SYNOPSYS_SIM_SETUP_OPTS_},"${__opt}")

$(call __which_and_check,__VHDLAN_CMD,Vhdlan)
$(call __which_and_check,__VLOGAN_CMD,Vlogan)
$(call __which_and_check,__SYSCAN_CMD,Syscan)
$(call __which_and_check,__VCSMAP_CMD,Vcsmap)
$(call __which_and_check,__VCS_CMD,Vcs)
$(call __which_and_check,__SIMV_CMD,Simv)
$(call __which_and_check,__VCS_MX_GCC_CMD,Vcs_mx_gcc)
$(call __which_and_check,__VCS_MX_G++_CMD,Vcs_mx_g++)

# Vars combined w/ compiler and options
__VHDLAN = $(call __get_tool_cmd_with_aa_opts,VHDLAN)
__VLOGAN = $(call __get_tool_cmd_with_aa_opts,VLOGAN)
__SYSCAN = $(call __get_tool_cmd_with_aa_opts,SYSCAN)
__VCS = $(call __get_tool_cmd_with_aa_opts,VCS)
__SIMV = $(call __get_tool_cmd_with_aa_opts,SIMV)
__VCSMAP = $(call __get_tool_cmd_with_opts,VCSMAP)
__VCS_MX_GCC = $(call __get_tool_cmd_with_aa_opts,VCS_MX_GCC)
__VCS_MX_G++ = $(call __get_tool_cmd_with_aa_opts,VCS_MX_G++)
__ADD_SYNOPSYS_SIM_SETUP_OPTION_SCRIPT := ${__INT_SCRIPT_DIR}/AddSynopsysSimSetupOption

# MISC Vars
__HDL_TOOL 	?= vcs_mx
__SIM_TOP_TOOL 	?= vcs_mx
__SIM_TOP_TOOLS += ${__SIM_TOP_TOOL}
__HVL_TOOL 	:= ${__SIM_TOP_TOOL}
__HVL_TOOLS 	?+= ${__HVL_TOOL}
__TB_TOOL 	= ${__HVL_TOOL}
__TB_TOOLS 	= ${__HVL_TOOLS}

# klw add
__VCS_HOME 	?= ${VCS_HOME}
__VCS_VERSION 	?= ${VCS_VERSION}
__HDL_TOOL_VERSION ?= ${__VCS_VERSION}
__SIM_TOP_TOOL_VERSION ?= ${__HDL_TOOL_VERSION}

# tool config file settings
__SIM_CONFIG_FILE_NAME ?= synopsys_sim.setup
__EXTRA_CONFIG_FILE_NAME ?=
ifneq (${SIM_CONFIG_FILE},)
__SIM_CONFIG_FILE ?= ${SIM_CONFIG_FILE}
else
__SIM_CONFIG_FILE ?= ${__TEMPLATE_DIR}/${__SIM_TOP_TOOL}/${__SIM_CONFIG_FILE_NAME}
endif


ifneq (${VCS_CONFIG_FILE},)
__VCS_CONFIG_FILE ?= ${VCS_CONFIG_FILE}
else
__VCS_CONFIG_FILE ?= ${__SIM_CONFIG_FILE}
endif

__BASE_MAP_FILE[synopsys_sim.setup] ?= ${__VCS_CONFIG_FILE}




#######################################################
# C compiler setup
#######################################################
USE_SIMULATOR_GCC ?= 1
__AACER_REPORT_VARS += USE_SIMULATOR_GCC
$(call __which_and_check,__GCC_CMD,Gcc)
$(call __which_and_check,__G++_CMD,G++)

GCC_CMD 	?= ${__GCC_CMD}
G++_CMD 	?= ${__G++_CMD}

ifneq ($(strip ${USE_SIMULATOR_GCC}),1)
  __CC 		?= ${GCC_CMD} ${__AA_OPTS} ${AA_OPTS} ${AA_OPTS_}
  __CPP 	?= ${G++_CMD} ${__AA_OPTS} ${AA_OPTS} ${AA_OPTS_}
else
  __CC[vcs_mx] 	?= ${__VCS_MX_GCC}
  __CPP[vcs_mx] ?= ${__VCS_MX_G++}
  ifneq (${__CC[${SIM}]},)
  __CC 		?= ${__CC[${SIM}]}
  else
  __CC 		?= ${GCC_CMD} ${__AA_OPTS} ${AA_OPTS} ${AA_OPTS_}
  endif
  ifneq (${__CPP[${SIM}]},)
  __CPP 	?= ${__CPP[${SIM}]}
  else
  __CPP 	?= ${G++_CMD} ${__AA_OPTS} ${AA_OPTS} ${AA_OPTS_}
  endif
endif


#######################################################
# Hooks vars
#######################################################
AARGR_VHDL_COMPILER ?= ${__VHDLAN}
AARGR_VERILOG_COMPILER ?= ${__VLOGAN}
AARGR_SYSTEMVERILOG_COMPILER ?= ${__VLOGAN} -sverilog
AARGR_SYSTEMC_COMPILER ?= ${__SYSCAN}

#######################################################
# checks
#######################################################

#######################################################
# Rules
#######################################################

ifeq (${REBUILD},${true})
endif ## REBUILD
