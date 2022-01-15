ifndef __<template>_mk_guard
__<template>_mk_guard := 1

$(call __include_trace)
SIM_MODE 	?= batch
TEST_NAME 	?=
ifeq ($(strip ${TESTCASE_TYPE}),uvm)
UVM_TESTNAME 	?= $(strip ${TEST_NAME})
endif
SIM_INIT_CMD_FILES ?=
__SIM_DIR 	= ${__ELAB_BIN_DIR}/${TEST_SIM_DIR}
__SIM_BIN_DIR 	?= ${__SIM_DIR}
__SIM_TOUCH_FILE_DIR := ${__SIM_DIR}/Makefile.Target
__SIM_TOOLS 	?= ${__SIM_TOP_TOOLS}
__SIM_MODE 	:= $(strip $(call lc,${SIM_MODE}))
__SIM_OPTS 	+= $(if ${UVM_TESTNAME},+UVM_TESTNAME=${UVM_TESTNAME},)
ifneq (${SIM_INIT_CMD_FILES},)
__SIM_INIT_CMD_FILES = $(abspath ${SIM_INIT_CMD_FILES})
endif
__SIM_CMD_FILES = $(abspath ${SIM_CMD_FILES})
__SIM_DIR_SIM_CMD_FILE = ${__SIM_DIR}/sim.do
__SIM_DIR_PERIFERAL_FILE = ${__SIM_DIR}/det_perifrl.do
__SIM_CMD_FILE_VARS += SIM
__SIM_CMD_FILE_VARS += HW
__SIM_CMD_FILE_VARS += HW_ENABLE
__SIM_CMD_FILE_VARS += __VERBOSITY
__SIM_CMD_FILE_VARS += __SIM_MODE
__SIM_CMD_FILE_VARS += CODE_COVERAGE_HIERARCHIES
__SIM_CMD_FILE_VARS += SAVE_SIM_COVERAGE_DIR
__SIM_CMD_FILE_VARS += SAVE_SIM_COVERAGE
__SIM_CMD_FILE_VARS += SPECMAN_COVERAGE
__SIM_CMD_FILE_VARS += AARGR_HOME
__SIM_CMD_FILE_VARS += WAVES_DUMP_ON
__SIM_CMD_FILE_VARS += WAVES_DUMP_TIMES
__SIM_CMD_FILE_VARS += WAVES_VCD_FILE
__SIM_CMD_FILE_VARS += WAVES_VCD_SCOPES
__SIM_CMD_FILE_VARS += WAVES_VCD_DEPTHS
__SIM_CMD_FILE_VARS += WAVES_VPD_FILE
__SIM_CMD_FILE_VARS += WAVES_VPD_SCOPES
__SIM_CMD_FILE_VARS += WAVES_WLF_FILE
__SIM_CMD_FILE_VARS += WAVES_WLF_SCOPES
__SIM_CMD_FILE_VARS += WAVES_SHM_FILE
__SIM_CMD_FILE_VARS += WAVES_SHM_SCOPES
__SIM_CMD_FILE_VARS += WAVES_VPD_DEPTHS
__SIM_CMD_FILE_VARS += WAVES_EVCD_FILE
__SIM_CMD_FILE_VARS += WAVES_EVCD_SCOPES
__SIM_CMD_FILE_VARS += WAVES_FSDB_SCOPES
__SIM_CMD_FILE_VARS += WAVES_FSDB_DEPTHS
__SIM_CMD_FILE_VARS += WAVES_FSDB_SUPPRESS_SCOPES
__SIM_CMD_FILE_VARS += WAVES_FSDB_SUPPRESS_FILES
__SIM_CMD_FILE_VARS += WAVES_FSDB_FILE
__SIM_CMD_FILE_VARS += WAVES_FSDB_LST_FILES
__SIM_CMD_FILE_VARS += WAVES_FSDB_DUMP_MDA
__SIM_CMD_FILE_VARS += WAVES_FSDB_DUMP_ALL
__SIM_CMD_FILE_VARS += WAVES_FSDB_DUMP_REG_ONLY
__SIM_CMD_FILE_VARS += WAVES_FSDB_DUMP_IO_ONLY
__SIM_CMD_FILE_VARS += WAVES_FSDB_DUMP_SVA
__SIM_CMD_FILE_VARS += WAVES_FSDB_AUTOSWITCH_FILE_SIZE
__SIM_CMD_FILE_VARS += WAVES_FSDB_AUTOSWITCH_MAX_FILES
__SIM_CMD_FILE_VARS += __TEST_DIR_STR
__SIM_CMD_FILE_VARS += TEST_NAME
__SIM_CMD_FILE_VARS += XEL_USR_RUN_CMD_FILE
__SIM_CMD_FILE_VARS += ENABLE_PA_SIM
__SIM_CMD_FILE_VARS += PWR_CALCULATOR
__SIM_CMD_FILE_VARS += HW_ENABLE
__SIM_CMD_FILE_VARS += RTLPOWER_WAVE_STREAM_MODE
__SIM_CMD_FILE_VARS += WAVES_STW_RTLPOWER_TOP_INST
__SIM_CMD_FILE_VARS += WAVES_STW_NAME
__SIM_CMD_FILE_VARS += WAVES_STW_BASEDIR
__SIM_CMD_FILE_VARS += WAVES_STW_DIR
__SIM_CMD_FILE_VARS += WAVES_STW_SIGLIST_FILE
__SIM_CMD_FILE_VARS += WAVES_STW_TIMEZONE_FILE
__SIM_CMD_FILE_VARS += WAVES_STW_GEN_ACTIVITYPLOT
__SIM_CMD_FILE_VARS += WAVES_STW_CAPTURE_RATIO
__SIM_CMD_FILE_VARS += ECF2WAVE_SIGLIST_FILE
__SIM_CMD_FILE_OPTS = $(foreach __item,${__SIM_CMD_FILE_VARS},$(if ${${__item}},${__item}='$(call __escape_single_quoted,${${__item}})',))
__RUN_SIM_TASK_STRING = Run simulation


