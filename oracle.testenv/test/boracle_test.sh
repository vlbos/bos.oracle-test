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

test_publish() {

    test_reg_service5
    provider_transfer5
    test_fee
    test_subs5
    consumer_transfer5
    test_autopublish
}

provider_transfer5() {
    echo --- cleos1 provider transfer ---
    ${!cleos} set account permission ${contract_oracle} active '{"threshold": 1,"keys": [{"key": "'${oracle_c_pubkey}'","weight": 1}],"accounts": [{"permission":{"actor":"'${contract_oracle}'","permission":"eosio.code"},"weight":1}]}' owner -p ${contract_oracle}@owner

    for i in {1..5}; do
        p='provider'${i}${i}${i}${i}
        $cleos1 transfer ${p} ${contract_oracle} "10.0001 EOS" "0,1" -p ${p}
        sleep .1
    done
}

consumer_transfer5() {
    echo --- cleos1 consumer transfer  ---
    ${!cleos} set account permission ${contract_oracle} active '{"threshold": 1,"keys": [{"key": "'${oracle_c_pubkey}'","weight": 1}],"accounts": [{"permission":{"actor":"'${contract_oracle}'","permission":"eosio.code"},"weight":1}]}' owner -p ${contract_oracle}@owner

    for i in {1..5}; do
        c='consumercon'${i}
        $cleos1 transfer ${c} ${contract_oracle} "10.0001 EOS" "1,1" -p ${c}
        sleep .1
    done
    
}

test_reg_service5() {
    echo ==reg 5
    cleos=cleos1 && if [ "$1" == "c2" ]; then cleos=cleos2; fi
    ${!cleos} push action ${contract_oracle} regservice '{"service_id":0,  "account":"'${provider1111}'", "stake_amount":"10.0000 EOS", "service_price":"1.0000 EOS",
                          "fee_type":1, "data_format":"", "data_type":0, "criteria":"",
                          "acceptance":0, "declaration":"", "injection_method":0, "duration":10,
                          "provider_limit":3, "update_cycle":60, "update_start_time":"2019-07-29T15:27:33.216857+00:00"}' -p ${provider1111}@active

    for i in {2..5}; do
        p='provider'${i}${i}${i}${i}
        ${!cleos} push action ${contract_oracle} regservice '{"service_id":1,  "account":"'${p}'", "stake_amount":"10.0000 EOS", "service_price":"1.0000 EOS",
                          "fee_type":1, "data_format":"", "data_type":0, "criteria":"",
                          "acceptance":0, "declaration":"", "injection_method":0, "duration":20,
                          "provider_limit":3, "update_cycle":120, "update_start_time":"2019-07-29T15:27:33.216857+00:00"}' -p ${p}@active

        sleep .1
    done
}

test_subs5() {
    echo ===subs5
    cleos=cleos1 && if [ "$1" == "c2" ]; then cleos=cleos2; fi
    for i in {1..5}; do
        c='consumer'${i}${i}${i}${i}
        ${!cleos} push action ${contract_oracle} subscribe '{"service_id":"1", 
    "contract_account":"consumercon'${i}'", "action_name":"receivejson", "publickey":"",
                          "account":"'${c}'", "amount":"10.0000 EOS", "memo":""}' -p ${c}@active

        sleep .1
    done
}

test_autopublish() {
    echo ==autopush
    cleos=cleos1 && if [ "$1" == "c2" ]; then cleos=cleos2; fi
    ${!cleos} set account permission ${contract_oracle} active '{"threshold": 1,"keys": [{"key": "'${oracle_c_pubkey}'","weight": 1}],"accounts": [{"permission":{"actor":"'${contract_oracle}'","permission":"eosio.code"},"weight":1}]}' owner -p ${contract_oracle}@owner

    for i in {1..5}; do
        p='provider'${i}${i}${i}${i}
        ${!cleos} push action ${contract_oracle} autopublish '{"service_id":1, "provider":"'${p}'", 
                         "request_id":0, "data_json":"auto publish test data json"}' -p ${p}
        sleep 2
    done
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
    ${!cleos} set account permission ${contract_oracle} active '{"threshold": 1,"keys": [{"key": "'${oracle_c_pubkey}'","weight": 1}],"accounts": [{"permission":{"actor":"'${contract_oracle}'","permission":"eosio.code"},"weight":1}]}' owner -p ${contract_oracle}@owner

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
    get_account "$1"
    # get_account oraclize1111
    # get_account bosbosoracle
    # get_account ${contract_oracle}
}

