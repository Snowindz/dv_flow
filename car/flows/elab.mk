# Variables
ELAB_BIN_DIR 		?=
__AACER_REPORT_VARS 	+= ELAB_BIN_DIR

# read-only var for user to refer to bin dir
AARGR_ELAB_DIR 		= ${__ELAB_BIN_DIR}
__AACER_REPORT_VARS 	+= AARGR_ELAB_DIR

# MISC
ELAB_DONE 		?= 0
__AACER_REPORT_VARS 	+= ELAB_DONE
AARGR_LIB_NAMES 	= ${__DUT_LIBS_LIB_NAMES} ${__DUT_LIB_NAMES} ${__TH_LIB_NAMES} ${__ABV_LIB_NAMES} ${__SIM_TOP_LIB_NAMES} ${__TB_LIBS_LIB_NAMES} ${__TB_LIB_NAMES} ${__TEST_LIB_NAMES}

TOP_COMPILE_UNIT_TO_SIM ?=

ifneq (${ELAB_BIN_DIR},)
__ELAB_BIN_DIR 		:= $(abspath $(strip ${ELAB_BIN_DIR}))
else
__ELAB_BIN_DIR 		?= ${__SIM_TOP_BIN_DIR}
endif
__ELAB_TOUCH_FILE_DIR 	= ${__ELAB_BIN_DIR}/Makefile.Target
__ELAB_WORK_NAME 	?= $(strip ${__SIM_TOP_WORK_NAME})

__VCS_SIM_EXEC_OOPS 	+= ${__SIM_TOP_SIM_CONFIG_FILE}
__ELAB_COMPILE_UNIT_NAME ?= $(if ${__SIM_TOP_CONFIG_NAME},${__SIM_TOP_CONFIG_NAME},${__SIM_TOP_MODULE_NAME})

ifneq ($(strip ${TOP_COMPILE_UNIT_TO_SIM}),)
__TOP_COMPILE_UNIT_TO_SIM ?= ${TOP_COMPILE_UNIT_TO_SIM}
else
__TOP_COMPILE_UNIT_TO_SIM ?= ${__ELAB_WORK_NAME}.${__ELAB_COMPILE_UNIT_NAME}
endif
ifneq (${__HDL_TOP_WORK_NAME},)
__TOP_COMPILE_UNIT_TO_SIM := ${__HDL_TOP_WORK_NAME}.${__HDL_TOP_CONFIG_NAME} ${__TOP_COMPILE_UNIT_TO_SIM}
endif

# VCS Compile
__VCS_ELAB_TOP 	:= ${__TOP_COMPILE_UNIT_TO_SIM}
VCS_CM_DIR 	?= ${__VCS_SIM_EXEC}
__VCS_CM_DIR 	?= $(strip ${VCS_CM_DIR})
__VCS_COMPILE_CMD ?= ${__VCS}
__VCS_COMPILE_CMD += $(if ${__VCS_CM_DIR},-cm_dir ${__VCS_CM_DIR},)
__VCS_COMPILE_CMD += ${__VCS_ELAB_TOP}
__VCS_COMPILE_CMD += ${__ELAB_VCS_OPTS}

# elab
__SIM_TOP_TOOL 		= vcs_mx
__SIM_TOP_TOOLS += ${__SIM_TOP_TOOL}

$(foreach __tool,${__SIM_TOP_TOOLS},$(eval $(call __gen_update_map_file_rule,elab,${__tool})))
$(foreach __item,${__COMMON_LIBS_WORK_NAMES},$(eval $(call __gen_map_work_rule,elab,${__item},${__SIM_TOP_TOOL})))
$(foreach __item,${__DUT_LIBS_WORK_NAMES},$(eval $(call __gen_map_work_rule,elab,${__item},${__SIM_TOP_TOOL})))
$(foreach __item,${__DUT_WORK_NAMES},$(eval $(call __gen_map_work_rule,elab,${__item},${__SIM_TOP_TOOL})))
$(foreach __item,${__TH_WORK_NAMES},$(eval $(call __gen_map_work_rule,elab,${__item},${__SIM_TOP_TOOL})))
$(foreach __item,${__TB_LIBS_WORK_NAMES},$(eval $(call __gen_map_work_rule,elab,${__item},${__SIM_TOP_TOOL})))
$(foreach __item,${__TB_WORK_NAMES},$(eval $(call __gen_map_work_rule,elab,${__item},${__SIM_TOP_TOOL})))
$(foreach __item,${__TEST_WORK_NAMES},$(eval $(call __gen_map_work_rule,elab,${__item},${__SIM_TOP_TOOL})))
$(foreach __item,${__SIM_TOP_WORK_NAMES},$(eval $(call __gen_map_work_rule,elab,${__item},${__SIM_TOP_TOOL})))
$(foreach __item,${__ABV_LIBS_WORK_NAMES},$(eval $(call __gen_map_work_rule,elab,${__item},${__SIM_TOP_TOOL})))
$(foreach __item,${__ABV_WORK_NAMES},$(eval $(call __gen_map_work_rule,elab,${__item},${__SIM_TOP_TOOL})))
$(foreach __item,${__TEST_SVA_WORK_NAMES},$(eval $(call __gen_map_work_rule,elab,${__item},${__SIM_TOP_TOOL})))

