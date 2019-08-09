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
    test_get_table1 1 oracledata
    test_fetchdatawithp c1 $current_update_number
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
    echo --- cleos1 consumer transfer ---
    ${!cleos} set account permission ${contract_oracle} active '{"threshold": 1,"keys": [{"key": "'${oracle_c_pubkey}'","weight": 1}],"accounts": [{"permission":{"actor":"'${contract_oracle}'","permission":"eosio.code"},"weight":1}]}' owner -p ${contract_oracle}@owner

    for i in {1..5}; do
        c='consumercon'${i}
        $cleos1 transfer ${c} ${contract_oracle} "10.0001 EOS" "1,1" -p ${c}
        sleep .1
    done

}

service_duration=200
update_cycle=300


current_update_number=0
datetime1=$(date "+%s#%N")
datetime2=$(echo $datetime1 | cut -d"#" -f1) #取出秒

get_current_date() {
    datetime1=$(date "+%s#%N")
    datetime2=$(echo $datetime1 | cut -d"#" -f1) #取出秒
}

waitnext() {
    get_current_date
    i=$(($datetime2))
    while [ $i -le $1 ]; do
        get_current_date
        i=$datetime2
        sleep 10
    done
}

get_update_number() {
    a=$1
    b=$2
    if [ $a -eq 0 ]; then return 0; fi
    if [ $b -eq 0 ]; then return 0; fi

    get_current_date

    current_update_number=$(($datetime2 / $a))
    begin_time=$(($current_update_number * $a))
    end_time=$(($begin_time + $b))
    # if [ 0 -le  $1 ]; then return 0; fi
    if [ $datetime2 -le $end_time ]; then return $current_update_number; fi
    next_begin_time=$(($begin_time + $a))
    waitnext $next_begin_time
    get_update_number $a $b

}


test_reg_service5() {
    echo ==reg 5
    cleos=cleos1 && if [ "$1" == "c2" ]; then cleos=cleos2; fi
    ${!cleos} push action ${contract_oracle} regservice '{"service_id":0,  "account":"'${provider1111}'", "amount":"10.0000 EOS", "service_price":"1.0000 EOS",
                          "fee_type":1, "data_format":"", "data_type":0, "criteria":"",
                          "acceptance":0, "declaration":"", "injection_method":0, "duration":'${service_duration}',
                          "provider_limit":3, "update_cycle":'${update_cycle}', "update_start_time":"2019-07-29T15:27:33.216857+00:00"}' -p ${provider1111}@active

    for i in {2..5}; do
        p='provider'${i}${i}${i}${i}
        ${!cleos} push action ${contract_oracle} regservice '{"service_id":1,  "account":"'${p}'", "amount":"10.0000 EOS", "service_price":"1.0000 EOS",
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

    get_update_number $update_cycle $service_duration

    if [ $current_update_number -ne 0 ]; then

        for i in {1..5}; do
            p='provider'${i}${i}${i}${i}
            ${!cleos} push action ${contract_oracle} autopublish '{"service_id":1, "provider":"'${p}'", "update_number":"'${un}'", 
                         "request_id":0, "data_json":"auto publish test data json"}' -p ${p}
            sleep 2
        done
    else
        echo current update number equal zero
    fi
}

