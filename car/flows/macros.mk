# LC: TBD
###########################################
# MACRO defines for ACCER flow
###########################################

ifndef __macro_mk_guard
__macro_mk_guard = 1

$(call __include_trace)

# $(call __add_prereq)
define __add_prereq 
	@$(if ${__AACER_STATUS_DB},${__UPDATE_AACER_STATUS_SCRIPT} -db=${__AACER_STATUS_DB} -update_type=add_prereq -prereq=$1 -target=$@ -goal=${__CURRENT_TARGET} -sid=${__AACER_SID},)
endef

# $(call __aacer_screen_warn,<message>) -- doesn't get logged
define __aacer_screen_warn 
$(__aacer_tr1)$(info [aacer.mk] Warning: $1)
endef

# $(call __quiet_open_task, <task description>, <output redirection>
define __quiet_open_task
	$(__aacer_tr2)@$(if $(call seq,${AACER_TIME_TRACE},1),echo '['${AACER_TIMESTAMP}'] Make: [AACER_TIME_TRACE] '"'"'${__CURRENT_TARGET}'"'"' sub-task begin' $2,)
	@$(if $(call seq,${VERBOSITY},DEBUG),echo '['${AACER_TIMESTAMP}'] Make: $1 ...' $2,)
	@$(if ${__AACER_STATUS_DB},${__UPDATE_AACER_STATUS_SCRIPT} -db=${__AACER_STATUS_DB} -update_type=open_task -task_description='$1' -target=$@ -goal=${__CURRENT_TARGET} -sid=${__AACER_SID},)
	$(foreach __prereq,$^,$(call __add_prereq,${__prereq}))
	-$(call __open_rebar_script,$(call __dir,$@),$1)
endef

# $(call __quiet_close_task,<ouput redirection>)
define __quiet_close_task
	$(__aacer_tr1)@$(if $(call seq,${AACER_TIME_TRACE},1),echo '['${AACER_TIMESTAMP}'] Make: [AACER_TIME_TRACE] '"'"'${__CURRENT_TARGET}'"'"' sub-task end' $1,)
	@$(if ${__AACER_STATUS_DB},${__UPDATE_AACER_STATUS_SCRIPT} -db=${__AACER_STATUS_DB} -update_type=close_task -target=$@ -task_status=DONE -sid=${__AACER_SID},)
endef


# $(call __open_task,<task description>)
define __open_task
echo "$1" ...
endef

# $(call __task_fail)
ifeq (${_NO_LOG},1) 
	define __task_fail
		$(__aacer_tr0)echo "" $(if ${__AACER_STATUS_DB},;${__UPDATE_AACER_STATUS_SCRIPT} -db=${__AACER_STATUS_DB} -update_type=close_task -target=$@ -task_status=EXIT -sid=${__AACER_SID},)
	endef
else
	define __task_fail 
		$(__aacer_tr0)if [ -e ${__CURRENT_LOG_FILE} ]; \
		then \ 
			echo "["${AACER_TIMESTAMP}"] Make: *** Failed to make target '${__CURRENT_TARGET}'. See log file [${__CURRENT_LOG_FILE}]"; \
		fi$(if ${__AACER_STATUS_DB},;${__UPDATE_AACER_STATUS_SCRIPT} -db=${__AACER_STATUS_DB} -update_type=close_task -target=$@ -task_status=EXIT -sid=${__AACER_SID},)
	endef
endif

_AACER_LOCK_INFO ?=


# $(call __quiet_exec,<command>, <output redirection>)
define __quiet_exec
	$(__aacer_tr2)@ $1 $2
endef

# $(call __exec, <command>, <output redirection>,<expand backticks>)
# $(call __exec, <command>)
define __exec
$1
endef