__ELAB_INIT_OOPS 	+= ${__ELAB_MAP_WORK_TARGETS}


__CHECK_ELAB_VARS 	= ${__ELAB_TOUCH_FILE_DIR}/aacer_signature^vcs_elab_vars.111
__ELAB_VARS_SIGNATURE 	?=
__ELAB_VARS_SIGNATURE 	+= __VCS_OPTS='${__VCS_OPTS}'
__ELAB_VARS_SIGNATURE 	+= VCS_OPTS='${VCS_OPTS}'
__ELAB_VARS_SIGNATURE 	+= VCS_OPTS_='${VCS_OPTS_}'
__ELAB_VARS_SIGNATURE 	:= $(filter-out -reportstats,${__ELAB_VARS_SIGNATURE})
ifneq (${__CHECK_ELAB_VARS},)
${__CHECK_ELAB_VARS}: __check_elab_vars
	@:
	
.PHONY: __check_elab_vars
__check_elab_vars:
	$(call __check_signature_exec,${__CHECK_ELAB_VARS},${__ELAB_VARS_SIGNATURE},)
endif


__VCS_SIM_EXEC_DEPS += ${__VCS_DPI_FILES}
ifneq (${__SYNOPSYS_SIM_SETUP_OPTS},)
	__VCS_MX_UPDATE_SYNOPSYS_SIM_SETUP ?= ${__ELAB_TOUCH_FILE_DIR}/aacer_target^vcs_elab_update_synopsys_sim.setup_opts
	__VCS_SIM_EXEC_DEPS += ${__VCS_MX_UPDATE_SYNOPSYS_SIM_SETUP}
endif
__VCS_SIM_EXEC_DEPS += ${AARGR_SIM_TOP}
__VCS_SIM_EXEC_DEPS += ${AARGR_ABV}
__VCS_SIM_EXEC_DEPS += ${__CHECK_ELAB_VARS}

ifneq (${__VCS_MX_UPDATE_SYNOPSYS_SIM_SETUP},)
.SECONDEXPANSION:
${__VCS_MX_UPDATE_SYNOPSYS_SIM_SETUP}: \
		${__VCS_MX_UPDATE_SYNOPSYS_SIM_SETUP_DEPS} \
		${__ELAB_INIT_OOPS}
	$(call __open_task,Update synopsys_sim.setup for elaboration,${__ELAB_INFO})
	$(call __exec, ${CD} ${__ELAB_BIN_DIR} && \
       		${__ADD_SYNOPSYS_SIM_SETUP_OPTION_SCRIPT} ${__SYNOPSYS_SIM_SETUP_OPTS}, \
       		${__ELAB_LOG}\
	)
	$(call __dummy, $@, ${__ELAB_LOG})
	$(call __close_task,${__ELAB_INFO})
endif

# elab tgt
__VCS_MX_SIMV_NAME_STRING = simv ##klw
__VCS_SIM_EXEC 		= ${__ELAB_BIN_DIR}/${__VCS_MX_SIMV_NAME_STRING}
__SIM_EXEC 		?= ${__VCS_SIM_EXEC}

__ELAB_TARGETS 		+= ${__VCS_SIM_EXEC}

ifneq (${__VCS_SIM_EXEC},)
.SECONDEXPANSION:
${__VCS_SIM_EXEC}: ${__VCS_SIM_EXEC_DEPS} \
		${ELAB_DEPS_} $${ELAB_DEPS} ${__ELAB_DEPS} | \
		${__VCS_SIM_EXEC_OOPS} \
		${__ELAB_INIT_OOPS} \
		${ELAB_OOPS_} $${ELAB_OOPS} ${__ELAB_OOPS}
	$(call __open_task,${__VCS_COMPILE_CMD_DESCRIPTION},${__ELAB_INFO})
	$(call __locked_exec, $(dir $@), \
		${CD} $(dir $@) && ${__VCS_COMPILE_CMD} \
		-o $(notdir $@), \
		${__ELAB_LOG},\
		1,\
	)
	$(call __close_task,${__ELAB_INFO})
endif

ifneq (${ELAB_DONE},1)
AARGR_ELAB = ${AARGR_ABV} ${AARGR_SIM_TOP} ${ELAB_DEPS_} $${ELAB_DEPS} ${__ELAB_DEPS} ${__ELAB_TARGETS} ${ELAB_TARGETS} ${ELAB_TARGETS_}
__ELAB_IGNORE_DEPS :=
else
AARGR_ELAB = 
__ELAB_IGNORE_DEPS := ${true}
endif