ifeq (${SIM},vcs_mx)
################################################################################
## Command line mode vs. GUI mode.
#########################################################################
ifneq (${__VCS_NO_UCLI},1) 
ifneq (${VERDI_INTERACTIVE_SIM},1) 
        ifeq (${__SIM_MODE}, batch) 
                ifneq (${SIM_CMD_FILES},) 
                	__SIMV_OPTS += -i ./$(notdir ${__SIM_DIR_SIM_CMD_FILE}) 
                endif ## SIM_CMD_FILES
        endif ## __SIM_MODE=batch
endif ## VERDI_INTERACTIVE_SIM
## Start the DVE interface.
ifeq (${__SIM_MODE},gui)
	__SIMV_OPTS += -gui
	__SIMV_OPTS += -l ./sim_gui.log
else ifeq (${__SIM_MODE},cmdline)
	__SIMV_OPTS += -l ./sim_cmdline.log
endif

endif

################################################################################
## Misc. switches.
################################################################################
ifneq (${__VCS_NO_UCLI},1) 
## Enable command line interface. 
__SIMV_OPTS 		+= -ucli
VCS_NO_UCLI2PROC 	?= 0
__VCS_NO_UCLI2PROC 	= $(strip ${VCS_NO_UCLI2PROC})
__AACER_REPORT_VARS 	+= VCS_NO_UCLI2PROC
ifneq (${__VCS_NO_UCLI2PROC},1)
VCS_UCLI_STDIN_BLOCKING ?= 1
## Enable post-simulation UCLI commands (may produce warnings in earlier VCS versions)
__SIMV_OPTS 		+= -ucli2Proc
endif

ifeq (${VCS_UCLI_STDIN_BLOCKING},1)
export VCS_UCLI_STDIN_BLOCKING
endif
endif