# $(call __open_rebar_script, <remake script dir>, <description>)
define __open_rebar_script
	$(__aacer_tr2)@$(if $(call seq,${AACER_GEN_REMAKE_CSH},1),\
	cd $1 && \
	mkdir -p ${AACER_REMAKE_CSH_DIR} && \
	${__ENV_2_CSHRC_SCRIPT} ${AACER_REMAKE_CSH_DIR}/make_env.cshrc; \
	/bin/rm -f ${AACER_REMAKE_CSH_DIR}/${AACER_REMAKE_CSH_NAME} && \
	printf "#!/bin/tcsh -f\n" >> ${AACER_REMAKE_CSH_DIR}/${AACER_REMAKE_CSH_NAME} && \
	printf "## Script to manually remake $@\n" >> ${AACER_REMAKE_CSH_DIR}/${AACER_REMAKE_CSH_NAME} && \
	printf "\ncd $1\n" >> ${AACER_REMAKE_CSH_DIR}/${AACER_REMAKE_CSH_NAME} && \
	printf "\ncd ${AACER_REMAKE_CSH_DIR}\n" >> ${AACER_REMAKE_CSH_DIR}/${AACER_REMAKE_CSH_NAME} && \
	printf "\nif ( -e make_env.cshrc) then\n 	source make_env.cshrc\nendif\n" >> ${AACER_REMAKE_CSH_DIR}/${AACER_REMAKE_CSH_NAME} && \
	printf "\necho '['\`date\`'] Remake: $2 ...'\n" >> ${AACER_REMAKE_CSH_DIR}/${AACER_REMAKE_CSH_NAME} && \
	chmod +x ${AACER_REMAKE_CSH_DIR}/${AACER_REMAKE_CSH_NAME}, \
	)
endef

# $(call __locked_exec,<dir to lock>, <command>, <output redirection>, <expand backticks>)
define __locked_exec
-$2
endef

# $(call __killer_locked_exec, <makefile>, <dir to lock>, <command>, <output redirection>, <noft>)
define __killer_locked_exec
-$3
endef

# $(call __cp, <src>, <dest>, <output redirection>)
define __cp
$(call __mkdir, $(dir $2), $3)
/bin/cp -rLf $1 $2
endef

# ($call __quiet_rm, <things to remove, <output redirection>)
define __quiet_rm
	$(__aacer_tr2)if [ -e $1 -o -h $1 ]; \
	then \
		${CD} $(call __dir,$1) && \
		${MV} -f $(call __notdir,$1) .$(call __notdir,$1).deleted.${__AACER_PID} $2; \
		__aacer_$0_status=$${PIPESTATUS[0]}; \
		if [ $$__aacer_$0_status != 0 ]; \
		then \ 
			$(call __task_fail); \
			exit $$__aacer_$0_status; \
		fi; \
	fi; \
	${RM} .$(call __notdir,$1).deleted.${__AACER_PID} $2 &
endef

# $(call __touch, <touch object>, <output redirection>)
define __touch
	$(__aacer_tr2)$(call __mkdir, $(dir $1), $2)
		@ ${TOUCH} $1 $2; \
		__aacer_$0_status=$${PIPESTATUS[0]}; \
		if [ $$__aacer_$0_status != 0 ]; \
		then \
			$(call __task_fail); \
			exit $$__aacer_$0_status; \
		fi
		$(if $(call seq,${AACER_BUILD_TRACE},1),@echo touch $1,)
endef


# $(call __gen_map_work_vars,<type>,<lib>)
define __gen_map_work_vars
$(__aacer_tr2) 

ifeq (${__$(call uc,$1)_MAP_WORK_VARS_DEFINED[$(word 1,$(subst :, ,$2))]},) 
__$(call uc,$1)_WORK_PATH[$(word 1,$(subst :, ,$2))] ?= $(abspath $(word 2,$(subst :, ,$2)))
__$(call uc,$1)_WORK_NAMES += $(word 1,$(subst :, ,$2))
__$(call uc,$1)_MAP_WORK_VARS_DEFINED[$(word 1,$(subst :, ,$2))] ?= ${true}
endif ## __$(call uc,$1)_MAP_WORK_VARS_DEFINED[$(word 1,$(subst :, ,$2))]

ifeq (${__MAP_WORK_VARS_DEFINED[$(word 1,$(subst :, ,$2))]},)
__MAP_WORK_PATH[$(word 1,$(subst :, ,$2))] ?= $${__$(call uc,$1)_WORK_PATH[$(word 1,$(subst :, ,$2))]}
__MAP_WORK_TOOLS[$(word 1,$(subst :, ,$2))] ?= $${__$(call uc,$1)_TOOLS}
__MAP_WORK_VARS_DEFINED[$(word 1,$(subst :, ,$2))] ?= ${true}
endif ## __MAP_WORK_VARS_DEFINED[$(word 1,$(subst :, ,$2))]

