#!/usr/bin/env bash

. env.sh
#. chains_init.sh


set_contracts(){
    cleos=cleos1 && if [ "$1" == "c2" ];then cleos=cleos2 ;fi
    ${!cleos} set contract ${contract_oracle} ${CONTRACTS_DIR}/${contract_oracle_folder} -x 1000 -p ${contract_oracle}
    sleep .2
    # ${!cleos} set contract ${contract_oracle} ${CONTRACTS_DIR}/${contract_oraclize_folder} -x 1000 -p ${contract_oracle}
    # sleep .2
    ${!cleos}  set contract ${contract_consumer} ${CONTRACTS_DIR}/${contract_consumer_folder} -x 1000 -p ${contract_consumer}@active
    sleep .2
}

test_set_contracts(){
set_contracts c1
# set_contracts c2
}

init_contracts(){
    cleos=cleos1 && if [ "$1" == "c2" ];then cleos=cleos2 ;fi

    # ${!cleos} set account permission ${contract_token} active '{"threshold": 1, "keys":[{"key":"'${token_c_pubkey}'", "weight":1}], "accounts":[{"permission":{"actor":"'${contract_token}'","permission":"eosio.code"},"weight":1}],"waits":[{"wait_sec":0,"weight":1}] }' owner -p ${contract_token}

    # --- ibc.chain ---
    # cleos push action delphioracle write '{"owner":"acryptotitan", "value":58500}' -p acryptotitan@active
    ${!cleos}  push action  ${contract_oracle} write '{"owner":"eosio", "value":58500}' -p eosio@active


    ${!cleos}  push action  ${contract_oracle} addoracle '{"oracle":"oracleoracle"}' -p ${contract_oracle}@active

    # echo ===setup
    # ${!cleos}  push action  ${contract_consumer} setup '{"master":"oraclize1111"}' -p ${contract_consumer}@active
 
    # # ${!cleos} set account permission ${contract_token} active '{"threshold": 1, "keys":[{"key":"'${token_c_pubkey}'", "weight":1}], "accounts":[{"permission":{"actor":"'${contract_token}'","permission":"eosio.code"},"weight":1}], "waits":[] }' owner -p ${contract_token}

    # # --- ibc.chain ---  --print-request --print-response 
    # # cleos push action delphioracle write '{"owner":"acryptotitan", "value":58500}' -p acryptotitan@active
    # ${!cleos}  push action  ${contract_oracle} write '{"owner":"eosio", "value":58500}' -p eosio@active


    # ${!cleos}  push action  ${contract_oracle} addoracle '{"oracle":"oracleoracle"}' -p ${contract_oracle}@active

    # get_account ${contract_consumer}
    # ${!cleos} set account permission eosio active '{"threshold": 1,"keys": [{"key": "EOS6MRyAjQq8ud7hVNYcfnVPJqcVpscN5So8BhtHuGYqET5GDW5CV","weight": 1}],"accounts": [{"permission":{"actor":"'${contract_consumer}'","permission":"eosio.code"},"weight":1}]}' owner -p eosio

    # ${!cleos} set account permission ${contract_oracle}  active '{"threshold": 1,"keys": [{"key": "EOS7dUuGNbsh4x1kgv7vMrkgEDxKFwuGjZpixkjQrQGqJqwxpriSM","weight": 1}],"accounts": [{"permission":{"actor":"'${contract_consumer}'","permission":"eosio.code"},"weight":1}]}' owner -p ${contract_oracle} 
        # owner     1:    1 EOS7ZrkZFcZqzr2rxb2EV7xLeR1YRGcgfG3wwgPJfcf6dbaYCpoym
        # active     1:    1 EOS7ZrkZFcZqzr2rxb2EV7xLeR1YRGcgfG3wwgPJfcf6dbaYCpoym

    # ${!cleos} set account permission ${contract_consumer}  active '{"threshold": 1,"keys": [{"key": "EOS7uiCTbwNptteEUyMGjnbcsL9YezHnRnDRThSDZ8kAYzqw13","weight": 1}],"accounts": [{"permission":{"actor":"'${contract_oracle}'","permission":"eosio.code"},"weight":1}],"waits":[{"wait_sec":0,"weight":1}]}' owner -p ${contract_consumer}@owner

    ${!cleos}  set account permission ${contract_consumer}  active '{"threshold": 1,"keys": [{"key": "'${consumer_c_pubkey}'","weight": 1}],"accounts": [{"permission":{"actor":"'${contract_consumer}'","permission":"eosio.code"},"weight":1}]}' owner -p ${contract_consumer}@owner

    #  transfer
    echo ===setup
    ${!cleos} push action ${contract_consumer} setup '{"oracle":"'${contract_oracle}'"}' -p ${contract_consumer} 
    echo ===setup end
  
    echo ===push
    ${!cleos}  push action  ${contract_oracle} push '{"oracle":"oracleoracle","contract":"'${contract_consumer}'","task":"c0fe86756e446503eed0d3c6a9be9e6276018fead3cd038932cf9cc2b661d9de","memo":"","data":""}' -p oracleoracle@active

    # ${!cleos}  push action  ${contract_oracle} disable '{"administrator":"consumer123","contract":"consumer123","task":"c0fe86756e446503eed0d3c6a9be9e6276018fead3cd038932cf9cc2b661d9de","memo":""}' -p ${contract_consumer}@active
}
test_write()
{
cleos=cleos1 && if [ "$1" == "c2" ];then cleos=cleos2 ;fi

    ${!cleos}  push action  ${contract_oracle} write '{"owner":"eosio", "value":58500}' -p eosio@active
}
test_add()
{
cleos=cleos1 && if [ "$1" == "c2" ];then cleos=cleos2 ;fi

    
    ${!cleos}  push action  ${contract_oracle} addoracle '{"oracle":"oracleoracle"}' -p ${contract_oracle}@active
}

