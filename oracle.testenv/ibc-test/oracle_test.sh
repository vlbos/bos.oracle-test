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

list_pri_key1()
{
     cleos=cleos1 && if [ "$1" == "c2" ];then cleos=cleos2 ;fi
${!cleos} wallet private_keys
}

# list_pri_key1

init_contracts1(){
    cleos=cleos1 && if [ "$1" == "c2" ];then cleos=cleos2 ;fi

    # # ${!cleos} set account permission ${contract_token} active '{"threshold": 1, "keys":[{"key":"'${token_c_pubkey}'", "weight":1}], "accounts":[{"permission":{"actor":"'${contract_token}'","permission":"eosio.code"},"weight":1}], "waits":[] }' owner -p ${contract_token}

    # # --- ibc.chain ---  --print-request --print-response 
    # # cleos push action delphioracle write '{"owner":"acryptotitan", "value":58500}' -p acryptotitan@active
    # ${!cleos}  push action  ${contract_oracle} write '{"owner":"eosio", "value":58500}' -p eosio@active


    # ${!cleos}  push action  ${contract_oraclize} addoracle '{"oracle":"oracleoracle"}' -p ${contract_oraclize}@active

    # get_account ${contract_oraclized}
    # ${!cleos} set account permission eosio active '{"threshold": 1,"keys": [{"key": "EOS6MRyAjQq8ud7hVNYcfnVPJqcVpscN5So8BhtHuGYqET5GDW5CV","weight": 1}],"accounts": [{"permission":{"actor":"'${contract_oraclized}'","permission":"eosio.code"},"weight":1}]}' owner -p eosio

    # ${!cleos} set account permission ${contract_oraclize}  active '{"threshold": 1,"keys": [{"key": "EOS7dUuGNbsh4x1kgv7vMrkgEDxKFwuGjZpixkjQrQGqJqwxpriSM","weight": 1}],"accounts": [{"permission":{"actor":"'${contract_oraclized}'","permission":"eosio.code"},"weight":1}]}' owner -p ${contract_oraclize} 
        # owner     1:    1 EOS7ZrkZFcZqzr2rxb2EV7xLeR1YRGcgfG3wwgPJfcf6dbaYCpoym
        # active     1:    1 EOS7ZrkZFcZqzr2rxb2EV7xLeR1YRGcgfG3wwgPJfcf6dbaYCpoym

    # ${!cleos} set account permission ${contract_oraclized}  active '{"threshold": 1,"keys": [{"key": "EOS7uiCTbwNptteEUyMGjnbcsL9YezHnRnDRThSDZ8kAYzqw13","weight": 1}],"accounts": [{"permission":{"actor":"'${contract_oraclize}'","permission":"eosio.code"},"weight":1}],"waits":[{"wait_sec":0,"weight":1}]}' owner -p ${contract_oraclized}@owner

    # ${!cleos}  set account permission ${contract_oraclized}  active '{"threshold": 1,"keys": [{"key": "EOS89PeKPVQG3f48KCX2NEg6HDW7YcoSracQMRpy46da74yi3fTLP","weight": 1}],"accounts": [{"permission":{"actor":"'${contract_oraclized}'","permission":"eosio.code"},"weight":1}]}' owner -p ${contract_oraclized}@owner

    #  transfer
    # echo ===setup
    # ${!cleos} push action ${contract_oraclized} setup '{"oracle":"'${contract_oraclize}'"}' -p ${contract_oraclized} 
    # echo ===setupend

    ${!cleos}  push action  ${contract_oraclize} disable '{"administrator":"oracle444444","contract":"oracle444444","task":"c0fe86756e446503eed0d3c6a9be9e6276018fead3cd038932cf9cc2b661d9de","memo":""}' -p oracle444444@active

    # echo ===push
    # ${!cleos}  push action  ${contract_oraclize} push '{"oracle":"oracleoracle","contract":"bosoraclebos","task":"c0fe86756e446503eed0d3c6a9be9e6276018fead3cd038932cf9cc2b661d9de","memo":"","data":""}' -p oracleoracle@active
}
# init_contracts1 c1

get_oracle_table(){
    cleos=cleos1 && if [ "$1" == "c2" ];then cleos=cleos2 ;fi


    #cleos get table ${contract_token} ${contract_token} globals
    ${!cleos} get table ${contract_oracle} ${contract_oracle} eosusd --limit 1

     ${!cleos} get table ${contract_oraclize} ${contract_oraclize} request --limit 1

 ${!cleos} get table ${contract_oraclized} ${contract_oraclized} ethbtc --limit 1
}

get_oracle_table c1


get_oracle_info(){
    cleos=cleos1 && if [ "$1" == "c2" ];then cleos=cleos2 ;fi


    #cleos get table ${contract_token} ${contract_token} globals
    ${!cleos} get info 

}

# get_oracle_info c1

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
#     $cleos1 get currency balance eosio.token testblklist1 "EOS"
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
#     $cleos1 transfer  testblklist2 ibc2token555 "0.0001 EOS"  -p testblklist2
#     $cleos2 transfer  testblklist2 ibc2token555 "0.0001 BOS" "ibc receiver=chengsong111" -p testblklist2
# }



# transfer(){
#     echo --- cleos2 transfer ---
#     $cleos1 transfer  testblklist1 testblklist2 "10.0000 EOS"  -p testblklist1
#     $cleos2 transfer  testblklist1 testblklist2 "10.0000 BOS" "ibc receiver=chengsong111" -p testblklist1
# }

# # transfer

# transferonchainblacklist(){
#     echo --- cleos3 transfer ---
#     $cleos1 transfer  testblklist3 testblklist2 "10.0000 EOS"  -p testblklist3
#     $cleos2 transfer  testblklist3 testblklist2 "10.0000 BOS" "" -p testblklist3
# }
# # transferonchainblacklist


# withdraw(){
#     $cleos1 push action -f ibc2token555 transfer '["chengsong111","ibc2token555","10.0000 BOSPG" "ibc receiver=receiverbos1"]' -p chengsong111
#     $cleos2 push action -f ibc2token555 transfer '["chengsong111","ibc2token555","10.0000 EOSPG" "ibc receiver=receivereos1"]' -p chengsong111
# }

# transfer_fail(){
#     $cleos1 transfer -f firstaccount ibc2token555 "10.0000 EOS" "ibc receiver=chengsong123" -p firstaccount
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

