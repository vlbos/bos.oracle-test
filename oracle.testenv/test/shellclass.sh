#!/bin/bash
 
# -------------------------------------------------------------------
# OO support functions
# Kludged by Pim van Riezen <pi@madscience.nl>
# -------------------------------------------------------------------
DEFCLASS=""
CLASS=""
THIS=0
 
class() {
  DEFCLASS="$1"
  eval CLASS_${DEFCLASS}_VARS=""
  eval CLASS_${DEFCLASS}_FUNCTIONS=""
}
 
static() {
  return 0
}
 
func() {
  local varname="CLASS_${DEFCLASS}_FUNCTIONS"
  eval "$varname=\"\${$varname}$1 \""
}
 
var() {
  local varname="CLASS_${DEFCLASS}_VARS"
  eval $varname="\"\${$varname}$1 \""
}
 
loadvar() {
  eval "varlist=\"\$CLASS_${CLASS}_VARS\""
  for var in $varlist; do
    eval "$var=\"\$INSTANCE_${THIS}_$var\""
  done
}
 
loadfunc() {
  eval "funclist=\"\$CLASS_${CLASS}_FUNCTIONS\""
  for func in $funclist; do
    eval "${func}() { ${CLASS}::${func} \"\$*\"; return \$?; }"
  done
}
 
savevar() {
  eval "varlist=\"\$CLASS_${CLASS}_VARS\""
  for var in $varlist; do
    eval "INSTANCE_${THIS}_$var=\"\$$var\""
  done
}
 
typeof() {
  eval echo \$TYPEOF_$1
}
 
new() {
  local class="$1"
  local cvar="$2"
  shift
  shift
  local id=$(uuidgen | tr A-F a-f | sed -e "s/-//g")
  eval TYPEOF_${id}=$class
  eval $cvar=$id
  local funclist
  eval "funclist=\"\$CLASS_${class}_FUNCTIONS\""
  for func in $funclist; do
    eval "${cvar}.${func}() {
      local t=\$THIS; THIS=$id; local c=\$CLASS; CLASS=$class; loadvar;
      loadfunc; ${class}::${func} \"\$*\"; rt=\$?; savevar; CLASS=\$c;
      THIS=\$t; return $rt;
    }"
 
  done
  eval "${cvar}.${class} \"\$*\" || true"
}

# 代码阅读提示：

# 我们可以看到，下面的这个脚本定义了class,  func, var, new 等函数，其实这些就是所谓的关键字。
# class是一个函数，主要是记录类名。
# func和var实际上是把成员函数名和成员变量记成有相同前缀的各种变量。
# new方法主要是记录实例。大家重点看看new函数里的那个for循环，最核心的就在那里了。
# 需要修改的原因

# $*，保存了以$IFS指定的分割符所分割的字符串组。
# $@，原样保存了参数列表，也就是"$1""$2"...
# shell调式的时候，用

# -n
# 读一遍脚本中的命令但不执行，用于检查脚本中的语法错误

# -v
# 一边执行脚本，一边将执行过的脚本命令打印到标准错误输出

# -x
# 提供跟踪执行信息，将执行的每一条命令和结果依次打印出来

# DEFCLASS=""
# CLASS=""
# THIS=0

# class() {
#     DEFCLASS="$1"
#     eval CLASS_${DEFCLASS}_VARS=""
#     eval CLASS_${DEFCLASS}_FUNCTIONS=""
# }

# static() {
#       return 0
# }

# func() {
#     local varname="CLASS_${DEFCLASS}_FUNCTIONS"
#     eval "$varname=\"\${$varname}$1 \""
# }

# var() {
#     local varname="CLASS_${DEFCLASS}_VARS"
#     eval $varname="\"\${$varname}$1 \""
# }

# loadvar() {
#     eval "varlist=\"\$CLASS_${CLASS}_VARS\""
#     for var in $varlist; do
#         eval "$var=\"\$INSTANCE_${THIS}_$var\""
#     done
# }
# loadfunc() {
#     eval "funclist=\"\$CLASS_${CLASS}_FUNCTIONS\""
#     for func in $funclist; do
#         eval "${func}() { ${CLASS}::${func} \"\$@\"; return \$?; }"
#     done
# }

# savevar() {
#     eval "varlist=\"\$CLASS_${CLASS}_VARS\""
#     for var in $varlist; do
#         eval "INSTANCE_${THIS}_$var=\"\$$var\""
#     done
# }

# typeof() {
#     eval echo \$TYPEOF_$1
# }

# new() {
#     local class="$1"
#     local cvar="$2"
#     shift
#     shift
#     local id=$(uuidgen | tr A-F a-f | sed -e "s/-//g")
#     eval TYPEOF_${id}=$class
#     eval $cvar=$id
#     local funclist
#     eval "funclist=\"\$CLASS_${class}_FUNCTIONS\""
#     for func in $funclist; do
#         eval "${cvar}.${func}() { local t=\$THIS; THIS=$id; local c=\$CLASS; CLASS=$class; loadvar; loadfunc; ${class}::${func} \"\$@\"; rt=\$?; savevar; CLASS=\$c; THIS=\$t; return $rt; }"
#     done
#     eval "${cvar}.${class} \"\$@\" || true"
# }