test_setup()
{
cleos=cleos1 && if [ "$1" == "c2" ];then cleos=cleos2 ;fi
 ${!cleos}  set account permission ${contract_consumer}  active '{"threshold": 1,"keys": [{"key": "'${consumer_c_pubkey}'","weight": 1}],"accounts": [{"permission":{"actor":"'${contract_consumer}'","permission":"eosio.code"},"weight":1}]}' owner -p ${contract_consumer}@owner

    #  transfer
    echo ===setup
    ${!cleos} push action ${contract_consumer} setup '{"oracle":"'${contract_oracle}'"}' -p ${contract_consumer} 
    echo ===setup end
}

test_push()
{
cleos=cleos1 && if [ "$1" == "c2" ];then cleos=cleos2 ;fi

      echo ===push
    ${!cleos}  push action  ${contract_oracle} push '{"oracle":"oracleoracle","contract":"'${contract_consumer}'","task":"c0fe86756e446503eed0d3c6a9be9e6276018fead3cd038932cf9cc2b661d9de","memo":"","data":""}' -p oracleoracle@active
}

test_disable()
{
cleos=cleos1 && if [ "$1" == "c2" ];then cleos=cleos2 ;fi

    ${!cleos}  push action  ${contract_oracle} disable '{"administrator":"consumer123","contract":"consumer123","task":"c0fe86756e446503eed0d3c6a9be9e6276018fead3cd038932cf9cc2b661d9de","memo":""}' -p ${contract_consumer}@active
}

test_init_contracts(){
    case "$1"
in
    "write"  )   test_write c1;;
    "add" )   test_add c1;;
    "setup"  )   test_setup c1;;
    "push")   test_push c1;;
    "disable" )   test_disable c1;;
    *) echo "usage: init write|add|setup|push|disable" ;;
esac
 
# init_contracts c2
}

get_account(){
    echo --- cleos1 ---  $1
    $cleos1 get account  $1
    # echo && echo --- cleos2 ---  $1
    # $cleos2 get account  $1
}
test_get_account(){
    get_account oraclize1111
    get_account bosbosoracle
    get_account ${contract_oracle}
}

transfer(){
    echo --- cleos2 transfer ---
    $cleos1 transfer  ${contract_consumer} ${contract_oracle} "10.0000 BOS"  -p ${contract_consumer}
    # $cleos2 transfer  testblklist1 testblklist2 "10.0000 BOS" "ibc receiver=chengsong111" -p testblklist1
}

# test_transfer()
# {}

pwd = 'cat /Users/lisheng/eosio-wallet/password.txt'

test_list_pri_key()
{
     cleos=cleos1 && if [ "$1" == "c2" ];then cleos=cleos2 ;fi
${!cleos} wallet private_keys --password PW5JhG3FdGXSc2RTXRNC2tDrd4KhudMA1BggF9QvxJ6YUL4ktUh4k
}

