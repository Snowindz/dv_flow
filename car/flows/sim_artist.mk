ifneq ($(strip ${AACER_MK_PRE_INCLUDES}),)
include ${AACER_MK_PRE_INCLUDES}
endif

#######################################################
# Pub Vars
#######################################################
######################
# message settings
######################
AACER_SILENT_INCLUDE ?= 1



# if AACER_MACRO_TRACE is enabled then calls to the lib functions are traced to stdout using 
# warning msag w/ their args
ifeq (${AACER_MACRO_TRACE},1)
__aacer_tr0 = $(warning $0())
__aacer_tr1 = $(warning $0('$1'))
__aacer_tr2 = $(warning $0('$1','$2'))
__aacer_tr3 = $(warning $0('$1','$2','$3'))
__aacer_tr4 = $(warning $0('$1','$2','$3','$4'))
else
__aacer_tr0 :=
__aacer_tr1 :=
__aacer_tr2 :=
__aacer_tr3 :=
__aacer_tr4 :=
endif



# $(call __aacer_warn,<message>)
define __aacer_warn
$(__aacer_tr1)$(eval __AACER_SESSION_WARNINGS += \n[aacer.mk] Warning: $1\n)
endef

ifneq (${AACER_COMP_LOCKS_ENABLED},0)
__AACER_COMP_LOCKS_ENABLED := 1
else
__AACER_COMP_LOCKS_ENABLED :=
endif

ifneq (${AACER_DUMMY_FILES_ENABLED},0)
__AACER_DUMMY_FILES_ENABLED := 1
else
__AACER_DUMMY_FILES_ENABLED :=
endif

ifneq (${AACER_SIGNATURES_ENABLED},0)
__AACER_SIGNATURES_ENABLED := 1
else
__AACER_SIGNATURES_ENABLED :=
endif

__AACER_REPORT_VARS += AACER_ENABLE_SOURCE_SIGNATURE_CHECKS AACER_COMP_LOCKS_ENABLED AACER_DUMMY_FILES_ENABLED AACER_SIGNATURES_ENABLED


######################
# Timestamp settings
######################
AACER_DATE_CMD 	?= date +"%a %b %d %T %Z %Y"
AACER_TIMESTAMP ?= `${AACER_DATE_CMD}`
AACER_TIME_CMD 	?= /usr/bin/env time $(if $(findstring SPARC,${PLATFORM}),-p,-v)
ifeq (${AACER_SILENT_INCLUDE},1)
__MAKE_SINCLUDE_SWITCH := -
else
__MAKE_SINCLUDE_SWITCH :=
endif

######################
# CAR source paths
######################
SIM_ARTIST_HOME ?= ${DV_CAR_ROOT}
# path to internal scripts
__AACER_POT_DIR := ${SIM_ARTIST_HOME}
__INT_SCRIPT_DIR := ${__AACER_POT_DIR}/scripts/internal
# path to internal sub-make
__FLOW_DIR 	:= ${__AACER_POT_DIR}/flows
# path to various template files
__TEMPLATE_DIR 	:= ${__AACER_POT_DIR}/templates

# Include common.mk
__AACER_COMMON_MK := ${__FLOW_DIR}/common.mk
include ${__AACER_COMMON_MK}


######################
# Screen and log file output scheme
######################
SHELL := /bin/bash
QUIET :=
__FORCE = 0

# Detect if run in -force (e.g., -B) rebuild-always mode.
ifneq ($(findstring B,${MAKEFLAGS}),)
__FORCE = 1
endif


######################
# Internal scripts
######################
__CONCAT_CMD_FILES_SCRIPT := ${__INT_SCRIPT_DIR}/ConcatCmdFiles.pl
__CHECK_SIGNATURE_SCRIPT := ${__INT_SCRIPT_DIR}/CheckSignature.pl



######################
# Run time dir
######################
# default test language type.  
# fsim:evcd; formal_ifv: '', cpp, vera
TESTCASE_TYPE ?= uvm
__AACER_REPORT_VARS += TESTCASE_TYPE
__TESTCASE_TYPE := $(call lc,${TESTCASE_TYPE})


ifeq (${__TESTCASE_TYPE},ovm)
__TESTCASE_TYPE = ovm_or_uvm
else ifeq (${__TESTCASE_TYPE},uvm)
__TESTCASE_TYPE = ovm_or_uvm
endif

