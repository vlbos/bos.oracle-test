#!/usr/bin/env bash

. env.sh
#. chains_init.sh


set_contracts(){
    cleos=cleos1 && if [ "$1" == "c2" ];then cleos=cleos2 ;fi
    ${!cleos} set contract ${contract_oracle} ${CONTRACTS_DIR}/${contract_oracle_folder} -x 1000 -p ${contract_oracle}
    sleep .2
    # ${!cleos} set contract ${contract_token} ${CONTRACTS_DIR}/${contract_token_folder} -x 1000 -p ${contract_token}
    # sleep .2
}
# set_contracts c1
# set_contracts c2

init_contracts(){
    cleos=cleos1 && if [ "$1" == "c2" ];then cleos=cleos2 ;fi

    # ${!cleos} set account permission ${contract_token} active '{"threshold": 1, "keys":[{"key":"'${token_c_pubkey}'", "weight":1}], "accounts":[{"permission":{"actor":"'${contract_token}'","permission":"eosio.code"},"weight":1}],"waits":[{"wait_sec":0,"weight":1}] }' owner -p ${contract_token}

    # --- ibc.chain ---
    # cleos push action delphioracle write '{"owner":"acryptotitan", "value":58500}' -p acryptotitan@active
    ${!cleos}  push action  ${contract_oracle} write '{"owner":"eosio", "value":58500}' -p eosio@active


    ${!cleos}  push action  ${contract_oraclize} addoracle '{"oracle":"oracleoracle"}' -p ${contract_oraclize}@active

    echo ===setup
    ${!cleos}  push action  ${contract_oraclized} setup '{"master":"oraclebosbos"}' -p ${contract_oraclized}@active
    echo ===push
    ${!cleos}  push action  ${contract_oraclize} push '{"oracle":"oracleoracle","contract":"bosoraclebos","task":"0xae1cb3a8b6b4c49c65d22655c1ec4d28a4b3819065dd6aaf990d18e7ede951f1","memo":"","data":""}' -p oracleoracle@active
}
# init_contracts c1
# init_contracts c2

get_account(){
    echo --- cleos1 ---  $1
    $cleos1 get account  $1
    # echo && echo --- cleos2 ---  $1
    # $cleos2 get account  $1
}
transfer(){
    echo --- cleos2 transfer ---
    $cleos1 transfer  ${contract_oraclized} ${contract_oraclize} "10.0000 EOS"  -p ${contract_oraclized}
    # $cleos2 transfer  testblklist1 testblklist2 "10.0000 BOS" "ibc receiver=chengsong111" -p testblklist1
}

pwd = 'cat /Users/lisheng/eosio-wallet/password.txt'

list_pri_key1()
{
     cleos=cleos1 && if [ "$1" == "c2" ];then cleos=cleos2 ;fi
${!cleos} wallet private_keys --password PW5JhG3FdGXSc2RTXRNC2tDrd4KhudMA1BggF9QvxJ6YUL4ktUh4k
}

list_pri_key1

# [[
#     "EOS547kdHMjA9zrpYtPBW4ixZ4g3K4KGqp1GXyzyxx7ugPrvwHjhe",
#     "5JCtWxuqPzcPUfFukj58q8TqyRJ7asGnhSYvvxi16yq3c5p6JRG"
#   ],[
#     "EOS6FZoCJr1o6VJAB4d1hduGjb1Z1FC69jNXZ6BtvrzPbnssik5DH",
#     "5JhNVeWb8DnMwczC54PSeGBYeQgjvW4SJhVWXMXW7o4f3xh7sYk"
#   ],[
#     "EOS6MRyAjQq8ud7hVNYcfnVPJqcVpscN5So8BhtHuGYqET5GDW5CV",
#     "5KQwrPbwdL6PhXujxW37FSSQZ1JiwsST4cqQzDeyXtP79zkvFD3"
#   ],[
#     "EOS6PKZULdBo2jmsgNt7AcCHDbQj6VmMpvn9EbHHd5k2r2w3w6JEm",
#     "5JbPjHsz1WAEhcTm2RvhFxnZg9ZLPLw3znUD2NJbnmbJ1o3QB3G"
#   ],[
#     "EOS6Sc4BuA7dEGRU6u4VSuEKusESFe61qD8LmguGEMULrghKDSPaU",
#     "5K79wAY8rgPwWQSRmyQa2BR8vPicieJdLCXL3cM5Db77QnsJess"
#   ],[
#     "EOS6U2CbfrXa9hdKauZJxxbmoXACZ4MmAWHKaQPzCk5UiBmVhZRTJ",
#     "5K2L2my3qUKqj67KU61cSACoxgREkqGFi5nKaLGjbAbbRBYRq1m"
#   ],[
#     "EOS79q5YNZvFAdvNPFNw2Rvm3cdNRTSZU1TCPShaTGDZb8f2qgkqd",
#     "5JRLL41hM9T5eUHgEXyQos38Fws9hmRtKd6wckJFHT9mmqZLRps"
#   ],[
#     "EOS7qsja8UCa1ExokEb5wxCwBmJWi9aW1intH1sihNNHKoAGD6J7X",
#     "5JN8chYis1d8EYsCdDEKXyjLT3QmpW7HYoVB13dFKenK2uwyR65"
#   ],[
#     "EOS7yghCVnJHEu3TEB2nnSv1mgS5Rx8ofDyQK7C4dgbUWZCP1TtD1",
#     "5Kju7hDTh3uCZqpzb5VWAdCp7cA1fAiEd94zdNhU59WNaQMQQmE"
#   ],[
#     "EOS89PeKPVQG3f48KCX2NEg6HDW7YcoSracQMRpy46da74yi3fTLP",
#     "5JBqSZmzhvf3wopwyAwXH5g2DuNw9xdwgnTtuWLpkWP7YLtDdhp"
#   ],[
#     "EOS8hvj4KPjjGvfRfJsGEEbVvCXvAiGQ7GW345MH1r122g8Ap7xw3",
#     "5KAyefwicvJyxDaQ1riCztiSgVKiH37VV9JdSRcrqi88qQkV2gJ"
#   ]
# ]