test_reg_service() {
    cleos=cleos1 && if [ "$1" == "c2" ]; then cleos=cleos2; fi
    ${!cleos} push action ${contract_oracle} regservice '{"service_id":0,  "account":"'${provider1111}'", "amount":"10.0000 EOS", "service_price":"1.0000 EOS",
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

# // enum class memo_index : uint8_t { index_category,index_id ,index_count};
# // enum class memo_index_deposit : uint8_t { deposit_category,deposit_from ,deposit_to,deposit_notify , index_count};
# // enum class memo_index_complain : uint8_t { complain_category,index_id ,index_evidence,index_info,index_reason,index_count};
# // enum class memo_index_arbitrator : uint8_t { arbitrator_category,index_type ,index_count};
# // enum class memo_index_resp_case : uint8_t { resp_case_category,index_id ,index_round,index_evidence,index_count};
# // enum class memo_index_reappeal : uint8_t { reappeal_category,index_id ,index_round,index_evidence,index_provider,index_reason,index_arbi_id ,index_count};
# // enum class memo_index_reresp_case : uint8_t { reresp_case_category,index_id ,index_round,index_evidence,index_provider,index_count};
# // enum class memo_index_risk_guarantee : uint8_t { risk_guarantee_category,index_id ,index_duration,index_count};

transfer3() {
    echo --- cleos1 transfer 3---

    #complain
    $cleos1 transfer ${consumer2222} ${contract_oracle} "0.0001 EOS" "3,1,'','','reason'" -p ${consumer2222}
    #arbitrator
    $cleos1 transfer ${consumer2222} ${contract_oracle} "0.0001 EOS" "4,1" -p ${consumer2222}
    #resp_case
    $cleos1 transfer ${consumer2222} ${contract_oracle} "0.0001 EOS" "5,0,1" -p ${consumer2222}
    #reappeal
    $cleos1 transfer ${consumer2222} ${contract_oracle} "0.0001 EOS" "6,1,2,0,'reason',0" -p ${consumer2222}
    #reresp_case
    $cleos1 transfer ${consumer2222} ${contract_oracle} "0.0001 EOS" "7,0,2" -p ${consumer2222}

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

test_fetchdatawithp() {
    cleos=cleos1 && if [ "$1" == "c2" ]; then cleos=cleos2; fi

    ${!cleos} push action ${contract_consumer} fetchdata '{"oracle":"'${contract_oracle}'","service_id":1, "update_number":'$2'}' -p ${contract_consumer}

}

test_fetchdata() {
    cleos=cleos1 && if [ "$1" == "c2" ]; then cleos=cleos2; fi

    # ${!cleos} push action ${contract_consumer} fetchdata '{"oracle":"'${contract_oracle}'","service_id":1, "update_number":'$current_update_number'}' -p ${contract_consumer}
    ${!cleos} push action ${contract_consumer} fetchdata '{"oracle":"'${contract_oracle}'","service_id":1, "update_number":5215135}' -p ${contract_consumer}

}


test_regarbitrat()
{
     cleos=cleos1 && if [ "$1" == "c2" ]; then cleos=cleos2; fi
###=============================================== regarbitrat, ok
${!cleos} push action ${contract_oracle} regarbitrat '["arbitrator11", "EOS7UCx8GSeEHC4XE8jQ1R5WJqw5Vp2vZqWgQx94obFVbebnYg6eq", 1, "1.0000 EOS", "hello world"]' -p arbitrator11@active
${!cleos} push action ${contract_oracle} regarbitrat '["arbitrator12", "EOS7UCx8GSeEHC4XE8jQ1R5WJqw5Vp2vZqWgQx94obFVbebnYg6eq", 1, "1.0000 EOS", "hello world"]' -p arbitrator12@active
${!cleos} push action ${contract_oracle} regarbitrat '["arbitrator13", "EOS7UCx8GSeEHC4XE8jQ1R5WJqw5Vp2vZqWgQx94obFVbebnYg6eq", 1, "1.0000 EOS", "hello world"]' -p arbitrator13@active
${!cleos} push action ${contract_oracle} regarbitrat '["arbitrator14", "EOS7UCx8GSeEHC4XE8jQ1R5WJqw5Vp2vZqWgQx94obFVbebnYg6eq", 1, "1.0000 EOS", "hello world"]' -p arbitrator14@active
${!cleos} push action ${contract_oracle} regarbitrat '["arbitrator15", "EOS7UCx8GSeEHC4XE8jQ1R5WJqw5Vp2vZqWgQx94obFVbebnYg6eq", 1, "1.0000 EOS", "hello world"]' -p arbitrator15@active
${!cleos} get table ${contract_oracle} ${contract_oracle} arbitrators
}

test_regs()
{

    cleos=cleos1 && if [ "$1" == "c2" ]; then cleos=cleos2; fi
    ${!cleos} set account permission ${contract_oracle} active '{"threshold": 1,"keys": [{"key": "'${oracle_c_pubkey}'","weight": 1}],"accounts": [{"permission":{"actor":"'${contract_oracle}'","permission":"eosio.code"},"weight":1}]}' owner -p ${contract_oracle}@owner

    ###=============================================== regservice, ok
${!cleos} push action ${contract_oracle} regservice '{"service_id":0,  "account":"provider1111", "amount":"10.0000 EOS", "service_price":"1.0000 EOS",
                          "fee_type":1, "data_format":"", "data_type":0, "criteria":"",
                          "acceptance":0, "declaration":"", "injection_method":0, "duration":1,
                          "provider_limit":3, "update_cycle":1, "update_start_time":"2019-07-29T15:27:33.216857+00:00"}' -p provider1111@active
${!cleos} get table ${contract_oracle} ${contract_oracle} dataservices
${!cleos} get table ${contract_oracle} ${contract_oracle} providers
${!cleos} get table ${contract_oracle} provider1111 provservices
${!cleos} get table ${contract_oracle} ${contract_oracle} servicestake
${!cleos} get table ${contract_oracle} 0 svcprovision
}

test_complain()
{
     cleos=cleos1 && if [ "$1" == "c2" ]; then cleos=cleos2; fi
###=============================================== complain 申诉, ok
${!cleos} push action ${contract_oracle} complain '["complainant1", 1, "1.0000 EOS", "complainant1", 1]' -p complainant1@active
${!cleos} get table ${contract_oracle} ${contract_oracle} complainants
${!cleos} get table ${contract_oracle} ${contract_oracle} arbicaseapp
${!cleos} get table ${contract_oracle} ${contract_oracle} arbiprocess
}

test_respcase()
{
     cleos=cleos1 && if [ "$1" == "c2" ]; then cleos=cleos2; fi
###=============================================== respcase 数据提供者应诉, ok
${!cleos} push action ${contract_oracle} respcase '["provider1111", 0, "1.0000 EOS",1]' -p provider1111@active
}

test_acceptarbi()
{
     cleos=cleos1 && if [ "$1" == "c2" ]; then cleos=cleos2; fi
###=============================================== acceptarbi 仲裁员应诉, ok
${!cleos} push action ${contract_oracle} acceptarbi '["arbitrator14", "1.0000 EOS", 0, 0]' -p arbitrator14@active
${!cleos} push action ${contract_oracle} acceptarbi '["arbitrator12", "1.0000 EOS", 0, 0]' -p arbitrator12@active
${!cleos} push action ${contract_oracle} acceptarbi '["arbitrator13", "1.0000 EOS", 0, 0]' -p arbitrator13@active
}

test_uploadeviden()
{
     cleos=cleos1 && if [ "$1" == "c2" ]; then cleos=cleos2; fi
###=============================================== uploadeviden, 申诉者上传证据, ok
${!cleos} push action ${contract_oracle} uploadeviden '["complainant1", 0, "evidence"]' -p complainant1@active
}

test_uploadresult()
{
     cleos=cleos1 && if [ "$1" == "c2" ]; then cleos=cleos2; fi
###=============================================== uploadresult 仲裁员上传仲裁结果, ok
# 数据使用者赢
${!cleos} push action ${contract_oracle} uploadresult '["arbitrator12", 0, 1, 0]' -p arbitrator12@active
${!cleos} push action ${contract_oracle} uploadresult '["arbitrator13", 0, 1, 0]' -p arbitrator13@active
}

test_reappeal()
{
     cleos=cleos1 && if [ "$1" == "c2" ]; then cleos=cleos2; fi
###=============================================== reappeal, 数据提供者再次申诉, ok
${!cleos} push action ${contract_oracle} reappeal '["provider1111", 0, 0, 1, 0, true, "1.0000 EOS", 1, "再次申诉"]' -p provider1111@active
}

test_rerespcase()
{
     cleos=cleos1 && if [ "$1" == "c2" ]; then cleos=cleos2; fi
###=============================================== rerespcase, 数据使用者再次应诉, ok
${!cleos} push action ${contract_oracle} rerespcase '["complainant1", 0, 0, 0, false]' -p complainant1@active
}

test_acceptarbi2()
{
     cleos=cleos1 && if [ "$1" == "c2" ]; then cleos=cleos2; fi
###=============================================== acceptarbi 仲裁员应诉, ok
${!cleos} push action ${contract_oracle} acceptarbi '["arbitrator11", "1.0000 EOS", 0, 1]' -p arbitrator11@active
${!cleos} push action ${contract_oracle} acceptarbi '["arbitrator12", "1.0000 EOS", 0, 1]' -p arbitrator12@active
${!cleos} push action ${contract_oracle} acceptarbi '["arbitrator13", "1.0000 EOS", 0, 1]' -p arbitrator13@active
${!cleos} push action ${contract_oracle} acceptarbi '["arbitrator14", "1.0000 EOS", 0, 1]' -p arbitrator14@active
${!cleos} push action ${contract_oracle} acceptarbi '["arbitrator15", "1.0000 EOS", 0, 1]' -p arbitrator15@active
}

test_uploadeviden2()
{
     cleos=cleos1 && if [ "$1" == "c2" ]; then cleos=cleos2; fi
###=============================================== uploadeviden, 申诉者上传证据, ok
${!cleos} push action ${contract_oracle} uploadeviden '["provider1111", 1, "provider1111 evidence"]' -p provider1111@active
}

test_uploadresult2()
{
     cleos=cleos1 && if [ "$1" == "c2" ]; then cleos=cleos2; fi
###=============================================== uploadresult 仲裁员上传仲裁结果, ok
# 数据提供者赢
${!cleos} push action ${contract_oracle} uploadresult '["arbitrator11", 0, 0, 1]' -p arbitrator11@active
${!cleos} push action ${contract_oracle} uploadresult '["arbitrator12", 0, 0, 1]' -p arbitrator12@active
${!cleos} push action ${contract_oracle} uploadresult '["arbitrator13", 0, 0, 1]' -p arbitrator13@active
}

test_reappeal2()
{
     cleos=cleos1 && if [ "$1" == "c2" ]; then cleos=cleos2; fi
###=============================================== reappeal, 数据使用者再次申诉, ok
${!cleos} push action ${contract_oracle} reappeal '["complainant1", 0, 0, 1, 1, false, "1.0000 EOS", 1, "数据使用者不服, 再次申诉"]' -p complainant1@active
}

test_rerespcase2()
{
     cleos=cleos1 && if [ "$1" == "c2" ]; then cleos=cleos2; fi
###=============================================== rerespcase, 数据提供者再次应诉, ok
${!cleos} push action ${contract_oracle} rerespcase '["provider1111", 0, 0, 1, true]' -p complainant1@active
}

test_arbi() {
    #  transfer
    case "$1" in
    "rega") test_regarbitrat ;;
    "regs") test_regs ;;
    "comp") test_complain ;;
    "resp") test_respcase ;;
    "acc") test_acceptarbi ;;
    "upev") test_uploadeviden ;;
    "upre") test_uploadresult ;;
    "reap") test_reappeal ;;
    "reresp") test_rerespcase ;;

    *) echo "usage: arbi rega|comp|resp|acc|upev|upre|reap|reresp" ;;
    esac
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
"arbi") test_arbi "$2" ;;
*) echo "usage: oracle_test.sh set|init {reg|fee|subs|pushr {reqid}|mpush {false|true|}|req|deposit|withdraw}|acc|transfer {stake|pay|deposit|arbi}|keys|table {name}|table1 {scope name}|info|scope|data|pub|auto" ;;
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