endef


# $(call __gen_map_work_rule,<type>,<logical>,<tool>)
define __gen_map_work_rule
$(__aacer_tr3)

ifneq ($${__MAP_WORK_CMD[$3]},)
ifeq ($1,sim_top)
klw_dbg = $3_$2_$1
endif

ifeq ($$(filter $3,$${__MAP_WORK_TOOLS[$2]}),$3)

__MAP_WORK_TARGET[$1][$2][$3] ?= $${__$(call uc,$1)_TOUCH_FILE_DIR}/aacer_target^map_work.$3.$2
ifneq (${__AACER_SIGNATURES_ENABLED},)
__MAP_WORK_SIGNATURE[$1][$2][$3] ?= $${__$(call uc,$1)_TOUCH_FILE_DIR}/aacer_signature^map_work.$3.$2
endif

ifeq ($${__MAP_WORK_TARGET_DEFINED[$${__$(call uc,$1)_TOUCH_FILE_DIR}][$2][$3]},)

ifneq (${__AACER_SIGNATURES_ENABLED},)
$${__MAP_WORK_SIGNATURE[$1][$2][$3]}: __check_map_work_signature[$1][$2][$3]
	@:

.PHONY: __check_map_work_signature[$1][$2][$3]
__check_map_work_signature[$1][$2][$3]:
	$$(call __quiet_open_task,Checking signature for $3 $2 work mapping ($(call lc,$1)),)
	$$(call __check_signature_exec,$${__MAP_WORK_SIGNATURE[$1][$2][$3]},$${__MAP_WORK_PATH[$2]},)
	$$(call __quiet_close_task,)
endif

$${__MAP_WORK_TARGET[$1][$2][$3]} : $${__$(call uc,$1)_UPDATE_MAP_FILE_TARGETS} \
	$${__UPDATE_MAP_FILE_TARGET[$1][$3]} \
	$${__MAP_WORK_SIGNATURE[$1][$2][$3]} \
	| $${__MAP_WORK_PATH[$2]}
	echo klw_dbg $1
	$$(call __open_task,Mapping $2 for $3 ($(call lc,$1)),$${__$(call uc,$1)_INFO})
	$$(call __chmodw,$$(if $${__$(call uc,$1)_BIN_DIR},$${__$(call uc,$1)_BIN_DIR},$${__$(call uc,$1)_DIR})/$${__MAP_FILE_NAME[$3]},$${__$(call uc,$1)_LOG})
	$$(call __exec,$${CD} $$(if $${__$(call uc,$1)_BIN_DIR},$${__$(call uc,$1)_BIN_DIR},$${__$(call uc,$1)_DIR}) && $${__MAP_WORK_CMD[$3]} $2 $${__MAP_WORK_PATH[$2]},$${__$(call uc,$1)_LOG})
	$$(call __dummy, $$@,$${__$(call uc,$1)_LOG})
	$$(call __close_task,$${__$(call uc,$1)_INFO})

__MAP_WORK_TARGET_DEFINED[$${__$(call uc,$1)_TOUCH_FILE_DIR}][$2][$3] := ${true}

endif ## __MAP_WORK_TARGET_DEFINED[$${__$(call uc,$1)_TOUCH_FILE_DIR}][$2][$3]

__$(call uc,$1)_MAP_WORK_TARGETS += $${__MAP_WORK_TARGET[$1][$2][$3]}
endif ## __MAP_WORK_TOOLS[$2]
endif ## __MAP_WORK_CMD[$3]
endef


# $(call __gen_make_work_rule,<work>,<vlib>,<info>,<log>)
define __gen_make_work_rule
$(__aacer_tr4)ifeq (${__MAKE_WORK_TARGET_DEFINED[$1]},)
$1 : 
	${MKDIR} $$(@D)
	$$(call __mkdir,$$(@D),$4)
	$$(call __open_task,Creating $$(call __notdir,$$@) work library,$3)
	$$(call __exec,$${CD} $$(@D) && $2 $$(call __notdir,$$@),$4)
	$$(call __close_task,$3)
	