HDL_DEFAULT_WORK_NAME ?= hdl_work
HVL_DEFAULT_WORK_NAME ?= tb_work
__AACER_REPORT_VARS += HDL_DEFAULT_WORK_NAME
__AACER_REPORT_VARS += HVL_DEFAULT_WORK_NAME

__HDL_DEFAULT_WORK_NAME ?= $(strip ${HDL_DEFAULT_WORK_NAME})
__HVL_DEFAULT_WORK_NAME ?= $(strip ${HVL_DEFAULT_WORK_NAME})

# sim_top work dir
ifeq (${__TESTCASE_TYPE},ovm_or_uvm)
SIM_TOP_WORK_NAME ?= ${__HVL_DEFAULT_WORK_NAME}
else
SIM_TOP_WORK_NAME ?= ${__SIM_TOP_DEFAULT_WORK_NAME}
endif
__AACER_REPORT_VARS += SIM_TOP_WORK_NAME
__SIM_TOP_WORK_NAME ?= ${SIM_TOP_WORK_NAME}

# Internal share spec, 
__COMMA := ,
__EMPTY :=
__SPACE := ${__EMPTY} ${__EMPTY}
__SHARE_SPEC := $(subst ${__COMMA},${__SPACE},${_SHARE_SPEC})

# Test randomization seed
SEED ?= 1
__AACER_REPORT_VARS += SEED
ifeq ($(call lc,${SEED}),rand)
override SEED := $(shell ${__PERL} -e 'print int(rand (rand (time) + time() - rand(time)))')
ifeq (${__VERBOSITY},DEBUG)
	$(info Debug: Random seed generated: ${SEED})
endif
endif


SIM := $(strip ${SIM})
export SIM
__AACER_REPORT_VARS += SIM

# regress level dir str
_REGRESS_DIR_STR ?= standalone
# setup dir 
_SETUP_DIR_STR ?= default

# Test name to construct test dir
TEST_NAME ?= no_test
TEST_NAME := $(strip ${TEST_NAME})
export TEST_NAME
__AACER_REPORT_VARS += TEST_NAME

# Test index used to construct the test dir
TEST_INDEX ?= 0
TEST_INDEX := $(strip ${TEST_INDEX})
__AACER_REPORT_VARS += TEST_INDEX

# car ID used to construct the test dir
AACER_ID ?=
AACER_ID := $(strip ${AACER_ID})
__AACER_REPORT_VARS += AACER_ID

# regress vs. standalone
_AACER_MODE ?= standalone
_TIME_STAMP_STR ?= ${SIM}

ifndef _UNMANAGED_AARGR_DIR
ifdef WORKSPACE
	UNMANAGED_DIR ?= ${WORKSPACE}/unmanaged
	__AACER_REPORT_VARS += UNMANAGED_DIR
endif
ifndef UNMANAGED_DIR
	$(call __aacer_error,UNMANAGED_DIR is not defined)
endif
	UNMANAGED_DIR := $(strip ${UNMANAGED_DIR})
	__AABLD_UNMANAGED_DIR = ${UNMANAGED_DIR}
else
	__AABLD_UNMANAGED_DIR = $(strip ${_UNMANAGED_AARGR_DIR})
endif

# assign a dir name under rgr
UNMANAGED_AARGR_DIR_ID ?= ${USER}
__UNMANAGED_AARGR_DIR_ID ?= $(strip ${UNMANAGED_AARGR_DIR_ID})
__AACER_REPORT_VARS += UNMANAGED_AARGR_DIR_ID

# unmanaged area
_UNMANAGED_AARGR_DIR ?= $(abspath ${UNMANAGED_DIR}/aargr/$(strip ${__UNMANAGED_AARGR_DIR_ID}))

# lib (share across all sims) dir
__LIBS_BASE_DIR := ${_UNMANAGED_AARGR_DIR}/libs/$(strip ${SHARE_ID})
AARGR_LIBS_DIR = ${__LIBS_BASE_DIR}

# flow depends simland: formaland/iceland/unr/unr/covercheck/fsimland
__RUN_BASE_DIR_NAME ?= simland

# setup dir
__SETUP_BASE_DIR := ${_UNMANAGED_AARGR_DIR}/$(strip ${__RUN_BASE_DIR_NAME})/$(strip ${_REGRESS_DIR_STR})/$(strip ${_SETUP_DIR_STR})
AARGR_SETUP_DIR = ${__SETUP_BASE_DIR}

