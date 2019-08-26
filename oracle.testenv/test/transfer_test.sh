#!/usr/bin/env bash

. env.sh
#. chains_init.sh

test_reg_service() {
    cleos=cleos1 && if [ "$1" == "c2" ]; then cleos=cleos2; fi
    ${!cleos} push action ${contract_oracle} regservice '{"service_id":0,  "account":"'${provider1111}'", "data_format":"", "data_type":0, "criteria":"",
                          "acceptance":0, "declaration":"", "injection_method":0, "duration":1,
                          "provider_limit":3, "update_cycle":1, "update_start_time":"2019-07-29T15:27:33.216857+00:00"}' -p ${provider1111}@active

}

transfer1() {
    echo --- cleos1 subscription before transfer ---
    test_get_table1 0 subscription
    echo --- cleos1 pay service before transfer ---
    $cleos1 transfer ${contract_consumer} ${contract_oracle} "0.0001 BOS" "1,0" -p ${contract_consumer}
    echo --- cleos1 subscription after transfer ---
    test_get_table1 0 subscription
}

transfer2() {
    echo --- riskaccounts before transfer 2---
    test_get_table1 consumer1111 riskaccounts
    echo --- deposit transfer 2---
    $cleos1 transfer ${consumer2222} ${contract_oracle} "0.0001 BOS" "2,consumer2222,consumer1111,0" -p ${consumer2222}
    echo --- riskaccounts after transfer 2---
    test_get_table1 consumer1111 riskaccounts
}

# //  index_category,index_id
# //  deposit_category,deposit_from ,deposit_to,deposit_notify
# // appeal_category,index_id ,index_evidence,index_info,index_reason
# //  arbitrator_category,index_type
# //  resp_case_category,index_id ,index_evidence
# // risk_guarantee_category,index_id ,index_duration

transfer3() {
    echo --- cleos1 transfer 3---

    cleos=cleos1 && if [ "$1" == "c2" ]; then cleos=cleos2; fi
    ${!cleos} set account permission ${contract_oracle} active '{"threshold": 1,"keys": [{"key": "'${oracle_c_pubkey}'","weight": 1}],"accounts": [{"permission":{"actor":"'${contract_oracle}'","permission":"eosio.code"},"weight":1}]}' owner -p ${contract_oracle}@owner

    #appeal
    $cleos1 transfer ${consumer2222} ${contract_oracle} "0.0001 BOS" "3,1,'','','reason'" -p ${consumer2222}
    # #arbitrator
    # $cleos1 transfer ${consumer2222} ${contract_oracle} "0.0001 BOS" "4,1" -p ${consumer2222}
    # #resp_case
    # $cleos1 transfer ${consumer2222} ${contract_oracle} "0.0001 BOS" "5,0,1" -p ${consumer2222}

}

transfer_appeal() {
    echo --- cleos1 transfer 3---

    cleos=cleos1 && if [ "$1" == "c2" ]; then cleos=cleos2; fi
    ${!cleos} set account permission ${contract_oracle} active '{"threshold": 1,"keys": [{"key": "'${oracle_c_pubkey}'","weight": 1}],"accounts": [{"permission":{"actor":"'${contract_oracle}'","permission":"eosio.code"},"weight":1}]}' owner -p ${contract_oracle}@owner

    #appeal
    ${!cleos} transfer  appeallant11 ${contract_oracle} "200.0000 BOS" "3,1,'evidence','info','reason',0" -p appeallant11
}

transfer_regarbi() {
    echo --- cleos1 transfer 3---

    cleos=cleos1 && if [ "$1" == "c2" ]; then cleos=cleos2; fi
    ${!cleos} set account permission ${contract_oracle} active '{"threshold": 1,"keys": [{"key": "'${oracle_c_pubkey}'","weight": 1}],"accounts": [{"permission":{"actor":"'${contract_oracle}'","permission":"eosio.code"},"weight":1}]}' owner -p ${contract_oracle}@owner

    #arbitrator
    # ${!cleos}  transfer ${consumer2222} ${contract_oracle} "0.0001 BOS" "4,1" -p ${consumer2222}

    for i in {1..5}; do
        for j in {1..5}; do
            account='arbitrator'${i}${j}
            ${!cleos}  transfer ${account} ${contract_oracle} "10000.0000 BOS" "4,1" -p ${account}
            sleep 1
        done
    done
${!cleos} get table ${contract_oracle} ${contract_oracle} arbitrators
}

transfer_respcase() {
    echo --- cleos1 transfer 3---

    cleos=cleos1 && if [ "$1" == "c2" ]; then cleos=cleos2; fi
    ${!cleos} set account permission ${contract_oracle} active '{"threshold": 1,"keys": [{"key": "'${oracle_c_pubkey}'","weight": 1}],"accounts": [{"permission":{"actor":"'${contract_oracle}'","permission":"eosio.code"},"weight":1}]}' owner -p ${contract_oracle}@owner

    #resp_case
    ${!cleos}  transfer ${provider1111} ${contract_oracle} "200.0000 BOS" "5,1,''" -p ${provider1111}
}

test_transfer() {
    cleos=cleos1 && if [ "$1" == "c2" ]; then cleos=cleos2; fi
    ${!cleos} set account permission ${contract_oracle} active '{"threshold": 1,"keys": [{"key": "'${oracle_c_pubkey}'","weight": 1}],"accounts": [{"permission":{"actor":"'${contract_oracle}'","permission":"eosio.code"},"weight":1}]}' owner -p ${contract_oracle}@owner

    #  transfer
#     ./init_chains.sh 
# ./boracle_test.sh set
#   ./boracle_test.sh init reg
# ./transfer_test.sh  regarbi
# ./transfer_test.sh  appeal
# ./transfer_test.sh  respcase

}


  case "$1" in
    "stake") transfer0 ;;
    "pay") transfer1 ;;
    "deposit") transfer2 ;;
    "regarbi") transfer_regarbi ;;
    "appeal") transfer_appeal ;;
    "respcase") transfer_respcase ;;
    *) echo "usage: stake|pay|deposit|regarbi|appeal|respcase" ;;
    esac