$(eval __MAKE_WORK_TARGET_DEFINED[$1] := ${true})

ifeq (${__MAKE_WORK_TARGET_DEFINED[$(call __notdir,$1)]},)
make_work.$(call __notdir,$1) : $1 
$(eval __MAKE_WORK_TARGET_DEFINED[$(call __notdir,$1)] := ${true})
endif

endif
endef


# $(call __gen_update_map_file_rule,<target>,<tool>)
define __gen_update_map_file_rule
$(__aacer_tr3)

ifneq ($${__MAP_FILE_NAME[$2]},)
ifeq ($1,tb)
abc = $2_$1
endif

__UPDATE_MAP_FILE_TARGET[$1][$2] ?= $${__$(call uc,$1)_TOUCH_FILE_DIR}/aacer_target^update_map_file.${__MAP_FILE_NAME[$2]}
ifeq ($${__UPDATE_MAP_FILE_TARGET_DEFINED[$${__$(call uc,$1)_TOUCH_FILE_DIR}][$2]},)
$${__UPDATE_MAP_FILE_TARGET[$1][$2]} : $${__BASE_MAP_FILE[${__MAP_FILE_NAME[$2]}]} 
	$$(call __open_task,Create $${__MAP_FILE_NAME[$2]} for $2 ($1),$${__$(call uc,$1)_INFO})
	$$(call __cp,$$<,$${__$(call uc,$1)_BIN_DIR}/$${__MAP_FILE_NAME[$2]},$${__$(call uc,$1)_LOG})
	$$(call __chmodw,$${__$(call uc,$1)_BIN_DIR}/$${__MAP_FILE_NAME[$2]},$${__$(call uc,$1)_LOG})
	ifeq ($2,modelsim)
	ifneq ($${__MODELSIM_INI_OPTS},)
		$$(call __exec, $${CD} $${__$(call uc,$1)_BIN_DIR} && \
			$${__ADD_MODELSIM_INI_OPTION_SCRIPT} $${__MODELSIM_INI_OPTS}, \
			$${__$(call uc,$1)_LOG}\
		)
	endif
	endif
	ifeq ($2,vcs_mx)
	ifneq ($${__SYNOPSYS_SIM_SETUP_OPTS},)
		$$(call __exec,$${CD} $${__$(call uc,$1)_BIN_DIR} && \
			$${__ADD_SYNOPSYS_SIM_SETUP_OPTION_SCRIPT} $${__SYNOPSYS_SIM_SETUP_OPTS}, \
			$${__$(call uc,$1)_LOG}\
		)
	endif
	endif
	$$(call __dummy, $$@, $${__$(call uc,$1)_LOG})
	$$(call __close_task,$${__$(call uc,$1)_INFO})

__$(call uc,$1)_UPDATE_MAP_FILE_TARGETS += $${__UPDATE_MAP_FILE_TARGET[$1][$2]}
__UPDATE_MAP_FILE_TARGET_DEFINED[$${__$(call uc,$1)_TOUCH_FILE_DIR}][$2] := ${true}

$${__$(call uc,$1)_BIN_DIR}/$${__MAP_FILE_NAME[$2]} : | $${__UPDATE_MAP_FILE_TARGET[$1][$2]}

endif 
endif 
endef


# $(call __make_cmd,<command>) 
define __make_cmd
$(__aacer_tr1)$1
endef


# $(call __dummy,<touch object>, <output redirection>) 
define __dummy
	${MKDIR} $(dir $1)
	@touch $1
endef

# $(call __mkdir, <dir>, <output redirection>)
define __mkdir
	$(__aacer_tr2)$(if $(wildcard $1),, \
		@ ${MKDIR} $1 $2; \
		__aacer_$0_status=$${PIPESTATUS[0]}; \
		if [ $$__aacer_$0_status != 0 ]; \
		then \
			$(call __task_fail); \
			exit $$__aacer_$0_status; \
		fi \
	)
endef

