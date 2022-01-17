a1 = a1
TB_COMPILE_DIR 	?=
__AACER_REPORT_VARS += TB_COMPILE_DIR
TB_BIN_DIR 	?=
__AACER_REPORT_VARS += TB_BIN_DIR
AARGR_TB_DIR 	= ${__TB_BIN_DIR}
TB_TOP_SPECS 	?=
__AACER_REPORT_VARS += TB_TOP_SPECS
TB_COMPILE_MODE ?= ${__HVL_COMPILE_MODE}
__AACER_REPORT_VARS += TB_COMPILE_MODE
TB_TASK ?= ${__HVL_TASK}
__AACER_REPORT_VARS += TB_TASK
TB_TARGET_SPECS ?= ${TB_TOP_SPECS}
__AACER_REPORT_VARS += TB_TARGET_SPECS
TB_SPEC_PATHS 	?= ${HVL_SPEC_PATHS}
TB_SPEC_PATHS_ 	?= ${HVL_SPEC_PATHS_}
__AACER_REPORT_VARS += TB_SPEC_PATHS TB_SPEC_PATHS_
TB_HOTFIX_PATHS ?= ${HVL_HOTFIX_PATHS}
TB_HOTFIX_PATHS_ ?= ${HVL_HOTFIX_PATHS_}
__AACER_REPORT_VARS += TB_HOTFIX_PATHS TB_HOTFIX_PATHS_
TB_DEFINES 	?=
TB_DEFINES_ 	?=
__AACER_REPORT_VARS += TB_DEFINES TB_DEFINES_
TB_INCDIRS 	?=
TB_INCDIRS_ 	?=
__AACER_REPORT_VARS += TB_INCDIRS TB_INCDIRS_
TB_LIBS 	?=
__AACER_REPORT_VARS += TB_LIBS
TB_MK_DEPS 	?=
__AACER_REPORT_VARS += TB_MK_DEPS
TB_MK_VARS_SIGNATURE ?=
__AACER_REPORT_VARS += TB_MK_VARS_SIGNATURE
TB_DEFAULT_WORK_NAME ?= tb_work
__AACER_REPORT_VARS += TB_DEFAULT_WORK_NAME
TB_DONE 	?= 0
__AACER_REPORT_VARS += TB_DONE
ifneq (${TB_COMPILE_DIR},)
__TB_COMPILE_DIR := $(abspath ${TB_COMPILE_DIR})
else
__TB_COMPILE_DIR := ${__SETUP_BASE_DIR}/tb
endif
ifneq (${TB_BIN_DIR},)
__TB_BIN_DIR := ${TB_BIN_DIR}
else
__TB_BIN_DIR := ${__TB_COMPILE_DIR}/${__HVL_TOOL}/${__HVL_TOOL_VERSION}/${PLATFORM}
endif
export AARGR_TB_DIR := ${__TB_BIN_DIR}

__TB_TOUCH_FILE_DIR ?= ${__TB_BIN_DIR}/Makefile.Target
__TB_DEFINES ?= $(strip ${TB_DEFINES} ${TB_DEFINES_})
__TB_INCDIRS ?= $(strip ${TB_INCDIRS} ${TB_INCDIRS_})
ifeq (${__HVL_TOOL},vcs_mx)
__TB_DEFINES += +define+VCS
__TB_VLOGAN_OPTS += ${__TB_INCR_OPTS}
__TB_VLOGAN_OPTS += ${__TB_DEFINES}
__TB_VLOGAN_OPTS += ${__TB_INCDIRS}
endif

__TB_INIT ?= ${__TB_TOUCH_FILE_DIR}/aacer_target^tb_init
__TB_MK = ${__TB_BIN_DIR}/${__HVL_TOP_SPEC}_${HVL_COMPILE_MODE}_tb.mk
ifeq (${TB_DONE},1)
include ${__TB_MK}
else
$(eval ${__MAKE_SINCLUDE_SWITCH}include ${__TB_MK})
__TB_CHECK_DEPS += ${__TB_MK} 
endif

