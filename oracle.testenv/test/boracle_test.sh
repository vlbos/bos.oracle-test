#!/usr/bin/env bash

. env.sh
#. chains_init.sh

set_contracts() {
    cleos=cleos1 && if [ "$1" == "c2" ]; then cleos=cleos2; fi
    ${!cleos} set contract ${contract_oracle} ${CONTRACTS_DIR}/${contract_oracle_folder} -x 1000 -p ${contract_oracle}
    sleep .2

    ${!cleos} set contract ${contract_consumer} ${CONTRACTS_DIR}/${contract_consumer_folder} -x 1000 -p ${contract_consumer}@active
    sleep .2
}

test_set_contracts() {
    set_contracts c1
    # set_contracts c2
}

test_reg_service() {
    cleos=cleos1 && if [ "$1" == "c2" ]; then cleos=cleos2; fi
    ${!cleos} push action ${contract_oracle} regservice '{"service_id":0,  "account":"'${provider1111}'", "stake_amount":"10.0000 EOS", "service_price":"1.0000 EOS",
                          "fee_type":1, "data_format":"", "data_type":0, "criteria":"",
                          "acceptance":0, "declaration":"", "injection_method":0, "duration":1,
                          "provider_limit":3, "update_cycle":1, "update_start_time":"2019-07-29T15:27:33.216857+00:00"}' -p ${provider1111}@active

}

test_fee() {
    cleos=cleos1 && if [ "$1" == "c2" ]; then cleos=cleos2; fi

    ${!cleos} push action ${contract_oracle} addfeetypes '{"service_id":"0","fee_types":[0,1],"service_prices":["1.0000 EOS","2.0000 EOS"] }' -p ${contract_oracle}@active

}

test_subs() {
    cleos=cleos1 && if [ "$1" == "c2" ]; then cleos=cleos2; fi

    ${!cleos} push action ${contract_oracle} subscribe '{"service_id":"0", 
    "contract_account":"'${contract_consumer}'", "action_name":"receivejson", "publickey":"",
                          "account":"'${consumer1111}'", "amount":"10.0000 EOS", "memo":""}' -p ${consumer1111}@active
}

test_push() {
    cleos=cleos1 && if [ "$1" == "c2" ]; then cleos=cleos2; fi

    ${!cleos} push action ${contract_oracle} pushdata '{"service_id":0, "provider":"'${provider1111}'", "contract_account":"'${contract_consumer}'", "action_name":"receivejson",
                         "request_id":0, "data_json":"test data json"}' -p ${provider1111}

}

test_pushforreq() {
    cleos=cleos1 && if [ "$1" == "c2" ]; then cleos=cleos2; fi

    echo ===
    echo "$1"
    echo "$2"

    ${!cleos} push action ${contract_oracle} pushdata '{"service_id":0, "provider":"'${provider1111}'", "contract_account":"'${contract_consumer}'", "action_name":"receivejson",
                         "request_id":'"$2"', "data_json":"test data json"}' -p ${provider1111}

}

test_multipush() {
    cleos=cleos1 && if [ "$1" == "c2" ]; then cleos=cleos2; fi
    reqflag=false && if [ "$2" != "" ]; then reqflag="$2"; fi

    echo ===multipush
    # ${!cleos}  set account permission ${provider1111}  active '{"threshold": 1,"keys": [{"key": "'${provider1111_pubkey}'","weight": 1}],"accounts": [{"permission":{"actor":"'${contract_oracle}'","permission":"eosio.code"},"weight":1}]}' owner -p ${provider1111}@owner
     ${!cleos}  set account permission ${contract_oracle}  active '{"threshold": 1,"keys": [{"key": "'${oracle_c_pubkey}'","weight": 1}],"accounts": [{"permission":{"actor":"'${contract_oracle}'","permission":"eosio.code"},"weight":1}]}' owner -p ${contract_oracle}@owner

    # sleep .2
    ${!cleos} push action ${contract_oracle} multipush '{"service_id":0, "provider":"'${provider1111}'", 
                          "data_json":"test multipush data json","is_request":'${reqflag}'}' -p ${provider1111}
}

test_req() {
    cleos=cleos1 && if [ "$1" == "c2" ]; then cleos=cleos2; fi

    ${!cleos} push action ${contract_oracle} requestdata '{"service_id":0,  "contract_account":"'${contract_consumer}'", "action_name":"receivejson",
                         "requester":"'${consumer1111}'", "request_content":"eth usd"}' -p ${consumer1111}@active
}