# (call __killer_mkdir, <dir>, <output redirection>)
define __killer_mkdir
$(__aacer_tr2)$(if $(wildcard $1),, 
@ ${MKDIR} $1 $2; \
__aacer_$0_status=$${PIPESTATUS[0]}; \
if [ $$__aacer_$0_status != 0 ]; \
then \
	$(call __task_fail); \
	kill -s QUIT $$PPID; \
fi \
)
endef

# $(call __assert_defined,<variable name>,<error msg>,<output redirection>)
define __assert_defined
$(__aacer_tr3)$(if ${$1},,@$(call __task_fail); echo $2 $3; exit 41)
endef

# $(call __escape_single_quoted,<string>)
define __escape_single_quoted
$(__aacer_tr1)$(subst ','"'"',$1)
endef

#'

# $(call __check_signature_exec,<file>,<signature>,<output redirection>)
define __check_signature_exec
$(__aacer_tr3)\
	$(call __quiet_exec, ${__CHECK_SIGNATURE_SCRIPT} $1 '$(call __escape_single_quoted,$2)',$3)
endef

# $(call __register_var,<var>,<init varlue>)
define __register_var
$(__aacer_tr2) $(eval $1 ?= $(subst $$,$$$$,$2)) $(eval __AACER_REPORT_VARS += $1)
endef

# $(call __register_opts_vars,<command>)
define __register_opts_vars
$(eval $1_OPTS ?= ) $(eval __$1_OPTS ?= ) $(eval __AACER_REPORT_VARS += $1_OPTS) $(eval __AACER_REPORT_VARS += $1_OPTS_)
endef

# $(call __query_version_info,<version variable>,<version origin variable>,<command>,<fail pattern>)
define __query_version_info
$(__aacer_tr4)$(eval __query_version_info_tmp_var := $(subst $$,$$$$,$(subst #,\#,$(shell $3 ${__AA_OPTS} ${AA_OPTS} ${AA_OPTS_} -query_info "%VERSION%;%VERSION_ORIGIN%")))) $(if $(findstring $4,${$1}),$(call __aacer_error,A tool version query for $3 produced an unexpected result: "${__query_version_info_tmp_var}",),$(eval __query_version_info_tmp_var := $(subst $$,$$$$,$(subst ;, ,${__query_version_info_tmp_var})))$(eval $1 := $(word 1,${__query_version_info_tmp_var}))$(eval $2 := $(subst $$,$$$$,$(word 2,${__query_version_info_tmp_var})$(if $(word 3,${__query_version_info_tmp_var}), $(word 3,${__query_version_info_tmp_var}),))))
endef

# $(call __which_and_check,<variable>,<executable>)
define __which_and_check
$(eval $1 := $(subst $$,$$$$,$(shell /bin/tcsh -cf 'which \$2')))
endef

# $(call __get_tool_cmd_with_aa_opts,<tool>)
define __get_tool_cmd_with_aa_opts
$(__aacer_tr1)${__$1_CMD} ${__AA_OPTS} ${AA_OPTS} ${AA_OPTS_} ${__$1_OPTS} ${$1_OPTS} ${$1_OPTS_} 
endef

# $(call __get_tool_cmd_with_opts,<tool>)
define __get_tool_cmd_with_opts
$(__aacer_tr1)${__$1_CMD} ${__$1_OPTS} ${$1_OPTS} ${$1_OPTS_} 
endef

# $(call __strip_trailing_slash,<string>)
define __strip_trailing_slash
$(__aacer_tr1)$(patsubst %/,%,$1)
endef

# $(call __dir,<path>)
define __dir
$(__aacer_tr1)$(call __strip_trailing_slash,$(dir $(call __strip_trailing_slash,$1)))
endef

# $(call __notdir,<path>)
define __notdir
$(__aacer_tr1)$(notdir $(call __strip_trailing_slash,$(call __strip_trailing_slash,$1)))
endef

# $(call __spec_abspath,<path>)
define __spec_abspath
$(__aacer_tr1)$(foreach __item,$1,$(if $(findstring :,${__item}),$(word 1,$(subst :,${} ${},${__item})):$(abspath $(word 2,$(subst :,${} ${},${__item}))),$(abspath ${__item})))
endef

endif ## __macro_mk_guard
