#!/usr/bin/env bash

. init_system_contracts.sh
. env.sh

receiver=111111111111

create_one c1 ${receiver}
# create_one c2 ${receiver}


import_key ${oraclize_c_prikey}

import_key ${consumer_c_prikey}

import_key ${oracle_c_prikey}

import_key ${oracleoracle_c_prikey}

import_key ${provider1111_prikey}
echo import_key ${provider1112_prikey}
import_key ${provider1112_prikey}
echo import_key ${provider1112_prikey} end
import_key ${consumer1111_prikey}
import_key ${consumer1112_prikey}

new_account(){
    cleos=cleos1 && if [ "$1" == "c2" ];then cleos=cleos2 ;fi
    create_one $1 $2
}

# new_account c1 ${contract_consumer}

# new_account c1 ${contract_oracle}
#  create_account_by_pub_key c1 ${contract_consumer} EOS5jLHvXsFPvUAawjc6qodxUbkBjWcU1j6GUghsNvsGPRdFV5ZWi

# new_account c1 ${contract_oracle}
# create_account_by_pub_key c1 ${contract_oraclize} ${oraclize_c_pubkey}
create_account_by_pub_key c1 ${contract_consumer} ${consumer_c_pubkey}
create_account_by_pub_key c1 ${contract_oracle} ${oracle_c_pubkey}

create_account_by_pub_key c1 oracleoracle ${oracleoracle_c_pubkey}


# new_account c1 oracleoracle

new_account c1 oraclize1111
# new_account c2 testblklist1

new_account c1 oracle222222
# new_account c2 testblklist2

new_account c1 oracle333333
# new_account c2 testblklist3


# create_account_by_pub_key c1 ibc2relay555 EOS5jLHvXsFPvUAawjc6qodxUbkBjWcU1j6GUghsNvsGPRdFV5ZWi
# create_account_by_pub_key c2 ibc2relay555 EOS5jLHvXsFPvUAawjc6qodxUbkBjWcU1j6GUghsNvsGPRdFV5ZWi



create_account_by_pub_key c1 ${provider1111} ${provider1111_pubkey}
create_account_by_pub_key c1 ${provider1112} ${provider1112_pubkey}
create_account_by_pub_key c1 ${consumer1111} ${consumer1111_pubkey}
create_account_by_pub_key c1 ${consumer1112} ${consumer1112_pubkey}

