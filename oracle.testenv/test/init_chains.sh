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
import_key ${provider2222_prikey}
import_key ${provider3333_prikey}
import_key ${provider4444_prikey}
import_key ${provider5555_prikey}
import_key ${consumer1111_prikey}
import_key ${consumer2222_prikey}
import_key ${consumer3333_prikey}
import_key ${consumer4444_prikey}
import_key ${consumer5555_prikey}

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

new_account c1 ${contract_consumer_1}
new_account c1 ${contract_consumer_2}
new_account c1 ${contract_consumer_3}
new_account c1 ${contract_consumer_4}
new_account c1 ${contract_consumer_5}

# create_account_by_pub_key c1 ibc2relay555 EOS5jLHvXsFPvUAawjc6qodxUbkBjWcU1j6GUghsNvsGPRdFV5ZWi
# create_account_by_pub_key c2 ibc2relay555 EOS5jLHvXsFPvUAawjc6qodxUbkBjWcU1j6GUghsNvsGPRdFV5ZWi



create_account_by_pub_key c1 ${provider1111} ${provider1111_pubkey}
create_account_by_pub_key c1 ${provider2222} ${provider2222_pubkey}
create_account_by_pub_key c1 ${provider3333} ${provider3333_pubkey}
create_account_by_pub_key c1 ${provider4444} ${provider4444_pubkey}
create_account_by_pub_key c1 ${provider5555} ${provider5555_pubkey}
create_account_by_pub_key c1 ${consumer1111} ${consumer1111_pubkey}
create_account_by_pub_key c1 ${consumer2222} ${consumer2222_pubkey}
create_account_by_pub_key c1 ${consumer3333} ${consumer3333_pubkey}
create_account_by_pub_key c1 ${consumer4444} ${consumer4444_pubkey}
create_account_by_pub_key c1 ${consumer5555} ${consumer5555_pubkey}



create_arbi_test_account()
{

ACCOUNTS=(
    "complain1" "complain2" "complain3"  "arbitrator11" "arbitrator12" "arbitrator13" "arbitrator14" "arbitrator15"
)
for account in ${ACCOUNTS[*]}
do
    echo -e "\n creating $account \n"; 
    new_account c1 ${account}; 
    sleep 1; 
done

}