get_oracle_table(){
    cleos=cleos1 && if [ "$1" == "c2" ];then cleos=cleos2 ;fi


    #cleos get table ${contract_token} ${contract_token} globals
    echo ==eosusd
    ${!cleos} get table ${contract_oracle} ${contract_oracle} eosusd --limit 1
echo == request
     ${!cleos} get table ${contract_oracle} ${contract_oracle} request --limit 1
echo ==ethbtc
 ${!cleos} get table ${contract_consumer} ${contract_consumer} ethbtc --limit 1
}

test_get_table(){
    get_oracle_table c1
}


get_info(){
    cleos=cleos1 && if [ "$1" == "c2" ];then cleos=cleos2 ;fi

    #cleos get table ${contract_token} ${contract_token} globals
    ${!cleos} get info 

}
get_scope(){
    cleos=cleos1 && if [ "$1" == "c2" ];then cleos=cleos2 ;fi

    #cleos get table ${contract_token} ${contract_token} globals
    ${!cleos} get scope  -t stat eosio.token

}

test_get_scope()
{
get_scope c1
}

test_get_info()
{
get_info c1
}


# init_two(){
#     $cleos1 push action eosio namelist '{"list":"actor_blacklist","action":"insert","names":["testblklist1"]}' -p eosio
#     $cleos2 push action eosio namelist '{"list":"actor_blacklist","action":"insert","names":["testblklist1"]}' -p eosio
# }
# init_two

# init_tokenblacklist(){
#     $cleos1 push action eosio.token addblacklist '{"accounts":["testblklist3"]}' -p eosio
#     echo ==bos===
#     $cleos2 push action eosio.token addblacklist '{"accounts":["testblklist3"]}' -p eosio
# }
# init_tokenblacklist

# init_tokenblacklist(){
#     $cleos1 push action eosio.token addblacklist '{"accounts":['jpplkzbqyytu','xfberzchadgm','maxjxidiptdc','csfvjyaheifd','aknadweglyze','ykvmonifsosf','xcdqadmfhduo','ncddutieotop','bwhhsckfdbtf','ijkuxkdobjze','gjtzjaifiytf','wbbldrmepomg','vbbpphqeedoh','ttjcjfmdltii','rlrgvvqcaibj','plzkplvbhydk','tamhnrdadbhg','jsmlzqazkrah','isuqtgeyrhui','gkccfwixgwwj']}' -p eosio
#     $cleos1 push action eosio.token addblacklist '{"accounts":['iwgsifdakshl','hooeuvizzijm','nikjzdbioqgk','lasvlufzvfil','kaazfkjykvcm','isimragxrlvn','ysqqlykxgaxo','wkqcxoowoqrp','ucyhjfsvvfsq','bxctonmwsvqo','zxkyadqvzlsp','xpskuuuugalq','opsogsquvqfr','mhataiutcghs','kzifmyzsrvat','rtmkrhsthdgr','xoixopucwlmh','woqbigybdbfq','ugynuwubsqzr','sygromyszgbs']}' -p eosio
#     $cleos1 push action eosio.token addblacklist '{"accounts":['iyoeakcrovut','xskjflwaddaj','nksvrjazktts','lcazlzeyaivt','jcilxpiyhypu','iuqqjgfponiv','gurcdejoddkw','wmzgpunnktex','umhljkjmzixy','bzkxgtlvoqdw','zztcajpnvgfx','xrtomzlmlvyy','wrbsgxplslsz','mijfsotkzaua','karjeeyjoqnb','iazvycujvghc','pvvaddvkkona','nndmptajzdob','lnlrbrwigtic','cftdvhahoicd']}' -p eosio
#     $cleos1 push action eosio.token addblacklist '{"accounts":['axbhhyegdyde','yxbmbwigknxf','wpjynmffzdro','djnlsmggolwe','bjvpelkfvayf','zbdtybgekqsg','qtdgkrlerglh','otlkwppdzvni','mltwqgtcolgr','klbbcwpbvaas','bdjnwmtakqct','pyfstvvbzyhj','fqnenlrbgnbk','eqvizjvavdvt','cidvtzzzctwu','aalzfpwykiqv','frznhtslpjey','drhrtrokeyfz','ujpdnhsjloza','sjxizxwjaetb']}' -p eosio
#     $cleos1 push action eosio.token addblacklist '{"accounts":['qbfusntihtuk','tnbknwwklhgl','rfjohmsjaxim','xanbfvukpnfc','wsvfzlykwchd','usvrljujlsbm','kkdweayishun','ikliqqchixwo','gctmcghgpnpp','fuczwedfwcrq','loxecfehtkpo','kofqodigaaqp','agnuztffhpkq','ygwgtjjewfer','wyelfanddufs','tnvywseobvpf','aizdbbfpydnv','wfyqkuwavdwj','vxhcekazctys','lpphqixzrist']}' -p eosio

