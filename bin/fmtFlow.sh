#!/bin/sh
#######################################################################
#(c) Copyright 2022 TBD, All rights reserved.
#
# This file and associated deliverables are the trade secrets,
# confidential information and copyrighted works of TBD Co., Ltd.
# and are subject to your license agreement with TBD.
#
# Use of these deliverables for the purpose of making silicon from an IC
# design is limited to the terms and conditions of your license agreement
# with TBD If you have further questions please contact TBD.
#------------------------------------------------------------------------
# File       :  fmtMake.sh
# Project    :  
# Module     :  fmtMake
# Author     :  Lichao Zhang 
# Created on :  2022/1/14 18:58:43 
# Description:  
#
# Revision   :  $Revision:$
# Checked In :  $DateTime:$
# Modified by:  $Author:$
# Change     :  $Change:$
#
# $Id:$
######################################################################


__LC_DBG=
#__LC_DBG="echo"

orgDir=./flows.org
fmtDir=./flows.fmt1
fmtDir2=./flows.fmt2
mrgFile=./flows.mrg.txt
enFmt=1
enFmt2=0
enMrg=1

orgVars=(QBAR QVMR QC_OPTS QBLD QAFENE)
newVars=(AACER AARGR AA_OPTS AABLD AAFENE)
newVars1=(XXCER XXRGR XX_OPTS XXBLD XXFENE)

#echo "--SDBG: orgVars len=${#orgVars}, ${orgVars}"
#echo "--SDBG: newVars len=${#newVars}"
#echo "--SDBG: newVars1 len=${#newVars}"

if [ $enFmt -eq 1 ]; then
	echo "--SINFO: begin to format ..."

	[ -d $fmtDir.bak2 ] && rm -rf $fmtDir.bak2
	[ -d $fmtDir.bak1 ] && mv $fmtDir.bak1 $fmtDir.bak2
	[ -d $fmtDir.bak0 ] && mv $fmtDir.bak0 $fmtDir.bak1
	[ -d $fmtDir ] 		&& mv $fmtDir 	   $fmtDir.bak0
	cp -rf $orgDir $fmtDir
	files="$fmtDir/*.*"

	# pre-proc
	# ${__LC_DBG} sed -i \
	# -e 's#/pkg/qct/software/python/3.4.0/bin/python#${__PYTHON}#g' \
	# -e 's#/pkg/qct/software/perl/q3_10/bin/perl#${__PYTHON}#g' \
	# -e 's#${PYTHON}#${__PYTHON}#g' \
	# $files


	# #ifdef #else
	${__LC_DBG} sed -i \
		-e 's/^\s*#\(if.*\)/__\1/g'  \
		-e 's/^\s*#\(els.*\)/__\1/g' \
		-e 's/^\s*#\(end.*\)/__\1/g' \
		$files

	# rmv blank
	${__LC_DBG} sed -i -e "/^#.*$/d; /^\s\+$/d; /^$/d" $files

	# rvt back ifdef/else...
	${__LC_DBG} sed -i \
		-e 's/^__\(if.*\)/#\1/g'  \
		-e 's/^__\(els.*\)/#\1/g' \
		-e 's/^__\(end.*\)/#\1/g' \
	$files


	i=0
	while [ $i -le ${#orgVars} ]; do
		echo "--SINFO: i=$i"
		org_var_u=${orgVars[$i]}
		new_var_u=${newVars[$i]}
		org_var_l=`echo ${orgVars[$i]} | tr 'A-Z' 'a-z'`
		new_var_l=`echo ${newVars[$i]} | tr 'A-Z' 'a-z'`

		#echo "s/$org_var_u/$new_var_u/g" $files
		#echo "s/$org_var_l/$new_var_l/g" $files

		${__LC_DBG} sed -i \
			-e "s/$org_var_u/$new_var_u/g" \
			-e "s/$org_var_l/$new_var_l/g" \
			$files

		i=`expr $i + 1`
	done

fi


if [ $enFmt2 -eq 1 ]; then
	echo "--SINFO: begin to format 2, ..."
	[ -d $fmtDir2.bak1 ] && mv $fmtDir2.bak1 $fmtDir2.bak2
	[ -d $fmtDir2.bak0 ] && mv $fmtDir2.bak0 $fmtDir2.bak1
	[ -d $fmtDir2 ] 		&& mv $fmtDir2 		$fmtDir2.bak0

	cp -rf $fmtDir $fmtDir2
	files="$fmtDir2/*.*"
	echo "--SDBG: newVars len=${#newVars}"
	i=0
	while [ $i -lt ${#newVars} ]; do
		echo "--SINFO: i=$i"
		org_var_u=${newVars[$i]}
		new_var_u=${newVars1[$i]}
		org_var_l=`echo ${newVars[$i]} | tr 'A-Z' 'a-z'`
		new_var_l=`echo ${newVars1[$i]} | tr 'A-Z' 'a-z'`

		#echo "s/$org_var_u/$new_var_u/g" $files
		#echo "s/$org_var_l/$new_var_l/g" $files

		${__LC_DBG} sed -i \
			-e "s/$org_var_u/$new_var_u/g" \
			-e "s/$org_var_l/$new_var_l/g" \
			$files

		i=`expr $i + 1`
	done

fi


if [ $enMrg -eq 1 ]; then
	echo "--SINFO: begin to merge $fmtDir "
	files="$fmtDir/*.* ./fmtMake"
	[ -e $mrgFile ] && rm -f $mrgFile
	mkdir -p `dirname $mrgFile`
	touch $mrgFile
	for file in $files; do
		fname=`basename $file`
		echo "--File: $fname"
		echo "#__FILE_: $fname {{{1" >> $mrgFile
		cat $file >> $mrgFile
		echo "#__FILE_: $fname 1}}}" >> $mrgFile
	done
fi


