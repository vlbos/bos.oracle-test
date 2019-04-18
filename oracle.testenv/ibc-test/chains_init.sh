#!/usr/bin/env bash

. init_system_contracts.sh

receiver=111111111111

create_one c1 ${receiver}
# create_one c2 ${receiver}


contract_oracle=bosbosoracle

contract_oraclize=oraclebosbos


contract_oraclized=oracle444444


token_c_pubkey=EOS6Sc4BuA7dEGRU6u4VSuEKusESFe61qD8LmguGEMULrghKDSPaU
token_c_prikey=5K79wAY8rgPwWQSRmyQa2BR8vPicieJdLCXL3cM5Db77QnsJess
import_key ${token_c_prikey}

new_account(){
    cleos=cleos1 && if [ "$1" == "c2" ];then cleos=cleos2 ;fi
    create_one $1 $2
}

new_account c1 ${contract_oraclized}

new_account c1 ${contract_oracle}
# create_account_by_pub_key c1 ${contract_oraclized} EOS5jLHvXsFPvUAawjc6qodxUbkBjWcU1j6GUghsNvsGPRdFV5ZWi

new_account c1 ${contract_oraclize}
# create_account_by_pub_key c2 ${contract_token} ${token_c_pubkey}



new_account c1 oracleoracle

new_account c1 oracle111111
# new_account c2 testblklist1

new_account c1 oracle222222
# new_account c2 testblklist2

new_account c1 oracle333333
# new_account c2 testblklist3


# create_account_by_pub_key c1 ibc2relay555 EOS5jLHvXsFPvUAawjc6qodxUbkBjWcU1j6GUghsNvsGPRdFV5ZWi
# create_account_by_pub_key c2 ibc2relay555 EOS5jLHvXsFPvUAawjc6qodxUbkBjWcU1j6GUghsNvsGPRdFV5ZWi