#     echo ==bos===
#     $cleos2 push action eosio.token addblacklist '{"accounts":['jpplkzbqyytu','xfberzchadgm','maxjxidiptdc','csfvjyaheifd','aknadweglyze','ykvmonifsosf','xcdqadmfhduo','ncddutieotop','bwhhsckfdbtf','ijkuxkdobjze','gjtzjaifiytf','wbbldrmepomg','vbbpphqeedoh','ttjcjfmdltii','rlrgvvqcaibj','plzkplvbhydk','tamhnrdadbhg','jsmlzqazkrah','isuqtgeyrhui','gkccfwixgwwj']}' -p eosio
#     $cleos2 push action eosio.token addblacklist '{"accounts":['iwgsifdakshl','hooeuvizzijm','nikjzdbioqgk','lasvlufzvfil','kaazfkjykvcm','isimragxrlvn','ysqqlykxgaxo','wkqcxoowoqrp','ucyhjfsvvfsq','bxctonmwsvqo','zxkyadqvzlsp','xpskuuuugalq','opsogsquvqfr','mhataiutcghs','kzifmyzsrvat','rtmkrhsthdgr','xoixopucwlmh','woqbigybdbfq','ugynuwubsqzr','sygromyszgbs']}' -p eosio
#     $cleos2 push action eosio.token addblacklist '{"accounts":['iyoeakcrovut','xskjflwaddaj','nksvrjazktts','lcazlzeyaivt','jcilxpiyhypu','iuqqjgfponiv','gurcdejoddkw','wmzgpunnktex','umhljkjmzixy','bzkxgtlvoqdw','zztcajpnvgfx','xrtomzlmlvyy','wrbsgxplslsz','mijfsotkzaua','karjeeyjoqnb','iazvycujvghc','pvvaddvkkona','nndmptajzdob','lnlrbrwigtic','cftdvhahoicd']}' -p eosio
#     $cleos2 push action eosio.token addblacklist '{"accounts":['axbhhyegdyde','yxbmbwigknxf','wpjynmffzdro','djnlsmggolwe','bjvpelkfvayf','zbdtybgekqsg','qtdgkrlerglh','otlkwppdzvni','mltwqgtcolgr','klbbcwpbvaas','bdjnwmtakqct','pyfstvvbzyhj','fqnenlrbgnbk','eqvizjvavdvt','cidvtzzzctwu','aalzfpwykiqv','frznhtslpjey','drhrtrokeyfz','ujpdnhsjloza','sjxizxwjaetb']}' -p eosio
#     $cleos2 push action eosio.token addblacklist '{"accounts":['qbfusntihtuk','tnbknwwklhgl','rfjohmsjaxim','xanbfvukpnfc','wsvfzlykwchd','usvrljujlsbm','kkdweayishun','ikliqqchixwo','gctmcghgpnpp','fuczwedfwcrq','loxecfehtkpo','kofqodigaaqp','agnuztffhpkq','ygwgtjjewfer','wyelfanddufs','tnvywseobvpf','aizdbbfpydnv','wfyqkuwavdwj','vxhcekazctys','lpphqixzrist']}' -p eosio

# }
# init_tokenblacklist

# # return

# get_chain_table(){
#     echo --- cleos1 ---
#     $cleos1 get table ${contract_oracle} ${contract_oracle} $1
#     echo && echo --- cleos2 ---
#     $cleos2 get table ${contract_oracle} ${contract_oracle} $1
# }

# get_token_table(){
#     echo --- cleos1 ---
#     $cleos1 get table ${contract_token} ${contract_token} $1
#     echo && echo --- cleos2 ---
#     $cleos2 get table ${contract_token} ${contract_token} $1
# }