#         password: [[
#     "EOS5NkC58kuahypYnbyYXEZvwau1KbD1rmRDJD2R61CzKaznnWH3y",
#     "5J1G4dhajiWDQduM3WSJ26vuoaMHi1AoqFLgVpazHL2aHsMkSb1"
#   ],[
#     "EOS5ek5mix7jBFNox715fDevLfvCCvv1ks1Fv57CuJYtBYTb9UqkM",
#     "5KGg63tz4CGkwoENGyhqoMaz8fnFNdqFiV8tKwepkheFdUTwxaX"
#   ],[
#     "EOS5g6Bo5jdMnhAxauxkkDKch7q4WsU7zfkxBxZoLyitgw7r6Qq9w",
#     "5JDDThPHfHXXEN4mCoZ6xSWaYeiFmMYxKWQqrKtwqcq4mQVGpRt"
#   ],[
#     "EOS63zURXSRd1Myu5ynZ7fUBiwubc3CGKTL8MGsPFVYp5YS1Py7kW",
#     "5JVGR8Tj4n8DsCiSFpEQs9YfEuMnvRyka9Qw3uzjtCkg8eSC5bQ"
#   ],[
#     "EOS664YzagGmQX9irD1rACWDLB34DKpn1W2Dju57b934p3349J8xF",
#     "5KAGbic3eXJen2nw11f6QeypyJGaNxJj3DBomPBFALERyYxe8wz"
#   ],[
#     "EOS6MRyAjQq8ud7hVNYcfnVPJqcVpscN5So8BhtHuGYqET5GDW5CV",
#     "5KQwrPbwdL6PhXujxW37FSSQZ1JiwsST4cqQzDeyXtP79zkvFD3"
#   ],[
#     "EOS6Sc4BuA7dEGRU6u4VSuEKusESFe61qD8LmguGEMULrghKDSPaU",
#     "5K79wAY8rgPwWQSRmyQa2BR8vPicieJdLCXL3cM5Db77QnsJess"
#   ],[
#     "EOS6jmPJZAPAB7hBwYxwfKiwVuqSrkSyRy2E4mjTmQ2CyYas4ESuv",
#     "5K6ZCUpk2jn1munFdiADgKgfAqcpGMHKCoJUue65p99xKX9WWCW"
#   ],[
#     "EOS7DYy6C1k35RsFD1iSKwSVNGnDwcUgtwSSpnmfzEhdrmF3pirDP",
#     "5HpauMBdvhNEribfVfiYG1jniWrg1xRoRa5RmVdfg4JywkQFPP1"
#   ],[
#     "EOS7uiCTbwNptteEUyMGjnbcsL9YezHnRnDRThSDZ8kAYzqw133v9",
#     "5JXoS35W4Ys8VGwoRc1gZqEijW3R3uf8gPKLcY5i12qngydzvnR"
#   ],[
#     "EOS8ACpi4GFsSA1RHom8TS8t5TxCjfe8J5F2PAvZrGiNb5Zhj9y2p",
#     "5JvftBQsdzygzvgX93bX62wTDzbhPvqHCEDqkyBNahnTuAi4cDA"