test_deposit() {
    cleos=cleos1 && if [ "$1" == "c2" ]; then cleos=cleos2; fi

    ${!cleos} push action ${contract_oracle} deposit '{"service_id":0,  "from":"oraclize1111", "to":"'${consumer1111}'",
                         "quantity":"10.0000 EOS", "memo":"","is_notify":false}' -p ${contract_oracle}@active
}

test_withdraw() {
    cleos=cleos1 && if [ "$1" == "c2" ]; then cleos=cleos2; fi

    ${!cleos} push action ${contract_oracle} withdraw '{"service_id":0,  "from":"'${consumer1111}'", "to":"oraclize1111",
                         "quantity":"1.0000 EOS", "memo":""}' -p ${contract_oracle}@active
}

test_() {
    cleos=cleos1 && if [ "$1" == "c2" ]; then cleos=cleos2; fi

    ${!cleos} push action ${contract_oracle} requestdata '{"service_id":"0",  "contract_account":"", "action_name":"",
                         "account":"", "request_content":""}' -p ${contract_consumer}@active
}

test_init_contracts() {
    case "$1" in
    "reg") test_reg_service c1 ;;
    "fee") test_fee c1 ;;
    "subs") test_subs c1 ;;
    "mpush") test_multipush c1 "$2" ;;
    "push") test_push c1 ;;
    "pushr") test_pushforreq c1 "$2" ;;
    "req") test_req c1 ;;
    "deposit") test_deposit c1 ;;
    "withdraw") test_withdraw c1 ;;
    *) echo "usage: init reg|fee|subs|pushr {reqid}|mpush {false|true|}|req|deposit|withdraw" ;;
    esac

    # init_contracts c2
}

get_account() {
    echo --- cleos1 --- $1
    $cleos1 get account $1
    # echo && echo --- cleos2 ---  $1
    # $cleos2 get account  $1
}
test_get_account() {
    get_account oraclize1111
    get_account bosbosoracle
    get_account ${contract_oracle}
}

transfer() {
    echo --- cleos2 transfer ---
    $cleos1 transfer ${contract_consumer} ${contract_oracle} "10.0000 EOS" -p ${contract_consumer}
    # $cleos2 transfer  testblklist1 testblklist2 "10.0000 BOS" "ibc receiver=chengsong111" -p testblklist1
}

# test_transfer()
# {}

pwd = 'cat /Users/lisheng/eosio-wallet/password.txt'

test_list_pri_key() {
    cleos=cleos1 && if [ "$1" == "c2" ]; then cleos=cleos2; fi
    ${!cleos} wallet private_keys --password PW5JhG3FdGXSc2RTXRNC2tDrd4KhudMA1BggF9QvxJ6YUL4ktUh4k
}

get_oracle_table() {
    cleos=cleos1 && if [ "$1" == "c2" ]; then cleos=cleos2; fi
    echo ==dataservices
    ${!cleos} get table ${contract_oracle} ${contract_oracle} $2 --limit 10

}
get_oracle_table1() {
    cleos=cleos1 && if [ "$1" == "c2" ]; then cleos=cleos2; fi

    ${!cleos} get table ${contract_oracle} $2 $3 --limit 10

}

test_get_table() {
    get_oracle_table c1 $1
}

test_get_table1() {
    get_oracle_table c1 $1 $2
}

get_info() {
    cleos=cleos1 && if [ "$1" == "c2" ]; then cleos=cleos2; fi

    #cleos get table ${contract_token} ${contract_token} globals
    ${!cleos} get info

}
get_scope() {
    cleos=cleos1 && if [ "$1" == "c2" ]; then cleos=cleos2; fi

    #cleos get table ${contract_token} ${contract_token} globals
    ${!cleos} get scope -t stat eosio.token

}

test_get_scope() {
    get_scope c1
}

test_get_info() {
    get_info c1
}

case "$1" in

"set") test_set_contracts ;;
"init") test_init_contracts "$2" "$3" ;;
"acc") test_get_account ;;
"transfer") test_transfer ;;
"keys") test_list_pri_key ;;
"table") test_get_table "$2" ;;
"table1") test_get_table1 "$2" "$3" ;;
"info") test_get_info ;;
"scope") test_get_scope ;;
*) echo "usage: oracle_test.sh set|init {param1 param2}|acc|transfer|keys|table {name}|table1 {scope name}|info" ;;
esac

# dataservices
# servicefees
# providers
# provservices
# svcprovision
# cancelapplys

# pushrecords
# ppushrecords
# apushrecords
# papushrecord

# provisionlog