# #    get_chain_table sections
# #    get_chain_table prodsches
# #    get_chain_table chaindb
# #    get_token_table globals
# #    get_token_table globalm
# #    get_token_table origtrxs
# #    get_token_table cashtrxs


# # get_balance(){
# #     $cleos2 get table eosio $1 account
# #     # $cleos2 get table ibc2token555 $1 accounts
# # }
# # get_balance ibc2chain555
# #    get_balance chengsong111

# get_receiver_b(){
#     echo --- cleos1 currency balance  ---
#     $cleos1 get currency balance eosio.token testblklist1 "BOS"
#     $cleos2 get currency balance eosio.token testblklist1 "BOS"
# }
# get_receiver_b


# get_account(){
#     echo --- cleos1 ---  $1
#     $cleos1 get account  $1
#     echo && echo --- cleos2 ---  $1
#     $cleos2 get account  $1
# }
# get_account testblklist1
# # get_account ibc2token555
# # get_account ibc2chain555
# get_account testblklist2


# transfernormal(){
#     echo --- cleosn transfer ---
#     $cleos1 transfer  testblklist2 ibc2token555 "0.0001 BOS"  -p testblklist2
#     $cleos2 transfer  testblklist2 ibc2token555 "0.0001 BOS" "ibc receiver=chengsong111" -p testblklist2
# }



# transfer(){
#     echo --- cleos2 transfer ---
#     $cleos1 transfer  testblklist1 testblklist2 "10.0000 BOS"  -p testblklist1
#     $cleos2 transfer  testblklist1 testblklist2 "10.0000 BOS" "ibc receiver=chengsong111" -p testblklist1
# }

# # transfer

# transferonchainblacklist(){
#     echo --- cleos3 transfer ---
#     $cleos1 transfer  testblklist3 testblklist2 "10.0000 BOS"  -p testblklist3
#     $cleos2 transfer  testblklist3 testblklist2 "10.0000 BOS" "" -p testblklist3
# }
# # transferonchainblacklist


# withdraw(){
#     $cleos1 push action -f ibc2token555 transfer '["chengsong111","ibc2token555","10.0000 BOSPG" "ibc receiver=receiverbos1"]' -p chengsong111
#     $cleos2 push action -f ibc2token555 transfer '["chengsong111","ibc2token555","10.0000 EOSPG" "ibc receiver=receivereos1"]' -p chengsong111
# }

# transfer_fail(){
#     $cleos1 transfer -f firstaccount ibc2token555 "10.0000 BOS" "ibc receiver=chengsong123" -p firstaccount
#     $cleos2 transfer -f firstaccount ibc2token555 "10.0000 BOS" "ibc receiver=chengsong123" -p firstaccount
# }

# withdraw_fail(){
#     $cleos1 push action -f ibc2token555 transfer '["chengsong111","ibc2token555","10.0000 BOSPG" "ibc receiver=receiver1111"]' -p chengsong111
#     $cleos2 push action -f ibc2token555 transfer '["chengsong111","ibc2token555","10.0000 EOSPG" "ibc receiver=receiver1111"]' -p chengsong111
# }


# once(){
#     for i in `seq 1`; do transfernormal && sleep .2 ;done
# #     for i in `seq 10`; do withdraw && sleep .2 ;done
# #     for i in `seq 2`; do transfer_fail && sleep .2 ;done
# #     for i in `seq 2`; do transfer_fail && sleep .2 ;done
#  }

# once
# get_account testblklist2


# # for i in `seq 10000`; do transfer && withdraw &&          sleep .5 ;done


# pressure(){
#     for i in `seq 10000`; do transfer && sleep .5 ;done
#     for i in `seq 10000`; do withdraw && sleep .5 ;done

#      $cleos1 get table ibc2chain555 ibc2chain555 chaindb -L 9000 |less





# }

# huge_pressure(){

#     for i in `seq 200`; do withdraw  ; done >/dev/null 2>&1  &

# }




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

case "$1"
in
    "set"  )   test_set_contracts;;
    "init" )   test_init_contracts "$2";;
    "acc"  )   test_get_account;;
    "transfer")   test_transfer;;
    "keys" )   test_list_pri_key;;
    "table"  )   test_get_table;;
    "info"  )   test_get_info;;
    "scope"  )   test_get_scope;;
    *) echo "usage: oracle_test.sh set|init|acc|transfer|keys|table|info" ;;
esac