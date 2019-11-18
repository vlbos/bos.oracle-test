#!/usr/bin/env bash

. env.sh
#. chains_init.sh

set_contracts() {
    cleos=cleos1 && if [ "$1" == "c2" ]; then cleos=cleos2; fi
    ${!cleos} set contract ${contract_burn} ${CONTRACTS_DIR}/${contract_burn_folder} -x 1000 -p ${contract_burn}
    sleep .2

    ${!cleos} set account permission ${contract_burn} active '{"threshold": 1,"keys": [{"key": "'${burn_c_pubkey}'","weight": 1}],"accounts": [{"permission":{"actor":"'${contract_burn}'","permission":"eosio.code"},"weight":1}]}' owner -p ${contract_burn}@owner
}

test_set_contracts() {
    set_contracts c1
    # set_contracts c2
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
    # get_account bosbosburn
    # get_account ${contract_burn}
}

transfer() {
    echo --- cleos1 transfer ---
    $cleos1 transfer provider1111 ${contract_burn} "0.0001 BOS" "0,0" -p provider1111
    $cleos1 transfer consumer2222 ${contract_burn} "0.0001 BOS" "1,0" -p consumer2222
    $cleos1 transfer consumer2222 ${contract_burn} "0.0001 BOS" "2,consumer2222,consumer1111,0" -p consumer2222
    $cleos1 transfer consumer2222 ${contract_burn} "0.0001 BOS" "3,0" -p consumer2222

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
    $cleos1 transfer provider1111 ${contract_burn} "0.0001 BOS" "0,0" -p provider1111
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

get_burn_table() {
    cleos=cleos1 && if [ "$1" == "c2" ]; then cleos=cleos2; fi
    echo $2
    ${!cleos} get table ${contract_burn} ${contract_burn} $2 --limit 100

}
get_burn_table1() {
    cleos=cleos1 && if [ "$1" == "c2" ]; then cleos=cleos2; fi

    ${!cleos} get table ${contract_burn} $2 $3 --limit 100

}

test_get_table() {
    get_burn_table c1 $1
}

test_get_table1() {
    get_burn_table1 c1 $1 $2
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
    ${!cleos} get scope -t accounts ${contract_burn}

}
substringindex()
{
    tmp=${$1'%%'$2'*'}     # Remove the search string and everything after it
    echo $(( ${#tmp} + 1 )) # Add one to the length of the remaining prefix
}

test_get_scope() {
    get_scope c1
}

test_get_info() {
    get_info c1
}

test_importaccounts() {
    # $cleos1 push action ${contract_burn} importacnts '[[{"account":"provider3333", "quantity":"0.0001 BOS"},{"account":"provider2222", "quantity":"0.0001 BOS"}]]' -p ${contract_burn}
    ${cleos1} push action ${contract_burn} importacnts '[[["provider3333","0.0001 BOS"],["provider4444","0.0001 BOS"]]]' -p ${contract_burn}

    test_get_table1 provider3333 accounts

}

test_clear() {
    ${cleos1} push action ${contract_burn} clear '[["provider3333","provider4444"]]' -p ${contract_burn}
}

test_setparameter() {
    # ${cleos1} push action ${contract_burn} setparameter '[1,"'${contract_burn}'"]' -p ${contract_burn}
    outputresult=$(${cleos1} push action ${contract_burn} setparameter '[1,"'${contract_burn}'"]' -p ${contract_burn})
    
   substringindex  $outputresult  "2"  

}

test_burn() {
    ${cleos1} push action ${contract_burn} burn '["0.0001 BOS"]' -p ${contract_burn}
}

test_trnasferair() {
    ${cleos1} push action ${contract_burn} transferair '["vsyqzsaynmqq"]' -p provider4444
    test_get_table1 provider3333 accounts
}


flag=0
count=0
limits=100
accs=''
file=./airdropburn/airdrop_unactive_account.csv
test_importaccs() {
    OLD_IFS=$IFS #保存原始值
    IFS="="
    cleos -u http://127.0.0.1:8888 push action ${contract_burn} importacnts '[['$accs']]' -p ${contract_burn}
    IFS=$OLD_IFS #还原IFS的原始值
}
test_csvimport() {
    Start=$(date +%s)
    
    OLD_IFS=$IFS #保存原始值
    IFS=","

    while read name quantity; do
        quantityx=$(echo $quantity | tr -d '\r')
        accs=$accs$(echo '["'$name'","'$quantityx'"]')
        count=$(($count + 1))
        if (($(($count % $limits)) == 0)); then
            test_importaccs
            echo "=========count========"$count
            End=$(date +%s)
            echo $End
            accs=''
        else
            accs=$accs','
        fi
    done <$file

    IFS=$OLD_IFS #还原IFS的原始值

    if (($(($count % $limits)) > 0)); then
        accs=${accs%","}
        test_importaccs
        echo "=========count========"$count
    fi
    End=$(date +%s)
    Time=$(($End-$Start))
    echo $Time"==============csv end============="
}

test_arrclear() {
    OLD_IFS=$IFS #保存原始值
    IFS="="
    cleos -u http://127.0.0.1:8888 push action ${contract_burn} clear '[['$accs']]' -p ${contract_burn}
    IFS=$OLD_IFS #还原IFS的原始值
}
test_clearfromcsv() {
    Start=$(date +%s)
    
    OLD_IFS=$IFS #保存原始值
    IFS=","
    while read name quantity; do
        accs=$accs'"'$name'"'
        count=$(($count + 1))
        if (($(($count % $limits)) == 0)); then
            test_arrclear
            echo "=========count========"$count
            End=$(date +%s)
            echo $End
            accs=''
        else
            accs=$accs','
        fi
    done <$file

    IFS=$OLD_IFS #还原IFS的原始值

    if (($(($count % $limits)) > 0)); then
        accs=${accs%","}
        est_arrclear
        echo "=========count========"$count
    fi
    End=$(date +%s)
    Time=$(($End-$Start))

    echo $Time"==============clear end============="
}

test_transferairs() {
    OLD_IFS=$IFS #保存原始值
    IFS="="
    cleos -u http://127.0.0.1:8888 push action ${contract_burn} transferairs '["'$1'"]' -p ${contract_burn}
    IFS=$OLD_IFS #还原IFS的原始值
}

test_csvtransferairs() {
    Start=$(date +%s)
    OLD_IFS=$IFS #保存原始值
    IFS=","
    count=0
    while read name quantity; do
        test_transferairs $name
        End=$(date +%s)
        count=$(($count + 1))
        echo $count"=====transferairs==Time========"$End
    done <$file

    IFS=$OLD_IFS #还原IFS的原始值

    End=$(date +%s)
    Time=$(($End-$Start))
    echo $Time"==============airs end======Time=======" 
}


case "$1" in
"imp") test_importaccounts "$2" ;;
"clear") test_clear ;;
"setp") test_setparameter ;;
"burn") test_burn ;;
"air") test_trnasferair;;
"ct") test_csvtransferairs ;;
"ci") test_csvimport ;;
"set") test_set_contracts ;;
"acc") test_get_account "$2" ;;
"transfer") test_transfer "$2" ;;
"keys") test_list_pri_key ;;
"table") test_get_table "$2" ;;
"table1") test_get_table1 "$2" "$3" ;;
"info") test_get_info ;;
"scope") test_get_scope ;;
*) echo "usage: burn_test.sh imp|clear|setp|burn|air|ci|set|acc|transfer|keys|table {name}|table1 {scope name}|info|scope|data" ;;
esac
