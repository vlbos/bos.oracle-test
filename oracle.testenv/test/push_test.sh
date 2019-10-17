#!/usr/bin/env bash

. env.sh
#. chains_init.sh

test_regservice() {
    test_reg_service5
    provider_transfer5 $1
    test_fee $1
    test_subs5 $1
    consumer_transfer5 $1
}

test_pushtotable() {
    test_indirectpush $1 $2
    echo == get table oracledata
    test_get_table1 $1 oracledata
    test_fetchdatawithp c1 $current_update_number $1
}

provider_transfer5() {
    echo --- cleos1 provider transfer ---

    for i in {1..5}; do
        p='provider'${i}${i}${i}${i}
        $cleos1 transfer ${p} ${contract_oracle} "1000.0000 BOS" "0,"$1 -p ${p}
        sleep .1
    done
}

consumer_transfer5() {
    echo --- cleos1 consumer transfer ---

    for i in {1..5}; do
        c='consumer'${i}${i}${i}${i}
        $cleos1 transfer ${c} ${contract_oracle} "10.0001 BOS" "1,"$1 -p ${c}
        sleep .1
    done

}

service_duration=30
update_cycle=120
update_start_time_date="2019-10-10"
update_start_time_time="09:09:09"
update_start_time=1570758862
#$update_start_time_date"T"$update_start_time_time".000000+00:00"

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

    echo "a="$a
    echo "b="$b
    get_current_date
    start_time=$update_start_time
    #$update_start_time
    #$(date -j -u -f "%Y-%m-%d %H:%M:%S" $update_start_time_date" "$update_start_time_time "+%s")
    diff_time=$(($datetime2 - $start_time))
    current_update_number=$(($diff_time / $a + 1))
    begin_time=$(($start_time + ($current_update_number - 1) * $a))
    end_time=$(($begin_time + $b))
    echo "begin_time="$begin_time
    echo "end_time="$end_time
    if [ $datetime2 -le $end_time ]; then return $current_update_number; fi
    next_begin_time=$(($begin_time + $a))
    waitnext $next_begin_time
    get_update_number $a $b

}

test_reg_service5() {
    echo ==reg 5
    cleos=cleos1 && if [ "$1" == "c2" ]; then cleos=cleos2; fi
    ${!cleos} push action ${contract_oracle} regservice '{"account":"provider1111", "base_stake_amount":"1000.0000 BOS",  "data_format":"", "data_type":1, "criteria":"",
                          "acceptance":3,  "injection_method":0, "duration":'${service_duration}',
                          "provider_limit":3, "update_cycle":'${update_cycle}'}' -p provider1111@active
}

test_subs5() {
    echo ===subs5
    cleos=cleos1
    #&& if [ "$1" == "c2" ]; then cleos=cleos2; fi
    for i in {1..5}; do
        c='consumer'${i}${i}${i}${i}
        ${!cleos} push action ${contract_oracle} subscribe '{"service_id":"'$1'",     "contract_account":"consumercon'${i}'",  "publickey":"",          "account":"'${c}'", "amount":"10.0000 BOS", "memo":""}' -p ${c}@active

        sleep .1
    done
}

test_indirectpush() {
    update_start_time=$2
    echo ==indipush
    cleos=cleos1
    #&& if [ "$1" == "c2" ]; then cleos=cleos2; fi

    start_time=$update_start_time
    #$(date -j -u -f "%Y-%m-%d %H:%M:%S" $update_start_time_date" "$update_start_time_time "+%s")
    echo "start_time="$start_time
    echo "datetime2="$datetime2
    echo "update_cycle="$update_cycle
    echo "service_duration="$service_duration
    get_update_number $update_cycle $service_duration
    echo "current_update_number="$current_update_number
    if [ $current_update_number -ne 0 ]; then
        for i in {1..5}; do
            p='provider'${i}${i}${i}${i}
            ${!cleos} push action ${contract_oracle} pushdata '{"service_id":'$1', "provider":"'${p}'", "cycle_number":"'${current_update_number}'", 
                         "request_id":0, "data":"indi publish test data json"}' -p ${p}
            sleep 2
        done
    else
        echo current update number equal zero
    fi
}