## Point to the VCS-MX executable.
__SIMV_OPTS 		+= -exec ${__SIM_EXEC}
#Add Wait for License
__SIMV_OPTS 		+= +vcs+lic+wait
################################################################################
## Plug-in variables for sim rule.
################################################################################
__SIM_CMD = ${__SIMV} \
	${__SIM_SIMV_OPTS} ${SIM_SIMV_OPTS} ${SIM_SIMV_OPTS_} \
	${__SIM_OPTS} ${SIM_OPTS} ${SIM_OPTS_}

endif ## ${SIM}





${__SIM_DIR}:
	$(call __mkdir, $@,)

ifneq (${__SIM_CONFIG_FILE_NAME},)
#######################################################################################
## Run-time sim config file.
#######################################################################################
## Path to the sim-time sim config file.
__SIM_DIR_MAP_FILE = ${__SIM_DIR}/${__SIM_CONFIG_FILE_NAME}
__SIM_DIR_MAP_FILE_VARS_SIGNATURE ?=
__CHECK_SIM_DIR_MAP_FILE_VARS = ${__SIM_DIR}/.aacer/aacer_signature^sim_config_file_vars
__CLEAN_COMPILE_ITEMS += ${__CHECK_SIM_DIR_MAP_FILE_VARS}
__SIM_DIR_MAP_FILE_VARS_SIGNATURE += ${__ABV_LIBS}
__SIM_DIR_MAP_FILE_VARS_SIGNATURE += ${__SIM_TOP_MAP_FILE}
$(foreach __tool,${__SIM_TOOLS},$(eval $(call __gen_update_map_file_rule,sim,${__tool})))
$(foreach __tool,${__SIM_TOOLS},$(foreach __item,${__COMMON_LIBS_WORK_NAMES},$(eval $(call __gen_map_work_rule,sim,${__item},${__tool}))))
$(foreach __tool,${__SIM_TOOLS},$(foreach __item,${__DUT_LIBS_WORK_NAMES},$(eval $(call __gen_map_work_rule,sim,${__item},${__tool}))))
$(foreach __tool,${__SIM_TOOLS},$(foreach __item,${__DUT_WORK_NAMES},$(eval $(call __gen_map_work_rule,sim,${__item},${__tool}))))
$(foreach __tool,${__SIM_TOOLS},$(foreach __item,${__TH_WORK_NAMES},$(eval $(call __gen_map_work_rule,sim,${__item},${__tool}))))
$(foreach __tool,${__SIM_TOOLS},$(foreach __item,${__SIM_TOP_WORK_NAMES},$(eval $(call __gen_map_work_rule,sim,${__item},${__tool}))))
$(foreach __tool,${__SIM_TOOLS},$(foreach __item,${__ABV_LIBS_WORK_NAMES},$(eval $(call __gen_map_work_rule,sim,${__item},${__tool}))))
$(foreach __tool,${__SIM_TOOLS},$(foreach __item,${__ABV_WORK_NAMES},$(eval $(call __gen_map_work_rule,sim,${__item},${__tool}))))
$(foreach __tool,${__SIM_TOOLS},$(foreach __item,${__TB_LIBS_WORK_NAMES},$(eval $(call __gen_map_work_rule,sim,${__item},${__tool}))))
$(foreach __tool,${__SIM_TOOLS},$(foreach __item,${__TB_WORK_NAMES},$(eval $(call __gen_map_work_rule,sim,${__item},${__tool}))))
$(foreach __tool,${__SIM_TOOLS},$(foreach __item,${__TEST_WORK_NAMES},$(eval $(call __gen_map_work_rule,sim,${__item},${__tool}))))
$(foreach __tool,${__SIM_TOOLS},$(foreach __item,${__TEST_SVA_WORK_NAMES},$(eval $(call __gen_map_work_rule,sim,${__item},${__tool}))))
$(foreach __tool,${__SIM_TOOLS},$(foreach __item,${__VOPT_WORK_NAMES},$(eval $(call __gen_map_work_rule,sim,${__item},${__tool}))))

