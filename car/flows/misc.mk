# For MISC (c/cpp dpi etc) compilation 

##################################################
# Public Vars
##################################################
# compile dir, doesn't capture tool, version and platform
MISC_COMPILE_DIR 	?= ${__SETUP_BASE_DIR}/misc


#########################
# DPI-C Files and Flags
#########################
DPI_C_FILES 		?=
DPI_C_FILES_ 		?=
DPI_CPP_FILES 		?=
DPI_CPP_FILES_ 		?=
__AACER_REPORT_VARS 	+= DPI_C_FILES DPI_C_FILES_ DPI_CPP_FILES DPI_CPP_FILES_

DPI_CFLAGS 		?=
DPI_CFLAGS_ 		?=
DPI_GCC_FLAGS 		?=
DPI_GCC_FLAGS_ 		?=
DPI_G++_FLAGS 		?=
DPI_G++_FLAGS_ 		?=
DPI_LDFLAGS 		?=
DPI_LDFLAGS_ 		?=
DPI_OBJS 		?=
DPI_OBJS_ 		?=
APPEND_DPI_LDFLAGS 	?= 
APPEND_DPI_OBJS 	?=
__AACER_REPORT_VARS	+= DPI_CFLAGS DPI_CFLAGS_ DPI_GCC_FLAGS DPI_GCC_FLAGS_ DPI_G++_FLAGS DPI_G++_FLAGS_ 
__AACER_REPORT_VARS	+= DPI_LDFLAGS DPI_LDFLAGS_ DPI_OBJS DPI_OBJS_ APPEND_DPI_LDFLAGS APPEND_DPI_OBJS

# skip checking for misc
MISC_DONE 		?= 0
__AACER_REPORT_VARS 	+= MISC_DONE

##################################################
# Internal Vars
##################################################
__MISC_COMPILE_DIR 	?= $(abspath ${MISC_COMPILE_DIR})

# bin dir for intermidiate files
__MISC_BIN_DIR 		:= ${__MISC_COMPILE_DIR}/${PLATFORM}

# Make bin dir visible to user
AARGR_MISC_DIR 		= ${__MISC_BIN_DIR}

# Dummy dir.
__MISC_TOUCH_FILE_DIR 	:= ${__MISC_BIN_DIR}/Makefile.Target

__CLEAN_MISC_ITEMS 	+= ${__MISC_COMPILE_DIR}

#########################
# DPI-C Files and Flags
#########################
__HDL_DPI_C_FILES 	?=
__TB_DPI_C_FILES 	?=
__TEST_DPI_C_FILES 	?=
__ABV_DPI_C_FILES 	?=
__SIM_TOP_DPI_C_FILES 	?=
__HDL_DPI_CPP_FILES 	?=
__TB_DPI_CPP_FILES 	?=
__TEST_DPI_CPP_FILES 	?=
__ABV_DPI_CPP_FILES 	?=
__SIM_TOP_DPI_CPP_FILES ?=

__DPI_OBJS 		+= $(abspath ${DPI_OBJS})
__DPI_OBJS 		+= $(abspath ${DPI_OBJS_})
__DPI_C_FILES 		+= $(abspath ${__DUT_LIBS_DPI_C_FILES})
__DPI_C_FILES 		+= $(abspath ${__TB_LIBS_DPI_C_FILES})
__DPI_C_FILES 		+= $(abspath ${__DUT_DPI_C_FILES})
__DPI_C_FILES 		+= $(abspath ${__HDL_DPI_C_FILES})
__DPI_C_FILES 		+= $(abspath ${__TB_DPI_C_FILES})
__DPI_C_FILES 		+= $(abspath ${__TEST_DPI_C_FILES})
__DPI_C_FILES 		+= $(abspath ${__ABV_DPI_C_FILES})
__DPI_C_FILES 		+= $(abspath ${__SIM_TOP_DPI_C_FILES})
__DPI_C_FILES 		+= $(abspath ${DPI_C_FILES})
__DPI_C_FILES 		+= $(abspath ${DPI_C_FILES_})
__DPI_CPP_FILES 	+= $(abspath ${__DUT_LIBS_DPI_CPP_FILES})
__DPI_CPP_FILES 	+= $(abspath ${__TB_LIBS_DPI_CPP_FILES})
__DPI_CPP_FILES 	+= $(abspath ${__DUT_DPI_CPP_FILES})
__DPI_CPP_FILES 	+= $(abspath ${__HDL_DPI_CPP_FILES})
__DPI_CPP_FILES 	+= $(abspath ${__TB_DPI_CPP_FILES})
__DPI_CPP_FILES 	+= $(abspath ${__TEST_DPI_CPP_FILES})
__DPI_CPP_FILES 	+= $(abspath ${__ABV_DPI_CPP_FILES})
__DPI_CPP_FILES 	+= $(abspath ${__SIM_TOP_DPI_CPP_FILES})
__DPI_CPP_FILES 	+= $(abspath ${DPI_CPP_FILES})
__DPI_CPP_FILES 	+= $(abspath ${DPI_CPP_FILES_})