ifeq (${__GEN_TB_MK},1)
ifeq (${TB_DONE},1)
## Skip rule definition if TB_DONE=1. ?Assume makefile already exists
else
##########
## Additional cs2mk rebuild checking for TB.
##########
TB_MK_VARS_SIGNATURE ?=
__TB_MK_VARS_SIGNATURE ?=
__CHECK_TB_MK_VARS = ${__TB_TOUCH_FILE_DIR}/aacer_signature^tb_mk_vars.${__HVL_TOP_SPEC}_${HVL_COMPILE_MODE}
__TB_MK_DEPS += ${__CHECK_TB_MK_VARS}
TB_MK_DEPS ?=
__TB_MK_DEPS += $${TB_MK_DEPS}
__TB_MK_DEPS += $${AACER_DEPS} $${AACER_DEPS_} ${__AACER_DEPS}
## Check if dependent variables have changed and regenerate makefile accordingly
__TB_MK_VARS_SIGNATURE += __CS2MK_OPTS='${__CS2MK_OPTS}'
__TB_MK_VARS_SIGNATURE += TB_MK_VARS_SIGNATURE='${TB_MK_VARS_SIGNATURE}'
__TB_MK_VARS_SIGNATURE += HVL_DEFAULT_WORK_NAME='${HVL_DEFAULT_WORK_NAME}'
__TB_MK_VARS_SIGNATURE += __HVL_SPEC_PATHS='${__HVL_SPEC_PATHS}'
__TB_MK_VARS_SIGNATURE += __HVL_HOTFIX_PATHS='${__HVL_HOTFIX_PATHS}'
__TB_MK_VARS_SIGNATURE += TB_TARGET_SPECS='${TB_TARGET_SPECS}'

##########
# Rule to generate TB makefile.
##########
.SECONDEXPANSION:
__tb_mk ${__TB_MK}: __CURRENT_TARGET = tb
__tb_mk ${__TB_MK}: __CURRENT_LOG_FILE = ${__TB_LOG_FILE}
__tb_mk ${__TB_MK}: $$(wildcard $${__TB_SPEC_FILES}) ${__TB_MK_DEPS}
	$(call __aafene_open_task,Generate TB makefile (${HVL_COMPILE_MODE}),${__TB_INFO})
	$(call __killer_mkdir, ${__TB_BIN_DIR},${__TB_LOG})
	$(call __killer_mkdir, ${__TB_TOUCH_FILE_DIR},${__TB_LOG})
	$(call __assert_defined,__HVL_TOOL,Internal Error: $$\{__HVL_TOOL\} not defined.,${__TB_LOG})
	$(call __killer_locked_exec, ${__TB_MK}, $(@D), \
	${CD} $(@D) && ${__CS2MK_CMD} \
	${__HVL_CS2MK_OPTS} ?\
	-disable_global_libs \
	$(addprefix -src_filter_file ,${__TB_SRC_FILTER_FILES}) \
	${__TB_CS2MK_OPTS}, \
	${__TB_LOG})
	$(call __close_task,${__TB_INFO})

${__CHECK_TB_MK_VARS}: __check_tb_mk_vars
	@: 

.PHONY: __check_tb_mk_vars
__check_tb_mk_vars: 
	$(call __check_signature_exec,${__CHECK_TB_MK_VARS},${__TB_MK_VARS_SIGNATURE},)
	$(if $(strip ${__TB_SPEC_FILES}),$(if $(call seq,${__TB_SPEC_FILES},$(wildcard ${__TB_SPEC_FILES})),,@touch ${__CHECK_TB_MK_VARS}),)
	$(if $(strip ${__TB_SPEC_FILES}),$(call __check_signature_exec,${__CHECK_TB_MK_VARS}.missing_spec_files,MISSING_SPEC_FILES=$(call uniq,$(filter-out $(wildcard ${__TB_SPEC_FILES}),${__TB_SPEC_FILES})),),)

endif
endif

ifeq (${__TB_TOOL},modelsim)
__TB_MAKE_WORK_CMD = ${__VLIB}
else ifeq (${__TB_TOOL},tbx)
__TB_MAKE_WORK_CMD = ${__TBXLIB}
else
__TB_MAKE_WORK_CMD = ${MKDIR}
endif

ifneq (${__MAP_WORK_CMD[${__TB_TOOL}]},)
__TB_MAP_WORK_CMD ?= ${__MAP_WORK_CMD[${__TB_TOOL}]}
else
__TB_MAP_WORK_CMD ?= ${__MAP_WORK_CMD[others]}
endif