ifneq (${__SIM_MAP_WORK_TARGETS},)
__SIM_DEPS += ${__SIM_MAP_WORK_TARGETS}
endif

${__SIM_DIR_MAP_FILE} : ${__SIM_UPDATE_MAP_FILE_TARGETS}
	@:

__SIM_OOPS 	+= ${__SIM_UPDATE_MAP_FILE_TARGETS}
__SIM_DEPS 	+= ${__SIM_DIR_MAP_FILE}

${__CHECK_SIM_DIR_MAP_FILE_VARS}: __check_sim_dir_sim_config_file_vars
	@:
	
.PHONY: __check_sim_dir_sim_config_file_vars
__check_sim_dir_sim_config_file_vars: 
	$(call __check_signature_exec,${__CHECK_SIM_DIR_MAP_FILE_VARS},${__SIM_DIR_MAP_FILE_VARS_SIGNATURE},)
endif ## __SIM_CONFIG_FILE_NAME



__create_sim_dir_sim_cmd_file:
	$(call __open_task,Create run-time sim command file,${__SIM_INFO})
	@$(call __quiet_rm, ${__SIM_DIR_SIM_CMD_FILE}, ${__SIM_LOG})
	$(call __exec, ${__CONCAT_CMD_FILES_SCRIPT} ${__SIM_CMD_FILE_OPTS} ${__SIM_DIR_SIM_CMD_FILE} \
			${__SIM_INIT_CMD_FILES} ${__SIM_CMD_FILES}, ${__SIM_LOG})
	$(call __close_task,${__SIM_INFO})

__create_sim_dir_perifrl_file:
	$(call __open_task,Create run-time sim command file,${__SIM_INFO})
	@$(call __quiet_rm, ${__SIM_DIR_PERIFERAL_FILE}, ${__SIM_LOG})
	$(call __exec, ${__CONCAT_CMD_FILES_SCRIPT} ${__SIM_CMD_FILE_OPTS} ${__SIM_DIR_PERIFERAL_FILE} \
			${__DEFAULT_IOPART_DET_FILE} ${__SIM_CMD_FILE}, ${__SIM_LOG})
	$(call __close_task,${__SIM_INFO})

ifneq (${SIM},none)
__SIM_DEPS += __create_sim_dir_sim_cmd_file
endif

ifneq (${SIM},none)
__SIM_DEPS += __create_sim_dir_perifrl_file
endif

__run_sim: __CURRENT_TARGET = sim
__run_sim: __CURRENT_LOG_FILE = ${__SIM_LOG_FILE}
__run_sim: ${__SIM_TOUCH_FILE_DIR}/aacer_target^run_sim

.SECONDEXPANSION:
${__SIM_TOUCH_FILE_DIR}/aacer_target^run_sim : __CURRENT_TARGET = sim
${__SIM_TOUCH_FILE_DIR}/aacer_target^run_sim : __CURRENT_LOG_FILE = ${__SIM_LOG_FILE}
${__SIM_TOUCH_FILE_DIR}/aacer_target^run_sim : ${AARGR_ELAB} ${AARGR_MISC} ${AARGR_TEST} ${__SIM_DEPS} $${SIM_DEPS} ${SIM_DEPS_} | ${__SIM_OOPS} $${SIM_OOPS} ${SIM_OOPS_}
	$(call __open_task,${__RUN_SIM_TASK_STRING},${__SIM_INFO})
	$(call __assert_defined,__SIM_CMD, \
	Internal Error: $$\{__SIM_CMD\} not defined., \
	${__SIMULATE_LOG})
	$(call __exec, ${CD} ${__SIM_DIR} && $(if ${__MOD_SIM_CMD},${__MOD_SIM_CMD},${__SIM_CMD}),${__SIMULATE_LOG},1)
	$(call __close_task,${__SIM_INFO})

PHONY_TARGETS += __run_sim ${__SIM_TOUCH_FILE_DIR}/aacer_target^run_sim
__SIM_TARGETS += __run_sim

endif ## __<template>_mk_guard