test_reg_service() {
    cleos=cleos1 && if [ "$1" == "c2" ]; then cleos=cleos2; fi
    ${!cleos} push action ${contract_oracle} regservice '{"account":"provider1111","base_stake_amount":"1000.0000 BOS","data_format":"", "data_type":1, "criteria":"",
                          "acceptance":3,  "injection_method":0, "duration":1,
                          "provider_limit":3, "update_cycle":1}' -p provider1111@active

}

test_fee() {
    cleos=cleos1 && if [ "$1" == "c2" ]; then cleos=cleos2; fi

    ${!cleos} push action ${contract_oracle} addfeetypes '{"service_id":"1","fee_types":[0,1],"service_prices":["1.0000 BOS","2.0000 BOS"] }' -p ${contract_oracle}@active

}

test_para() {
    cleos=cleos1 && if [ "$1" == "c2" ]; then cleos=cleos2; fi

    core_symbol="BOS"
    precision=4
    min_service_stake_limit=1000
    min_appeal_stake_limit=100
    min_reg_arbitrator_stake_limit=10000
    arbitration_correct_rate=60
    round_limit=3
    arbi_timeout_value=3600
    arbi_freeze_stake_duration=$((3600 * 24))
    time_deadline=$((3600 * 24))
    clear_data_time_length=10800
    max_data_size=256
    min_provider_limit=1
    max_provider_limit=100
    min_update_cycle=1
    max_update_cycle=$((3600 * 24 * 100))
    min_duration=1
    max_duration=100000
    min_acceptance=1
    max_acceptance=100
    current_oracle_version=1

    ${!cleos} push action ${contract_oracle} setparameter '{"version":'$current_oracle_version',"parameters":{"core_symbol":"'$core_symbol'","precision":'$precision',"min_service_stake_limit":'$min_service_stake_limit',"min_appeal_stake_limit":'$min_appeal_stake_limit',"min_reg_arbitrator_stake_limit":'$min_reg_arbitrator_stake_limit',"arbitration_correct_rate":'$arbitration_correct_rate',"round_limit":'$round_limit',"arbi_timeout_value":'$arbi_timeout_value',"arbi_freeze_stake_duration":'$arbi_freeze_stake_duration',"time_deadline":'$time_deadline',"clear_data_time_length":'$clear_data_time_length',"max_data_size":'$max_data_size',"min_provider_limit":'$min_provider_limit',"max_provider_limit":'$max_provider_limit',"min_update_cycle":'$min_update_cycle',"max_update_cycle":'$max_update_cycle',"min_duration":'$min_duration', "max_duration":'$max_duration',"min_acceptance":'$min_acceptance',"max_acceptance":'$max_acceptance'}}' -p ${contract_oracle}@active

}

test_getpara() {
    cleos=cleos1 && if [ "$1" == "c2" ]; then cleos=cleos2; fi

    ${!cleos} push action ${contract_oracle} getparameter '{"value":1}' -p ${contract_oracle}@active

}

test_subs() {
    cleos=cleos1 && if [ "$1" == "c2" ]; then cleos=cleos2; fi

    ${!cleos} push action ${contract_oracle} subscribe '{"service_id":"1", "contract_account":"'${contract_consumer}'",  "publickey":"",  "account":"consumer1111", "amount":"10.0000 BOS", "memo":""}' -p consumer1111@active
}

test_push() {
    cleos=cleos1 && if [ "$1" == "c2" ]; then cleos=cleos2; fi

    ${!cleos} push action ${contract_oracle} pushdata '{"service_id":1, "provider":"provider1111", "contract_account":"'${contract_consumer}'", 
                         "request_id":0, "data":"test data json"}' -p provider1111

}

test_pushforreq() {
    cleos=cleos1 && if [ "$1" == "c2" ]; then cleos=cleos2; fi

    echo ===
    echo "$1"
    echo "$2"

    ${!cleos} push action ${contract_oracle} pushdata '{"service_id":1, "provider":"provider1111", "contract_account":"'${contract_consumer}'", 
                         "request_id":'"$2"', "data":"test data json"}' -p provider1111

}