transfer() {
    echo --- cleos1 transfer ---
    $cleos1 transfer ${provider1111} ${contract_oracle} "0.0001 EOS" "0,0" -p ${provider1111}
    $cleos1 transfer ${consumer2222} ${contract_oracle} "0.0001 EOS" "1,0" -p ${consumer2222}
    $cleos1 transfer ${consumer2222} ${contract_oracle} "0.0001 EOS" "2,consumer2222,consumer1111,0" -p ${consumer2222}
    $cleos1 transfer ${consumer2222} ${contract_oracle} "0.0001 EOS" "3,0" -p ${consumer2222}

    # $cleos2 transfer  testblklist1 testblklist2 "10.0000 BOS" "ibc receiver=chengsong111" -p testblklist1
    #
}
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
transfer0() {
    echo --- providers before transfer ---
    test_get_table providers
    echo --- svcprovision before transfer ---
    test_get_table1 0 svcprovision
    echo --- servicestake before transfer ---
    test_get_table servicestake
    echo --- cleos1 transfer service stake---
    $cleos1 transfer ${provider1111} ${contract_oracle} "0.0001 EOS" "0,0" -p ${provider1111}
    echo --- providers after transfer ---
    test_get_table providers
    echo --- svcprovision after transfer ---
    test_get_table1 0 svcprovision
    echo --- servicestake after transfer ---
    test_get_table servicestake
}

transfer1() {
    echo --- cleos1 subscription before transfer ---
    test_get_table1 0 subscription
    echo --- cleos1 pay service before transfer ---
    $cleos1 transfer ${contract_consumer} ${contract_oracle} "0.0001 EOS" "1,0" -p ${contract_consumer}
    echo --- cleos1 subscription after transfer ---
    test_get_table1 0 subscription
}

transfer2() {
    echo --- riskaccounts before transfer 2---
    test_get_table1 consumer1111 riskaccounts
    echo --- deposit transfer 2---
    $cleos1 transfer ${consumer2222} ${contract_oracle} "0.0001 EOS" "2,consumer2222,consumer1111,0" -p ${consumer2222}
    echo --- riskaccounts after transfer 2---
    test_get_table1 consumer1111 riskaccounts
}
transfer3() {
    echo --- cleos1 transfer 3---

    $cleos1 transfer ${consumer2222} ${contract_oracle} "0.0001 EOS" "3,0" -p ${consumer2222}
}

test_transfer() {
    #  transfer
    case "$1" in
    "stake") transfer0 ;;
    "pay") transfer1 ;;
    "deposit") transfer2 ;;
    "arbi") transfer3 ;;
    *) echo "usage: transfer stake|pay|deposit|arbi" ;;
    esac
}

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
    get_oracle_table1 c1 $1 $2
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

test_fetchdata() {
    cleos=cleos1 && if [ "$1" == "c2" ]; then cleos=cleos2; fi

    ${!cleos} push action ${contract_consumer} fetchdata '{"service_id":1, "update_number":0}' -p ${contract_consumer}

}

case "$1" in

"set") test_set_contracts ;;
"init") test_init_contracts "$2" "$3" ;;
"acc") test_get_account "$2" ;;
"transfer") test_transfer "$2" ;;
"keys") test_list_pri_key ;;
"table") test_get_table "$2" ;;
"table1") test_get_table1 "$2" "$3" ;;
"info") test_get_info ;;
"scope") test_get_scope ;;
"data") test_fetchdata ;;
"pub") test_publish ;;
"auto") test_autopublish ;;
*) echo "usage: oracle_test.sh set|init {reg|fee|subs|pushr {reqid}|mpush {false|true|}|req|deposit|withdraw}|acc|transfer {stake|pay|deposit|arbi}|keys|table {name}|table1 {scope name}|info|scope|data|pub" ;;
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
