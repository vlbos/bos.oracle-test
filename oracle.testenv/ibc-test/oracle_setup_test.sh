#!/usr/bin/env bash

. env.sh
#. chains_init.sh


set_contracts(){
    cleos=cleos1 && if [ "$1" == "c2" ];then cleos=cleos2 ;fi
    ${!cleos} set contract ${contract_oracle} ${CONTRACTS_DIR}/${contract_oracle_folder} -x 1000 -p ${contract_oracle}
    sleep .2
    ${!cleos} set contract ${contract_oraclize} ${CONTRACTS_DIR}/${contract_oraclize_folder} -x 1000 -p ${contract_oraclize}
    sleep .2
    ${!cleos}  set contract ${contract_oraclized} ${CONTRACTS_DIR}/${contract_oraclized_folder} -x 1000 -p ${contract_oraclized}@active
    sleep .2
}
set_contracts c1
# set_contracts c2
