HVL_TOP_SPEC		?=
__AACER_REPORT_VARS 	+= HVL_TOP_SPEC
TB_SPEC_PATHS 		?= $(if ${WORKSPACE},${WORKSPACE}/libs ${WORKSPACE}/core_libs ${WORKSPACE}/verif/sim,)
TB_SPEC_PATHS_ 		?=
__AACER_REPORT_VARS 	+= TB_SPEC_PATHS
__AACER_REPORT_VARS 	+= TB_SPEC_PATHS_
HVL_SPEC_PATHS 		?= ${TB_SPEC_PATHS}
HVL_SPEC_PATHS_ 	?= ${TB_SPEC_PATHS_}
__AACER_REPORT_VARS 	+= HVL_SPEC_PATHS
__AACER_REPORT_VARS 	+= HVL_SPEC_PATHS_
HVL_SPEC_NO_MAKEFILE 	?= 0
HVL_SPEC_NO_XML 	?= 0
__AACER_REPORT_VARS 	+= HVL_SPEC_NO_MAKEFILE
__AACER_REPORT_VARS 	+= HVL_SPEC_NO_XML

HVL_COMPILE_MODE 	?= hier
HVL_COMPILE_MODE 	:= $(strip ${HVL_COMPILE_MODE})
__AACER_REPORT_VARS 	+= HVL_COMPILE_MODE

TB_TOP_SPEC 		?= ${HVL_TOP_SPEC}
TB_TOP_SPEC 		:= $(strip ${TB_TOP_SPEC})
TB_TARGET_SPEC 		?= $(strip ${TB_TOP_SPEC})
TB_TARGET_SPECS 	?= $(strip ${TB_TARGET_SPEC})
__AACER_REPORT_VARS 	+= TB_TARGET_SPECS
ifneq (${HVL_TOP_SPEC},) 
__HVL_TOP_SPEC 		:= $(strip ${HVL_TOP_SPEC})
else
__HVL_TOP_SPEC 		:= $(strip ${TB_TOP_SPEC})
endif


__HVL_SPEC_PATHS 	= $(call __spec_abspath,${HVL_SPEC_PATHS} ${HVL_SPEC_PATHS_})
__HVL_HOTFIX_PATHS 	= $(call __spec_abspath,${HVL_HOTFIX_PATHS} ${HVL_HOTFIX_PATHS_})
__HVL_SPEC_NO_MAKEFILE 	?= $(strip ${HVL_SPEC_NO_MAKEFILE})
__HVL_SPEC_NO_XML 	?= $(strip ${HVL_SPEC_NO_XML})
__HVL_CS2MK_OPTS 	+= -type hvl
__HVL_CS2MK_OPTS 	+= -task ${__HVL_TASK}
__HVL_CS2MK_OPTS 	+= -top ${__HVL_TOP_SPEC}
__HVL_CS2MK_OPTS 	+= -tool ${__HVL_TOOL}
__HVL_CS2MK_OPTS 	+= -mode ${HVL_COMPILE_MODE}
__HVL_CS2MK_OPTS 	+= -disable_global_libs

ifeq (${__HVL_SPEC_NO_MAKEFILE},1)
__HVL_CS2MK_OPTS 	+= -no_makefile
endif

ifeq (${__HVL_SPEC_NO_XML},1) 
__HVL_CS2MK_OPTS 	+= -no_xml
else
__HVL_XML_SPEC_OPT 	+= $(addprefix -spec_path , ${__HVL_SPEC_PATHS})
__HVL_XML_SPEC_OPT 	+= $(addprefix -hotfix_path , ${__HVL_HOTFIX_PATHS})
__HVL_CS2MK_OPTS 	+= ${__HVL_XML_SPEC_OPT}
endif

ifeq (${TB_TARGET_SPECS},) 
TB_TARGET_SPECS 	= $(strip ${__HVL_TOP_SPEC})
endif
__GEN_TB_MK ?= 1
ifeq (${__GEN_TB_MK},1)
__TB_ONLY_CS2MK_OPTS 	+= -prefix tb
__TB_ONLY_CS2MK_OPTS 	+= -block '${TB_TARGET_SPECS}'
__TB_ONLY_CS2MK_OPTS 	+= -output_dir ${__TB_BIN_DIR}
__TB_ONLY_CS2MK_OPTS 	+= -default_work ${HVL_DEFAULT_WORK_NAME}
__TEST_CS2MK_OPTS 	+= ${__TB_ONLY_CS2MK_OPTS} -gen_output 0
__TB_CS2MK_OPTS 	+= ${__TB_ONLY_CS2MK_OPTS} -gen_output 1
__TB_LIBS_CS2MK_OPTS 	+= ${__TB_ONLY_CS2MK_OPTS} -gen_output 0
endif

__HVL_TOOL_VERSION 	:= ${__SIM_TOP_TOOL_VERSION}
__HVL_TASK 		?= sim
__AARGR_TESTCASE_TYPE 	:= ${__TESTCASE_TYPE}
export __AARGR_TESTCASE_TYPE

__HVL_COMPILE_VARS_SIGNATURE ?=
__HVL_COMPILE_VARS_SIGNATURE +=
__HVL_COMPILE_VARS_SIGNATURE += __TB_DEFINES='${__TB_DEFINES}'
__HVL_COMPILE_VARS_SIGNATURE += __TB_INCDIRS='${__TB_INCDIRS}'
__HVL_COMPILE_VARS_SIGNATURE += VLOGAN_OPTS='${VLOGAN_OPTS}'
__HVL_COMPILE_VARS_SIGNATURE += VLOGAN_OPTS_='${VLOGAN_OPTS_}'
__HVL_COMPILE_VARS_SIGNATURE += TB_VHDLAN_OPTS='${TB_VHDLAN_OPTS}'
__HVL_COMPILE_VARS_SIGNATURE += TB_VHDLAN_OPTS_='${TB_VHDLAN_OPTS_}'
__HVL_COMPILE_VARS_SIGNATURE += TB_VLOGAN_OPTS='${TB_VLOGAN_OPTS}'
__HVL_COMPILE_VARS_SIGNATURE += TB_VLOGAN_OPTS_='${TB_VLOGAN_OPTS_}'
__HVL_COMPILE_VARS_SIGNATURE += TB_SYSCAN_OPTS='${TB_SYSCAN_OPTS}'
__HVL_COMPILE_VARS_SIGNATURE += TB_SYSCAN_OPTS_='${TB_SYSCAN_OPTS_}'

ifeq (${REBUILD},${true})

endif ## REBUILD