# test dir
__TEST_BASE_DIR := ${__SETUP_BASE_DIR}/$(strip ${__TEST_DIR_STR})

# simulation dir
__SIM_DIR := ${__TEST_BASE_DIR}/$(strip ${_TIME_STAMP_STR})
AARGR_SIM_DIR := ${__SIM_DIR}

#######################################################
# Misc. default setup
#######################################################
# macro makefile: used in Misc setup
__AACER_MACROS_MK := ${__FLOW_DIR}/macros.mk
include ${__AACER_MACROS_MK}

#####################
# CS2MK
#####################
$(call __register_opts_vars,CS2MK)

# Script to genrate DUT/TB mk (TBD)
$(call __which_and_check,__CS2MK_SCRIPT,aacer_cs2mk)

# CS2MK command
# kailong's scripts
SKETCH = ${SIM_ARTIST_HOME}/Sketch
SIM_ARTIST_CS2MK = ${SKETCH}/sim_artist_cs2mk.py
__CS2MK_CMD = ${__PYTHON} ${SIM_ARTIST_CS2MK}



#######################################################
# Include Makefiles for various targets
#######################################################
# compatibility.mk

__AACER_TOOLS_MK := ${__FLOW_DIR}/tools.mk
include ${__AACER_TOOLS_MK}

# common_libs.mk
# abv_libs.mk
# abv.mk
# hdl.mk
# dut_libs.mk
# dut.mk
# elab_dut.mk
# th.mk

__AACER_HVL_MK := ${__FLOW_DIR}/hvl.mk
include ${__AACER_HVL_MK}

# tb_libs.mk


__AACER_TB_MK := ${__FLOW_DIR}/tb.mk
include ${__AACER_TB_MK}

# test.mk
# tb_doc.mk
# tb_lint.mk
# sandbox_ide.mk

__AACER_SIM_TOP_MK := ${__FLOW_DIR}/sim_top.mk
include ${__AACER_SIM_TOP_MK}

# aldec.mk
# synopsys.mk

__AACER_MISC_MK := ${__FLOW_DIR}/misc.mk
include ${__AACER_MISC_MK}

__AACER_ELAB_MK := ${__FLOW_DIR}/elab.mk
include ${__AACER_ELAB_MK}

# design_dump_info.mk
# hvl_link.mk
# hvl_link_indut.mk
# misc.mk
# hlverif.mk


__AACER_SIM_MK := ${__FLOW_DIR}/sim.mk
include ${__AACER_SIM_MK}

# prove.mk
# debug.mk
# app.mk
# coverage.mk
# ice.mk
# fsim.mk
# unr.mk
# vcs_unr.mk
# covercheck.mk
# pwrest.mk

#######################################################
# Pre and Post exec
#######################################################
#####################
# PRE
#####################
_PRE_DUT_CMD	?=
_PRE_TH_CMD 	?=
_PRE_TB_CMD 	?=
_PRE_ABV_CMD 	?=
_PRE_ELAB_CMD 	?=
_PRE_SIM_CMD 	?=
unexport _PRE_DUT_CMD
unexport _PRE_TH_CMD
unexport _PRE_TB_CMD
unexport _PRE_ABV_CMD
unexport _PRE_ELAB_CMD
unexport _PRE_SIM_CMD
__pre_tb :
ifneq (${_PRE_TB_CMD},${false})
	$(call __open_task,tb pre-exec,)
	$(if $(wildcard ${__TB_LOG_FILE}),,$(call __touch, ${__TB_LOG_FILE},))
	$(call __exec,${_PRE_TB_CMD},${__TB_LOG})
	$(call __close_task)
endif

__pre_abv :
ifneq (${_PRE_ABV_CMD},${false})
	$(call __open_task,abv pre-exec,)
	$(if $(wildcard ${__ABV_LOG_FILE}),,$(call __touch, ${__ABV_LOG_FILE},))
	$(call __exec,${_PRE_ABV_CMD},${__ABV_LOG})
	$(call __close_task)
endif

__pre_elab :
ifneq (${_PRE_ELAB_CMD},${false})
	$(call __open_task,elab pre-exec,)
	$(if $(wildcard ${__ELAB_LOG_FILE}),,$(call __touch, ${__ELAB_LOG_FILE},))
	$(call __exec,${_PRE_ELAB_CMD},${__SIM_TOP_LOG})
	$(call __close_task)
