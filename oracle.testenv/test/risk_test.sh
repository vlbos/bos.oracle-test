#!/usr/bin/env bash

. env.sh
#. chains_init.sh

test_deposit() {
    cleos=cleos1 && if [ "$1" == "c2" ]; then cleos=cleos2; fi

    ${!cleos} push action ${contract_oracle} deposit '{"service_id":0,  "from":"oraclize1111", "to":"consumer1111",
                         "quantity":"10.0000 BOS", "memo":"","is_notify":false}' -p ${contract_oracle}@active
}

test_withdraw() {
    cleos=cleos1 && if [ "$1" == "c2" ]; then cleos=cleos2; fi

    ${!cleos} push action ${contract_oracle} withdraw '{"service_id":0,  "from":"consumer1111", "to":"oraclize1111",
                         "quantity":"1.0000 BOS", "memo":""}' -p ${contract_oracle}@active
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
"tot") test_pushtotable ;;
"indi") test_indirectpush ;;
"arbi") test_arbi "$2" ;;
*) echo "usage: oracle_test.sh set|init {reg|fee|subs|pushr {reqid}|mpush {false|true|}|req|deposit|withdraw}|acc|transfer {stake|pay|deposit|arbi}|keys|table {name}|table1 {scope name}|info|scope|data|tot|indi" ;;
esac
