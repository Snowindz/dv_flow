true	= T
false 	=
SHELL	:= /bin/bash -x
MKDIR	:= mkdir -p
CD	:= cd
MV	:= /usr/bin/env mv
RM	:= /usr/bin/env rm -rf
TOUCH	:= /usr/bin/env touch

# TBD, need add the path in env.
__PERL		= /TBD/q3_10/bin/perl
__PYTHON 	= /TBD/python/3.4.0/bin/python

ifdef GMSL_TRACE
__gmsl_tr1 = $(warning $0('$1'))
__gmsl_tr2 = $(warning $0('$1','$2'))
__gmsl_tr3 = $(warning $0('$1','$2','$3'))
else
__gmsl_tr1 :=
__gmsl_tr2 :=
__gmsl_tr3 :=
endif

# Function: seq <a str to compare w/> <this str>
# Return: return $(true) if two strs are identical
seq = $(__gmsl_tr2)$(if $(subst x$1,,x$2)$(subst x$2,,x$1),$(false),$(true))

uc = $(shell echo $1 | tr a-z A-Z)
lc = $(shell echo $1 | tr A-Z a-z)

# Function: uniq <list to be remove duplications>
# Return: list which rmv the duplications
uniq = $(strip $(__gmsl_tr1) $(if $1,$(firstword $1) \
       $(call uniq,$(filter-out $(firstword $1),$1))))