#########################
# MISC
#########################
__DPI_LIB_NAME 		?= dpi_lib

ifneq ($(strip ${__DPI_C_FILES} ${__DPI_CPP_FILES} ${__DPI_OBJS}),)
    __DPI_CFLAGS += $(strip ${DPI_CFLAGS} ${DPI_CFLAGS_})
    __DPI_GCC_FLAGS += $(strip ${DPI_GCC_FLAGS} ${DPI_GCC_FLAGS_})
    __DPI_G++_FLAGS += $(strip ${DPI_G++_FLAGS} ${DPI_G++_FLAGS_})
    ifeq (${SIM},vcs_mx)
    __DPI_CFLAGS += -DVCS
    endif
    __DPI_LDFLAGS += $(strip ${DPI_LDFLAGS} ${DPI_LDFLAGS_})

    ifeq ($(strip ${__DPI_C_FILES} ${__DPI_CPP_FILES}),)
    __DPI_LINK_ONLY := 1
    else
    __DPI_LINK_ONLY :=
    endif
    
    ## VCS
    #klw ifeq (${__SIM_TOP_TOOL},vcs_mx)
    ifeq (vcs_mx,vcs_mx) ##klw_td 
        GEN_VCS_DPI_LIB 	?= 1
        __AACER_REPORT_VARS 	+= GEN_VCS_DPI_LIB
        __GEN_VCS_DPI_LIB 	?= $(strip ${GEN_VCS_DPI_LIB})
	
        VCS_RUNTIME_DPI_LINK 	?= 1
        __AACER_REPORT_VARS 	+= VCS_RUNTIME_DPI_LINK
        __VCS_RUNTIME_DPI_LINK ?= $(strip ${VCS_RUNTIME_DPI_LINK}) 
	
        ifeq (${__GEN_VCS_DPI_LIB},1) 
            __DPI_LIB = ${AARGR_MISC_DIR}/${__VCS_VERSION}/${__DPI_LIB_NAME}.so
            __DPI_LIB_DIR = $(call __dir,${__DPI_LIB})
            __DPI_INCLUDE_DIR = ${__VCS_HOME}/include
            __MISC_TARGETS 	+= ${__DPI_LIB}
            __DPI_C_OBJS 	+= $(foreach __item,$(call uniq,${__DPI_C_FILES}),$(call __get_obj_file,${__DPI_LIB_DIR},${__item}))
            __DPI_CPP_OBJS 	+= $(foreach __item,$(call uniq,${__DPI_CPP_FILES}),$(call __get_obj_file,${__DPI_LIB_DIR},${__item}))
            __DPI_OBJS 		+= ${__DPI_C_OBJS}
            __DPI_OBJS 		+= ${__DPI_CPP_OBJS}
            __DPI_LIB_DEPS 	+= ${__DPI_OBJS}
	    
            ifeq (${__VCS_RUNTIME_DPI_LINK},1) 
                __SIM_DEPS += ${__DPI_LIB}
                $(call __register_opts_vars,SIM_SIMV)
                __SIM_SIMV_OPTS += -sv_root ${__DPI_LIB_DIR} -sv_lib ${__DPI_LIB_NAME}
            else
                __ELAB_DEPS += ${__DPI_LIB}
                __ELAB_VCS_OPTS += ${__DPI_LIB}
            endif ## __VCS_RUNTIME_DPI_LINK
        endif ## __GEN_VCS_DPI_LIB
    endif ## ${__SIM_TOP_TOOL},vcs_mx
