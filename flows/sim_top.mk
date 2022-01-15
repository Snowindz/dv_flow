SIM_TOP_COMPILE_DIR ?=
SIM_TOP_BIN_DIR ?=
SIM_TOP_DEFAULT_WORK_NAME ?= sim_top_work
SIM_TOP_DONE ?= 0
SIM_TOP_DEFAULT_WORK_NAME ?= sim_top_work
SIM_TOP_TASK ?= sim
SIM_TOP_COMPILE_DIR ?=
__AACER_REPORT_VARS += SIM_TOP_COMPILE_DIR

ifneq (${SIM_TOP_COMPILE_DIR},)
__SIM_TOP_COMPILE_DIR ?= ${SIM_TOP_COMPILE_DIR}
else
__SIM_TOP_COMPILE_DIR ?= ${__TB_COMPILE_DIR}
endif

SIM_TOP_BIN_DIR ?=
ifneq (${SIM_TOP_BIN_DIR},)
__SIM_TOP_BIN_DIR = ${SIM_TOP_BIN_DIR}
else
__SIM_TOP_BIN_DIR = ${__TB_BIN_DIR}
endif

__CLEAN_SIM_TOP_ITEMS += ${__SIM_TOP_COMPILE_DIR}

AARGR_SIM_TOP_DIR = ${__SIM_TOP_BIN_DIR}
__SIM_TOP_TOUCH_FILE_DIR ?= ${__SIM_TOP_BIN_DIR}/Makefile.Target
__SIM_TOP_MAP_WORK ?= ${__SIM_TOP_TOUCH_FILE_DIR}/aacer_target^sim_top_map_work
__SIM_TOP_TOOL = vcs_mx ##klw
__SIM_TOP_TOOLS = vcs_mx ##klw
__SIM_TOP_MAP_FILE_NAME ?= ${__MAP_FILE_NAME[vcs_mx]}
ifneq (${__SIM_TOP_MAP_FILE_NAME},)
__SIM_TOP_INIT_DEPS += ${__SIM_TOP_MAP_WORK}
endif ## __SIM_CONFIG_FILE_NAME

__SIM_TOP_INIT = ${__SIM_TOP_TOUCH_FILE_DIR}/aacer_target^sim_top_init
ifeq (${__TESTCASE_TYPE},ovm_or_uvm)
__SIM_TOP_DEPS += ${AARGR_TB}
endif
ifneq (${SIM_TOP_DONE},1)
AARGR_SIM_TOP = ${AARGR_DUT} ${AARGR_TH} ${__SIM_TOP_INIT} ${SIM_TOP_DEPS_} $${SIM_TOP_DEPS} ${__SIM_TOP_DEPS} ${__SIM_TOP_TARGETS} ${SIM_TOP_TARGETS} ${SIM_TOP_TARGETS_}
__SIM_TOP_IGNORE_DEPS :=
else
AARGR_SIM_TOP =
__SIM_TOP_IGNORE_DEPS := ${true}
endif

__SIM_TOP_WORK_NAME = ${SIM_TOP_WORK_NAME} ## it is defined is defined in sim_artist.mk
__SIM_TOP_LIBS += ${SIM_TOP_LIBS}
SIM_TOP ?= $(firstword ${__HDL_TOP_SPECS})
SIM_TOP_MODULE_NAME ?= ${SIM_TOP}
SIM_TOP_CONFIG_NAME ?= ${SIM_TOP_MODULE_NAME}
__AACER_REPORT_VARS += SIM_TOP_MODULE_NAME SIM_TOP_CONFIG_NAME
__SIM_TOP_CONFIG_NAME = $(strip ${SIM_TOP_CONFIG_NAME})
__SIM_TOP_MODULE_NAME = $(strip ${SIM_TOP_MODULE_NAME})
$(foreach __item,${__SIM_TOP_LIBS},$(eval $(call __gen_map_work_vars,sim_top,${__item})))
$(foreach __tool,${__SIM_TOP_TOOLS},$(eval $(call __gen_update_map_file_rule,sim_top,${__tool})))
ifneq (${__SIM_TOP_MAP_WORK},)
$(foreach __tool,${__SIM_TOP_TOOLS},$(foreach __item,${__COMMON_LIBS_WORK_NAMES},$(eval $(call __gen_map_work_rule,sim_top,${__item},${__tool}))))
$(foreach __tool,${__SIM_TOP_TOOLS},$(foreach __item,${__DUT_LIBS_WORK_NAMES},$(eval $(call __gen_map_work_rule,sim_top,${__item},${__tool}))))
$(foreach __tool,${__SIM_TOP_TOOLS},$(foreach __item,${__DUT_WORK_NAMES},$(eval $(call __gen_map_work_rule,sim_top,${__item},${__tool}))))
$(foreach __tool,${__SIM_TOP_TOOLS},$(foreach __item,${__TH_WORK_NAMES},$(eval $(call __gen_map_work_rule,sim_top,${__item},${__tool}))))
$(foreach __tool,${__SIM_TOP_TOOLS},$(foreach __item,${__TB_LIBS_WORK_NAMES},$(eval $(call __gen_map_work_rule,sim_top,${__item},${__tool}))))
$(foreach __tool,${__SIM_TOP_TOOLS},$(foreach __item,${__TB_WORK_NAMES},$(eval $(call __gen_map_work_rule,sim_top,${__item},${__tool}))))
$(foreach __tool,${__SIM_TOP_TOOLS},$(foreach __item,${__TEST_WORK_NAMES},$(eval $(call __gen_map_work_rule,sim_top,${__item},${__tool}))))
$(foreach __tool,${__SIM_TOP_TOOLS},$(foreach __item,${__SIM_TOP_WORK_NAMES},$(eval $(call __gen_map_work_rule,sim_top,${__item},${__tool}))))

${__SIM_TOP_MAP_WORK}: | ${__SIM_TOP_MAP_WORK_TARGETS}
	$(call __dummy, $@, ${__SIM_TOP_LOG})
endif

ifneq (${__SIM_TOP_INIT},)
${__SIM_TOP_INIT}: ${__SIM_TOP_INIT_DEPS}
	echo $^
	$(call __dummy, $@, ${__SIM_TOP_LOG})

endif ## __SIM_TOP_INIT