arib(){
    # Private key: 5JNzcBuxPGmF3Saw3cedYzE6jL7VksFayxqpjokMTRpARkCwmHa
# Public key: EOS7UCx8GSeEHC4XE8jQ1R5WJqw5Vp2vZqWgQx94obFVbebnYg6eq

PUBKEY=EOS7UCx8GSeEHC4XE8jQ1R5WJqw5Vp2vZqWgQx94obFVbebnYg6eq

###=============================================== 创建账号

EOS_TOKEN=eosio.token
################################################################## 发币
cleos set contract $EOS_TOKEN /bos.contracts/build/contracts/eosio.token -p $EOS_TOKEN@active
cleos push action $EOS_TOKEN create '[ "eosio.token", "10000000000.0000 EOS", 0, 0, 0]' -p $EOS_TOKEN
cleos push action $EOS_TOKEN issue '["eosio.token", "1000000000.0000 EOS", ""]' -p $EOS_TOKEN

###=============================================== 部署合约
EOS_ORACLE=bos.oracle
cleos set contract ${contract_oracle} /bos.contracts/contracts/bos.oracle -p ${contract_oracle}
###=============================================== set permission
cleos set account permission ${contract_oracle} active '{"threshold": 1,"keys": [{"key": "EOS7UCx8GSeEHC4XE8jQ1R5WJqw5Vp2vZqWgQx94obFVbebnYg6eq","weight": 1}],"accounts": [{"permission":{"actor":"bos.oracle","permission":"eosio.code"},"weight":1}]}' -p ${contract_oracle}@active


# TODO: 测试大众仲裁人数不够

cleos get table ${contract_oracle} ${contract_oracle} arbicaseapp
cleos get table ${contract_oracle} ${contract_oracle} arbiprocess
cleos get table ${contract_oracle} ${contract_oracle} arbiresults

###=============================================== Tables
cleos get table ${contract_oracle} ${contract_oracle} arbitrators
cleos get table ${contract_oracle} ${contract_oracle} complainants
cleos get table ${contract_oracle} ${contract_oracle} arbicaseapp

cleos get table ${contract_oracle} ${contract_oracle} dataservices
cleos get table ${contract_oracle} 0 svcprovision


}