endif

__pre_sim :
ifneq (${_PRE_SIM_CMD},${false})
	$(call __open_task,sim pre-exec,)
	$(if $(wildcard ${__SIM_LOG_FILE}),,$(call __touch, ${__SIM_LOG_FILE},))
	$(call __exec,${_PRE_SIM_CMD},${__SIM_LOG})
	$(call __close_task)
endif


#####################
# POST
#####################
_POST_DUT_CMD 	?=
_POST_TH_CMD 	?=
_POST_TB_CMD 	?=
_POST_ABV_CMD 	?=
_POST_ELAB_CMD 	?=
_POST_SIM_CMD 	?=
unexport _POST_DUT_CMD
unexport _POST_TH_CMD
unexport _POST_TB_CMD
unexport _POST_ABV_CMD
unexport _POST_ELAB_CMD
unexport _POST_SIM_CMD

__post_tb :
ifneq (${_POST_TB_CMD},${false})
	$(call __open_task,tb post-exec,)
	$(if $(wildcard ${__TB_LOG_FILE}),,$(call __touch, ${__TB_LOG_FILE},))
	$(call __exec,${_POST_TB_CMD},${__TB_LOG})
	$(call __close_task)
endif

__post_abv :
ifneq (${_POST_ABV_CMD},${false})
	$(call __open_task,abv post-exec,)
	$(if $(wildcard ${__ABV_LOG_FILE}),,$(call __touch, ${__ABV_LOG_FILE},))
	$(call __exec,${_POST_ABV_CMD},${__ABV_LOG})
	$(call __close_task)
endif

__post_elab :
ifneq (${_POST_ELAB_CMD},${false})
	$(call __open_task,sim_top post-exec,)
	$(if $(wildcard ${__ELAB_LOG_FILE}),,$(call __touch, ${__ELAB_LOG_FILE},))
	$(call __exec,${_POST_ELAB_CMD},${__SIM_TOP_LOG})
	$(call __close_task)
endif

__post_sim_top :
__post_sim :
ifneq (${_POST_SIM_CMD},${false})
	$(call __open_task,sim post-exec,)
	$(if ${COMPRESS_LOG_}, $(if $(wildcard ${__SIM_LOG_FILE}.gz),,$(call __touch, \
	${__SIM_LOG_FILE}.gz,)), $(if $(wildcard ${__SIM_LOG_FILE}),,$(call __touch, ${__SIM_LOG_FILE},)))
	$(call __exec,${_POST_SIM_CMD},${__SIM_LOG})
	$(call __close_task)
endif



#####################
# Targets 
#####################
tb: __pre_tb ${AARGR_TB} __post_tb ${__TB_CHECK_DEPS}
	@echo ${__TB_MK}
	@echo " #### TB DONE ####"
	@echo

sim_top: ${AARGR_SIM_TOP} ${__SIM_TOP_CHECK_DEPS} __post_sim_top
	@echo ${AARGR_SIM_TOP}
	@echo " #### SIM_TOP DONE ####"
	@echo

elab: __pre_elab ${AARGR_ELAB} __post_elab ${__ELAB_CHECK_DEPS}
	@echo
	@echo " #### ELAB DONE ####"
	@echo

misc: ${AARGR_MISC} ${__MISC_CHECK_DEPS}
	@echo
	@echo " #### MISC DONE ####"
	@echo

.SECONDEXPANSION:
sim: ${AARGR_ELAB} \
	${AARGR_MISC} \
	${AARGR_TEST} \
	${__SIM_DIR} \
	__pre_sim \
	${SIM_DEPS_} $${SIM_DEPS} ${__SIM_DEPS} \
	${__SIM_TARGETS} \
	${__POST_SIM} ${POST_SIM_} $${POST_SIM} \
	__post_sim ${__SIM_CHECK_DEPS}
	@echo
	@echo " #### SIM DONE ####"
	@echo

#####################
# PHONY_TARGETS
#####################
PHONY_TARGETS += tb
PHONY_TARGETS += sim_top
PHONY_TARGETS += elab
PHONY_TARGETS += sim
PHONY_TARGETS += __pre_tb
PHONY_TARGETS += __pre_elab
PHONY_TARGETS += __pre_sim
PHONY_TARGETS += __post_th
PHONY_TARGETS += __post_tb

