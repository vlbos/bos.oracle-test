#!/usr/bin/env bash

. env.sh
#. chains_init.sh


get_account(){
    echo --- cleos1 ---  $1
    $cleos1 get account  $1
    # echo && echo --- cleos2 ---  $1
    # $cleos2 get account  $1
}
get_account oraclebosbos
echo == oracle4444444
get_account oracle444444