endif ##$(strip ${__DPI_C_FILES} ${__DPI_CPP_FILES} ${__DPI_OBJS})

#########################
# DPI-C Macro
#########################
# $(call __get_obj_file,<obj dir>,<file>)
define __get_obj_file
$(__aacer_tr2)$1/$(patsubst %$(suffix $(notdir $2)),%.o,$(notdir $2))
endef

# $(call __gen_dpi_c_rule,<obj dir>,<c file>)
define __gen_dpi_c_rule
$(__aacer_tr2)ifeq ($${__DPI_C_TARGET_DEFINED[$2]},)

ifneq ($${__AACER_SIGNATURES_ENABLED},)
__DPI_C_SIGNATURE_FILE[$2] = $1/aacer_signature^$(notdir $2)
__DPI_C_SIGNATURE[$2] += 2='$2'
__DPI_C_SIGNATURE[$2] += __DPI_CFLAGS='$${__DPI_CFLAGS}'
__DPI_C_SIGNATURE[$2] += DPI_CFLAGS[$(notdir $2)]='$${DPI_CFLAGS[$(notdir $2)]}'
__DPI_C_SIGNATURE[$2] += DPI_CFLAGS_[$(notdir $2)]='$${DPI_CFLAGS_[$(notdir $2)]}'
__DPI_C_SIGNATURE[$2] += __DPI_GCC_FLAGS='$${__DPI_GCC_FLAGS}'
__DPI_C_SIGNATURE[$2] += DPI_GCC_FLAGS[$(notdir $2)]='$${DPI_GCC_FLAGS[$(notdir $2)]}'
__DPI_C_SIGNATURE[$2] += DPI_GCC_FLAGS_[$(notdir $2)]='$${DPI_GCC_FLAGS_[$(notdir $2)]}'

$${__DPI_C_SIGNATURE_FILE[$2]}: __check_dpi_c_signature[$2]
	@:

.PHONY: __check_dpi_c_signature[$2]
__check_dpi_c_signature[$2]:
	$$(call __quiet_open_task,Checking signature for $2 DPI compile,$${__MISC_INFO})
	$$(call __check_signature_exec,$${__DPI_C_SIGNATURE_FILE[$2]},$${__DPI_C_SIGNATURE[$2]},$${__MISC_LOG})
	$$(call __quiet_close_task,$${__MISC_INFO})
	__DPI_C_DEPS[$2] += $${__DPI_C_SIGNATURE_FILE[$2]}
endif

__DPI_C_DEPS[$2] += $2

$(call __get_obj_file,$1,$2) : $${__DPI_C_DEPS[$2]}
	$$(call __mkdir,$$(@D),)
	$$(call __open_task,Compiling DPI-C file: $2,$${__MISC_INFO})
	$$(call __locked_exec,$${__DPI_LIB_DIR},$${CD} $1 && $${__CC} $${__DPI_CFLAGS} $${DPI_CFLAGS[$(notdir $2)]} $${DPI_CFLAGS_[$(notdir $2)]} $${__DPI_GCC_FLAGS} $${DPI_GCC_FLAGS[$(notdir $2)]} $${DPI_GCC_FLAGS_[$(notdir $2)]} -c -fPIC $2 -Bsymbolic -I$${__DPI_INCLUDE_DIR} -o $$(subst $1,.,$$@), $${__MISC_LOG})
	$$(call __close_task,${__MISC_INFO})

__DPI_C_TARGET_DEFINED[$2] = ${true}

endif

endef

# $(call __gen_dpi_cpp_rule,<obj dir>,<c file)
define __gen_dpi_cpp_rule
$(__aacer_tr2)ifeq ($${__DPI_C_TARGET_DEFINED[$2]},)

ifneq ($${__AACER_SIGNATURES_ENABLED},)
__DPI_C_SIGNATURE_FILE[$2] = $1/aacer_signature^$(notdir $2)
__DPI_C_SIGNATURE[$2] += 2='$2'
__DPI_C_SIGNATURE[$2] += __DPI_CFLAGS='$${__DPI_CFLAGS}'
__DPI_C_SIGNATURE[$2] += DPI_CFLAGS[$(notdir $2)]='$${DPI_CFLAGS[$(notdir $2)]}'
__DPI_C_SIGNATURE[$2] += DPI_CFLAGS_[$(notdir $2)]='$${DPI_CFLAGS_[$(notdir $2)]}'
__DPI_C_SIGNATURE[$2] += __DPI_G++_FLAGS='$${__DPI_G++_FLAGS}'
__DPI_C_SIGNATURE[$2] += DPI_G++_FLAGS[$(notdir $2)]='$${DPI_G++_FLAGS[$(notdir $2)]}'
__DPI_C_SIGNATURE[$2] += DPI_G++_FLAGS_[$(notdir $2)]='$${DPI_G++_FLAGS_[$(notdir $2)]}'