ifneq ($(strip ${__TB_LIBS}),)
## Rule to create work libraries
__TB_MAKE_WORK ?= ${__TB_TOUCH_FILE_DIR}/aacer_target^tb_make_work
ifneq (${TB_DONE},1) 
ifneq (${__TB_MAKE_WORK},)
$(foreach __item,${__TB_LIB_PATHS},$(eval $(call __gen_make_work_rule,${__item},$${__TB_MAKE_WORK_CMD},$${__TB_INFO},$${__TB_LOG})))
${__TB_MAKE_WORK}: | ${__TB_LIB_PATHS} 
	$(call __dummy, $@, ${__TB_LOG})
endif
endif ## TB_DONE
__TB_INIT_OOPS += ${__TB_MAKE_WORK} 

ifneq (${__TB_MAP_WORK_CMD},)
$(foreach __item,${__TB_LIBS},$(eval $(call __gen_map_work_vars,tb,${__item})))
## Rule to map created work libraries
__TB_MAP_WORK ?= ${__TB_TOUCH_FILE_DIR}/aacer_target^tb_map_work
ifneq (${TB_DONE},1)
ifneq (${__TB_MAP_WORK},) 
	## update synopsys_sim_setup file to add synopsys_sim_setup opt
	$(foreach __tool,${__TB_TOOLS},$(eval $(call __gen_update_map_file_rule,tb,${__tool})))
	## map work
	$(foreach __tool,${__TB_TOOLS},$(foreach __item,${__COMMON_LIBS_WORK_NAMES},$(eval $(call __gen_map_work_rule,tb,${__item},${__tool}))))
	$(foreach __tool,${__TB_TOOLS},$(foreach __item,${__TB_LIBS_WORK_NAMES},$(eval $(call __gen_map_work_rule,tb,${__item},${__tool}))))
	$(foreach __tool,${__TB_TOOLS},$(foreach __item,${__TB_WORK_NAMES},$(eval $(call __gen_map_work_rule,tb,${__item},${__tool}))))
	
${__TB_MAP_WORK}: | ${__TB_MAP_WORK_TARGETS}
	$(call __dummy, $@, ${__TB_LOG})
__TB_INIT_OOPS += ${__TB_MAP_WORK}
endif ## __TB_MAP_WORK
endif

__TB_INIT_OOPS += ${__TB_UPDATE_MAP_FILE_TARGETS}
endif
endif

${__TB_INIT}: ${__TB_INIT_DEPS} | ${__TB_INIT_OOPS}
	$(call __dummy, $@, ${__TB_LOG})

__TB_MK_CNTRL_FLAG := ${__GEN_TB_MK}
ifeq ($(strip ${__TB_MK_CNTRL_FLAG}),1) 
__TB_AAFENE_TARGETS += $(foreach target_spec,${TB_TARGET_SPECS},${__HVL_AAFENE_TARGET[${target_spec}]})
__TB_TARGETS += ${__TB_AAFENE_TARGETS}
ifeq (${__TB_MK_INCLUDED},${true}) 
ifeq (${__TB_AAFENE_TARGETS},)
$(call __aacer_screen_warn,No matching compile spec rules found for 'tb' (TB_TARGET_SPECS='${TB_TARGET_SPECS}').)
endif
endif
endif


ifeq (${REBUILD},${true})
ifneq (${__AACER_SIGNATURES_ENABLED},)
__CHECK_HVL_COMPILE_VARS = ${__TB_TOUCH_FILE_DIR}/aacer_signature^hvl_compile_vars
__TB_DEPS += ${__CHECK_HVL_COMPILE_VARS}
endif
endif

ifneq (${__CHECK_HVL_COMPILE_VARS},)
${__CHECK_HVL_COMPILE_VARS}: __check_hvl_compile_signature
	@:

.PHONY: __check_hvl_compile_signature
__check_hvl_compile_signature: 
	$(call __check_signature_exec,${__CHECK_HVL_COMPILE_VARS},${__HVL_COMPILE_VARS_SIGNATURE},)
endif

ifneq (${TB_DONE},1)
.SECONDEXPANSION:
AARGR_TB = ${AARGR_COMMON_LIBS} ${AARGR_TB_LIBS} ${TB_DEPS_} $${TB_DEPS} ${__TB_DEPS} ${__TB_TARGETS} ${TB_TARGETS} ${TB_TARGETS_}
__TB_IGNORE_DEPS :=
else
AARGR_TB =
__TB_IGNORE_DEPS := ${true}
endif

ifeq (${REBUILD},${true})
endif ## REBUILD

