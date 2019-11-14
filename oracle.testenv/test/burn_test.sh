#!/usr/bin/env bash

. env.sh
#. chains_init.sh

set_contracts() {
    cleos=cleos1 && if [ "$1" == "c2" ]; then cleos=cleos2; fi
    ${!cleos} set contract ${contract_oracle} ${CONTRACTS_DIR}/${contract_oracle_folder} -x 1000 -p ${contract_oracle}
    sleep .2

    ${!cleos} set contract ${contract_consumer} ${CONTRACTS_DIR}/${contract_consumer_folder} -x 1000 -p ${contract_consumer}@active
    sleep .2

    ${!cleos} set account permission ${contract_oracle} active '{"threshold": 1,"keys": [{"key": "'${oracle_c_pubkey}'","weight": 1}],"accounts": [{"permission":{"actor":"'${contract_oracle}'","permission":"eosio.code"},"weight":1}]}' owner -p ${contract_oracle}@owner
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
    $cleos1 transfer provider1111 ${contract_oracle} "0.0001 BOS" "0,0" -p provider1111
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
    echo $2
    ${!cleos} get table ${contract_oracle} ${contract_oracle} $2 --limit 100

}
get_oracle_table1() {
    cleos=cleos1 && if [ "$1" == "c2" ]; then cleos=cleos2; fi

    ${!cleos} get table ${contract_oracle} $2 $3 --limit 100

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
    ${!cleos} get scope -t accounts ${contract_oracle}

}

test_get_scope() {
    get_scope c1
}

test_get_info() {
    get_info c1
}

test_importaccounts() {
    # $cleos1 push action ${contract_oracle} importacnts '[[{"account":"provider3333", "quantity":"0.0001 BOS"},{"account":"provider2222", "quantity":"0.0001 BOS"}]]' -p ${contract_oracle}
    ${cleos1} push action ${contract_oracle} importacnts '[[["provider3333","0.0001 BOS"],["provider4444","0.0001 BOS"]]]' -p ${contract_oracle}

    test_get_table1 provider3333 accounts

}

test_clear() {
    ${cleos1} push action ${contract_oracle} clear '[["provider3333","provider4444"]]' -p ${contract_oracle}
}

test_setparameter() {
    ${cleos1} push action ${contract_oracle} setparameter '['${contract_oracle}']' -p ${contract_oracle}
}

test_burn() {
    ${cleos1} push action ${contract_oracle} burn '["0.0001 BOS"]' -p ${contract_oracle}
}

test_trnasferair() {
    ${cleos1} push action ${contract_oracle} transferair '["provider3333"]' -p provider4444
}


flag=0
count=0
limits=1000
accs=''
file=./airdropburn/output/airdrop_unactive_account.csv
test_importaccs() {
    OLD_IFS=$IFS #保存原始值
    IFS="="
    cleos -u http://127.0.0.1:8888 push action ${contract_oracle} importacnts '[['$accs']]' -p ${contract_oracle}
    IFS=$OLD_IFS #还原IFS的原始值
}

test_transferairs() {
    OLD_IFS=$IFS #保存原始值
    IFS="="
    cleos -u http://127.0.0.1:8888 push action ${contract_oracle} transferairs '[['$1']]' -p ${contract_oracle}
    IFS=$OLD_IFS #还原IFS的原始值
}

test_csvburn() {
    Start=$(date +%s)
    OLD_IFS=$IFS #保存原始值
    IFS=";"
    firstname=''
    count=0
    while read name quantity; do
        test_transferairs $name
        End =$(date +%s)
        count=$(($count + 1))
        echo $count"=====importing==Time========"$End
    done <$file

    IFS=$OLD_IFS #还原IFS的原始值

    End =$(date +%s)
    Time=$(($Start - $End))
    echo "=====imp==Time========"$Time
    echo "==============imp end============="
}

test_csvimport() {
    Start=$(date +%s)
    
    OLD_IFS=$IFS #保存原始值
    IFS=","
    firstname=''
    while read name quantity; do
        quantityx=$(echo $quantity | tr -d '\r')
        accs=$accs$(echo '["'$name'","'$quantityx'"]')
        count=$(($count + 1))
        if (($(($count % $limits)) == 0)); then
            # accs=$accs';'
            test_importaccs
            # echo $accs >>$ofile
            echo "=========count========"$count
            End=$(date +%s)
            echo $End
            accs=''
        else
            accs=$accs','
        fi

        #   firstname=$name
        #   cat_acc $name $quantity
    done <$file

    IFS=$OLD_IFS #还原IFS的原始值

    if (($(($count % $limits)) > 0)); then
        accs=${accs%","}
        echo $accs >>$ofile
        echo "=========count========"$count
    fi
    End=$(date +%s)
    Time=$(($Start - $End))
    echo "=====csv=Time========"$Time

    echo "==============csv end============="
}

case "$1" in
"cb") test_csvburn ;;
"ci") test_csvimport ;;
"set") test_set_contracts ;;
"acc") test_get_account "$2" ;;
"imp") test_importaccounts "$2" ;;
"transfer") test_transfer "$2" ;;
"keys") test_list_pri_key ;;
"table") test_get_table "$2" ;;
"table1") test_get_table1 "$2" "$3" ;;
"info") test_get_info ;;
"scope") test_get_scope ;;
*) echo "usage: burn_test.sh set|acc|imp|transfer|keys|table {name}|table1 {scope name}|info|scope|data" ;;
esac