test_multipush() {
    cleos=cleos1 && if [ "$1" == "c2" ]; then cleos=cleos2; fi
    reqflag=false && if [ "$2" != "" ]; then reqflag="$2"; fi

    echo ===multipush
    # ${!cleos}  set account permission provider1111  active '{"threshold":1,"keys":[{"key":"'${provider1111_pubkey}'","weight":1}],"accounts":[{"permission":{"actor":"'${contract_oracle}'","permission":"eosio.code"},"weight":1}]}' owner -p provider1111@owner

    # sleep .2
    ${!cleos} push action ${contract_oracle} multipush '{"service_id":0, "provider":"provider1111", 
                          "data":"test multipush data json","is_request":'${reqflag}'}' -p provider1111
}

test_req() {
    cleos=cleos1 && if [ "$1" == "c2" ]; then cleos=cleos2; fi

    ${!cleos} push action ${contract_oracle} requestdata '{"service_id":0,  "contract_account":"'${contract_consumer}'", 
                         "requester":"consumer1111", "request_content":"eth usd"}' -p consumer1111@active
}

test_() {
    cleos=cleos1 && if [ "$1" == "c2" ]; then cleos=cleos2; fi

    ${!cleos} push action ${contract_oracle} requestdata '{"service_id":"0",  "contract_account":"", 
                         "account":"", "request_content":""}' -p ${contract_consumer}@active
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
    $cleos1 transfer provider1111 ${contract_oracle} "0.0001 BOS" "0,0" -p provider1111
    $cleos1 transfer consumer2222 ${contract_oracle} "0.0001 BOS" "1,0" -p consumer2222
    $cleos1 transfer consumer2222 ${contract_oracle} "0.0001 BOS" "2,consumer2222,consumer1111,0" -p consumer2222
    $cleos1 transfer consumer2222 ${contract_oracle} "0.0001 BOS" "3,0" -p consumer2222

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
    $cleos1 transfer provider1111 ${contract_oracle} "0.0001 BOS" "0,1" -p provider1111
    echo --- providers after transfer ---
    test_get_table providers
    echo --- svcprovision after transfer ---
    test_get_table1 0 svcprovision
    echo --- servicestake after transfer ---
    test_get_table servicestake
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
    echo == fetchdata number
    cleos=cleos1 && if [ "$1" == "c2" ]; then cleos=cleos2; fi

    ${!cleos} push action ${contract_consumer} fetchdata '{"oracle":"'${contract_oracle}'","service_id":'$3', "cycle_number":'$2', "request_id":0}' -p ${contract_consumer}
}

test_fetchdatawithreq() {
    echo == fetchdata req
    cleos=cleos1 && if [ "$1" == "c2" ]; then cleos=cleos2; fi

    ${!cleos} push action ${contract_consumer} fetchdata '{"oracle":"'${contract_oracle}'","service_id":1, "cycle_number":0, "request_id":'$2'}' -p ${contract_consumer}
}

test_fetchdata() {
    cleos=cleos1 && if [ "$1" == "c2" ]; then cleos=cleos2; fi

    # ${!cleos} push action ${contract_consumer} fetchdata '{"oracle":"'${contract_oracle}'","service_id":1, "cycle_number":'$current_update_number'}' -p ${contract_consumer}
    ${!cleos} push action ${contract_consumer} fetchdata '{"oracle":"'${contract_oracle}'","service_id":1, "cycle_number":1565749229, "request_id":0}' -p ${contract_consumer}

}

case "$1" in
"regs") test_regservice "$2" ;;
"reg") test_reg_service c1 ;;
"fee") test_fee c1 "$2" ;;
"para") test_para c1 ;;
"gpara") test_getpara c1 ;;
"subs") test_subs c1 "$2" ;;
"req") test_req c1 ;;
"pusht") test_pushtotable "$2" "$3" ;;
*) echo "usage:regs|reg|fee|subs|req|pusht" ;;
esac
