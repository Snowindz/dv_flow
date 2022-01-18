#!/bin/sh

__LC_DBG=
#__LC_DBG="echo"
script_name=./fmtMake

orgDir=./flows.org; orgVars=(QBAR QVMR QC_OPTS QBLD QAFENE);

# orgDir -> fm0Dir
enFmt0=0; fm0Dir=./flows.fmt0; 
enFmt1=0; fm1Dir=./flows.fmt1; new1Vars=(AACER AARGR AA_OPTS AABLD AAFENE);
enFmt2=0; fm2Dir=./flows.fmt2; new2Vars=(XXCER XXRGR XX_OPTS XXBLD XXFENE);

function backup_copy_dirs {
  src_dir=$1
  tgt_dir=$2

  echo "#--SINFO: begin to copy $src_dir to $tgt_dir ..."

  if [ ! -d $src_dir ]; then
    echo "**ERROR: src_dir:$src_dir not exist!"
    exit 1
  fi

  # back-up 3 times
  [ -d $tgtDir.bak2 ] && rm -rf $tgtDir.bak2
  [ -d $tgtDir.bak1 ] && mv $tgtDir.bak1 $tgtDir.bak2
  [ -d $tgtDir.bak0 ] && mv $tgtDir.bak0 $tgtDir.bak1
  [ -d $tgt_dir ]      && mv $tgt_dir      $tgtDir.bak0

  cp -rf $src_dir $tgt_dir
}


if [ $enFmt0 -eq 1 ]; then
  srcDir=$orgDir;
  tgtDir=$fm0Dir;
  backup_copy_dirs $srcDir $tgtDir;
  if [ $? -gt 0 ]; then
    echo "**ERROR: backup_copy_dirs $srcDir $tgtDir failed!"
    exit 1
  fi
  files="$tgtDir/*.*"

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
fi

if [ $enFmt1 -eq 1 ]; then
  srcDir=$fm0Dir;
  tgtDir=$fm1Dir;
  backup_copy_dirs $srcDir $tgtDir;
  if [ $? -gt 0 ]; then
    echo "**ERROR: backup_copy_dirs $srcDir $tgtDir failed!"
    exit 1
  fi
  files="$tgtDir/*.*"

  i=0
  while [ $i -lt ${#orgVars[*]} ]; do
    org_var_u=${orgVars[$i]}
    new_var_u=${new1Vars[$i]}
    org_var_l=`echo ${orgVars[$i]} | tr 'A-Z' 'a-z'`
    new_var_l=`echo ${new1Vars[$i]} | tr 'A-Z' 'a-z'`

    echo "            fmt1: i=$i, org_var:$org_var_u; new_var:$new_var_u;"

    ${__LC_DBG} sed -i \
      -e "s/$org_var_u/$new_var_u/g" \
      -e "s/$org_var_l/$new_var_l/g" \
      $files

    i=`expr $i + 1`
  done
fi

if [ $enFmt2 -eq 1 ]; then
  srcDir=$fm1Dir;
  tgtDir=$fm2Dir;
  backup_copy_dirs $srcDir $tgtDir;
  if [ $? -gt 0 ]; then
    echo "**ERROR: backup_copy_dirs $srcDir $tgtDir failed!"
    exit 1
  fi
  files="$tgtDir/*.*"

  i=0
  while [ $i -lt ${#new1Vars[*]} ]; do
    org_var_u=${new1Vars[$i]}
    new_var_u=${new2Vars[$i]}
    org_var_l=`echo ${new1Vars[$i]} | tr 'A-Z' 'a-z'`
    new_var_l=`echo ${new2Vars[$i]} | tr 'A-Z' 'a-z'`

    echo "            fmt2: i=$i, org_var:$org_var_u; new_var:$new_var_u;"

    ${__LC_DBG} sed -i \
      -e "s/$org_var_u/$new_var_u/g" \
      -e "s/$org_var_l/$new_var_l/g" \
      $files

    i=`expr $i + 1`
  done
fi