$${__DPI_C_SIGNATURE_FILE[$2]}: __check_dpi_c_signature[$2]
	@:

.PHONY: __check_dpi_c_signature[$2]
__check_dpi_c_signature[$2]:
	$$(call __quiet_open_task,Checking signature for $2 DPI compile,$${__MISC_INFO})
	$$(call __check_signature_exec,$${__DPI_C_SIGNATURE_FILE[$2]},$${__DPI_C_SIGNATURE[$2]},$${__MISC_LOG})
	$$(call __quiet_close_task,$${__MISC_INFO})

__DPI_C_DEPS[$2] += $${__DPI_C_SIGNATURE_FILE[$2]}
endif


__DPI_C_DEPS[$2] += $2
$(call __get_obj_file,$1,$2) : $${__DPI_C_DEPS[$2]}
	$$(call __mkdir,$$(@D),)
	$$(call __open_task,Compiling DPI-C++ file: $2,$${__MISC_INFO})
	$$(call __locked_exec,$${__DPI_LIB_DIR},$${CD} $1 && $${__CPP} $${__DPI_CFLAGS} $${DPI_CFLAGS[$(notdir $2)]} $${DPI_CFLAGS_[$(notdir $2)]} $${__DPI_G++_FLAGS} $${DPI_G++_FLAGS[$(notdir $2)]} $${DPI_G++_FLAGS_[$(notdir $2)]} -c -fPIC $2 -Bsymbolic -I$${__DPI_INCLUDE_DIR} -o $$(subst $1,.,$$@), $${__MISC_LOG})
	$$(call __close_task,${__MISC_INFO})

__DPI_C_TARGET_DEFINED[$2] = ${true}
endif

endef

############################################
# Rules
############################################
# __DPI_LIBS_DEPS
#ifeq (${REBUILD},${true})
$(foreach __item,$(call uniq,${__DPI_C_FILES}),$(eval $(call __gen_dpi_c_rule,${__DPI_LIB_DIR},${__item})))
$(foreach __item,$(call uniq,${__DPI_CPP_FILES}),$(eval $(call __gen_dpi_cpp_rule,${__DPI_LIB_DIR},${__item})))

__DPI_LIB_DEPS += ${__DPI_OBJS}

# __MISC_TARGETS
ifneq (${__DPI_LIB},)
__DPI_C_COMPILE_TOUCH_FILE = ${__DPI_LIB_DIR}/Makefile.Target/aacer_target^dpi_c_compile
__DPI_CPP_COMPILE_TOUCH_FILE = ${__DPI_LIB_DIR}/Makefile.Target/aacer_target^dpi_cpp_compile
endif

ifneq (${__DPI_LIB},)
${__DPI_LIB}: ${__DPI_LIB_DEPS}
	$(call __mkdir,${__DPI_LIB_DIR},)
	$(call __open_task,Link DPI library,${__MISC_INFO})
	$(call __locked_exec,${__DPI_LIB_DIR},${CD} ${__DPI_LIB_DIR} && ${__CPP} ${__DPI_LDFLAGS} $(subst ${__DPI_LIB_DIR},.,$(call uniq,${__DPI_OBJS})) ${APPEND_DPI_LDFLAGS} ${APPEND_DPI_OBJS} -fPIC -shared -Bsymbolic -o $@, ${__MISC_LOG})
	$(call __close_task,${__MISC_INFO})
endif

# MISC
ifneq (${MISC_DONE},1)
AARGR_MISC = ${MISC_DEPS_} $${MISC_DEPS} ${__MISC_DEPS} ${__MISC_TARGETS}
__MISC_IGNORE_DEPS :=
else
AARGR_MISC =
__MISC_IGNORE_DEPS := ${true}
endif

#endif ## REBUILD

