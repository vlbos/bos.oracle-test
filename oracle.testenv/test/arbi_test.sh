#!/usr/bin/env bash

. env.sh
#. chains_init.sh

test_regarbitrat() {
     cleos=cleos1 && if [ "$1" == "c2" ]; then cleos=cleos2; fi
     ###=============================================== regarbitrat, ok
     ${!cleos} push action ${contract_oracle} regarbitrat '["arbitrator11", "EOS7UCx8GSeEHC4XE8jQ1R5WJqw5Vp2vZqWgQx94obFVbebnYg6eq", 1, "1.0000 BOS", "hello world"]' -p arbitrator11@active
     ${!cleos} push action ${contract_oracle} regarbitrat '["arbitrator12", "EOS7UCx8GSeEHC4XE8jQ1R5WJqw5Vp2vZqWgQx94obFVbebnYg6eq", 1, "1.0000 BOS", "hello world"]' -p arbitrator12@active
     ${!cleos} push action ${contract_oracle} regarbitrat '["arbitrator13", "EOS7UCx8GSeEHC4XE8jQ1R5WJqw5Vp2vZqWgQx94obFVbebnYg6eq", 1, "1.0000 BOS", "hello world"]' -p arbitrator13@active
     ${!cleos} push action ${contract_oracle} regarbitrat '["arbitrator14", "EOS7UCx8GSeEHC4XE8jQ1R5WJqw5Vp2vZqWgQx94obFVbebnYg6eq", 1, "1.0000 BOS", "hello world"]' -p arbitrator14@active
     ${!cleos} push action ${contract_oracle} regarbitrat '["arbitrator15", "EOS7UCx8GSeEHC4XE8jQ1R5WJqw5Vp2vZqWgQx94obFVbebnYg6eq", 1, "1.0000 BOS", "hello world"]' -p arbitrator15@active
     ${!cleos} get table ${contract_oracle} ${contract_oracle} arbitrators
}

test_regs() {
     cleos=cleos1 && if [ "$1" == "c2" ]; then cleos=cleos2; fi

     ###=============================================== regservice, ok
     ${!cleos} push action ${contract_oracle} regservice '{  "account":"provider1111", "base_stakeamount":"1000.0000 BOS", "data_format":"", "data_type":0, "criteria":"",
                          "acceptance":3, "declaration":"", "injection_method":0, "duration":1,
                          "provider_limit":3, "update_cycle":1, "update_start_time":"2019-07-29T15:27:33.216857+00:00"}' -p provider1111@active
     ${!cleos} get table ${contract_oracle} ${contract_oracle} dataservices
     ${!cleos} get table ${contract_oracle} ${contract_oracle} providers
     ${!cleos} get table ${contract_oracle} provider1111 provservices
     ${!cleos} get table ${contract_oracle} ${contract_oracle} servicestake
     ${!cleos} get table ${contract_oracle} 1 svcprovision
}

test_appeal() {
     cleos=cleos1 && if [ "$1" == "c2" ]; then cleos=cleos2; fi
     ###=============================================== appeal 申诉, ok
     # ${!cleos} push action ${contract_oracle} appeal '["appeallant1", 1, "1.0000 BOS", "appeallant1", 1]' -p appeallant1@active
     ${!cleos} get table ${contract_oracle} ${contract_oracle} appeal_request
     ${!cleos} get table ${contract_oracle} ${contract_oracle} arbitratcase
     ${!cleos} get table ${contract_oracle} ${contract_oracle} arbiprocess
}

test_respcase() {
     cleos=cleos1 && if [ "$1" == "c2" ]; then cleos=cleos2; fi
     ###=============================================== respcase 数据提供者应诉, ok
     ${!cleos} push action ${contract_oracle} respcase '["provider1111", 0, "1.0000 BOS",1]' -p provider1111@active
}

test_uploadeviden() {
     cleos=cleos1 && if [ "$1" == "c2" ]; then cleos=cleos2; fi
     ###=============================================== uploadeviden, 申诉者上传证据, ok
     ${!cleos} push action ${contract_oracle} uploadeviden '["appeallant1", 0, "evidence"]' -p appeallant1@active
}

test_reappeal() {
     cleos=cleos1 && if [ "$1" == "c2" ]; then cleos=cleos2; fi
     ###=============================================== reappeal, 数据提供者再次申诉, ok
     ${!cleos} push action ${contract_oracle} reappeal '["provider1111", 0, 0, 1, 0, true, "1.0000 BOS", 1, "再次申诉"]' -p provider1111@active
}

test_rerespcase() {
     cleos=cleos1 && if [ "$1" == "c2" ]; then cleos=cleos2; fi
     ###=============================================== rerespcase, 数据使用者再次应诉, ok
     ${!cleos} push action ${contract_oracle} rerespcase '["appeallant1", 0, 0, 0, false]' -p appeallant1@active
}

test_acceptarbi2() {
     cleos=cleos1 && if [ "$1" == "c2" ]; then cleos=cleos2; fi
     ###=============================================== acceptarbi 仲裁员应诉, ok
     ${!cleos} push action ${contract_oracle} acceptarbi '["arbitrator11", "1.0000 BOS", 0, 1]' -p arbitrator11@active
     ${!cleos} push action ${contract_oracle} acceptarbi '["arbitrator12", "1.0000 BOS", 0, 1]' -p arbitrator12@active
     ${!cleos} push action ${contract_oracle} acceptarbi '["arbitrator13", "1.0000 BOS", 0, 1]' -p arbitrator13@active
     ${!cleos} push action ${contract_oracle} acceptarbi '["arbitrator14", "1.0000 BOS", 0, 1]' -p arbitrator14@active
     ${!cleos} push action ${contract_oracle} acceptarbi '["arbitrator15", "1.0000 BOS", 0, 1]' -p arbitrator15@active
}

test_uploadeviden2() {
     cleos=cleos1 && if [ "$1" == "c2" ]; then cleos=cleos2; fi
     ###=============================================== uploadeviden, 申诉者上传证据, ok
     ${!cleos} push action ${contract_oracle} uploadeviden '["provider1111", 1, "provider1111 evidence"]' -p provider1111@active
}

test_uploadresult2() {
     cleos=cleos1 && if [ "$1" == "c2" ]; then cleos=cleos2; fi
     ###=============================================== uploadresult 仲裁员上传仲裁结果, ok
     # 数据提供者赢
     ${!cleos} push action ${contract_oracle} uploadresult '["arbitrator11", 0, 0, 1,""]' -p arbitrator11@active
     ${!cleos} push action ${contract_oracle} uploadresult '["arbitrator12", 0, 0, 1,""]' -p arbitrator12@active
     ${!cleos} push action ${contract_oracle} uploadresult '["arbitrator13", 0, 0, 1,""]' -p arbitrator13@active
}

test_reappeal2() {
     cleos=cleos1 && if [ "$1" == "c2" ]; then cleos=cleos2; fi
     ###=============================================== reappeal, 数据使用者再次申诉, ok
     ${!cleos} push action ${contract_oracle} reappeal '["appeallant1", 0, 0, 1, 1, false, "1.0000 BOS", 1, "数据使用者不服, 再次申诉"]' -p appeallant1@active
}

test_rerespcase2() {
     cleos=cleos1 && if [ "$1" == "c2" ]; then cleos=cleos2; fi
     ###=============================================== rerespcase, 数据提供者再次应诉, ok
     ${!cleos} push action ${contract_oracle} rerespcase '["provider1111", 0, 0, 1, true]' -p appeallant1@active
}

ACCOUNTS=("arbitrator11" "arbitrator31" "arbitrator53")

test_acceptarbi() {
     cleos=cleos1 && if [ "$1" == "c2" ]; then cleos=cleos2; fi
     ###=============================================== acceptarbi 仲裁员应诉, ok
     # ${!cleos} push action ${contract_oracle} acceptarbi '["arbitrator45", 1]' -p arbitrator45@active
     # ${!cleos} push action ${contract_oracle} acceptarbi '["arbitrator12", 1]' -p arbitrator12@active
     # ${!cleos} push action ${contract_oracle} acceptarbi '["arbitrator52", 1]' -p arbitrator13@active

     for account in ${ACCOUNTS[*]}; do
          ${!cleos} push action ${contract_oracle} acceptarbi '["'$account'", 1]' -p $account@active
          sleep 1
     done

}

test_uploadresult() {
     cleos=cleos1 && if [ "$1" == "c2" ]; then cleos=cleos2; fi
     ###=============================================== uploadresult 仲裁员上传仲裁结果, ok
     # 数据使用者赢
     # ${!cleos} push action ${contract_oracle} uploadresult '["arbitrator14", 0, 1, 0,""]' -p arbitrator14@active
     # ${!cleos} push action ${contract_oracle} uploadresult '["arbitrator23", 0, 1, 0,""]' -p arbitrator23@active
     # ${!cleos} push action ${contract_oracle} uploadresult '["arbitrator31", 0, 1, 0,""]' -p arbitrator31@active

     for account in ${ACCOUNTS[*]}; do
          ${!cleos} push action ${contract_oracle} uploadresult '["'${account}'", 1, 1,"comment:"'${account}']' -p ${account}@active
          sleep 1
     done

}

test_timer() {
     cleos=cleos1 && if [ "$1" == "c2" ]; then cleos=cleos2; fi
     ###=============================================== uploadresult 仲裁员上传仲裁结果, ok
     # 数据提供者赢
     ${!cleos} push action ${contract_oracle} timertimeout '[1, 1, 1]' -p ${contract_oracle}@active
}

test_arbi() {
     cleos=cleos1 && if [ "$1" == "c2" ]; then cleos=cleos2; fi

     ${!cleos} get scope ${contract_oracle}
     ${!cleos} get table ${contract_oracle} 1 arbicase --limit 10
     ${!cleos} get table ${contract_oracle} 1 arbiprocess
}

transfer_appeal() {
     echo --- cleos1 transfer 3---

     cleos=cleos1 && if [ "$1" == "c2" ]; then cleos=cleos2; fi

     #appeal
     ${!cleos} transfer appeallant11 ${contract_oracle} "200.0000 BOS" "3,1,'evidence','info','reason',0" -p appeallant11
}

transfer_regarbi() {
     echo --- cleos1 transfer 3---

     cleos=cleos1 && if [ "$1" == "c2" ]; then cleos=cleos2; fi

     #arbitrator
     # ${!cleos}  transfer consumer2222 ${contract_oracle} "0.0001 BOS" "4,1" -p consumer2222

     for i in {1..5}; do
          for j in {1..5}; do
               account='arbitrator'${i}${j}
               ${!cleos} transfer ${account} ${contract_oracle} "10000.0000 BOS" "4,1" -p ${account}
               sleep 1
          done
     done

     for j in {1..5}; do
        account="arbitrators"${j}
        ${!cleos} transfer ${account} ${contract_oracle} "10000.0000 BOS" "4,1" -p ${account}
        sleep 1
    done
    
     ${!cleos} get table ${contract_oracle} ${contract_oracle} arbitrators
}

transfer_respcase() {
     echo --- cleos1 transfer 3---

     cleos=cleos1 && if [ "$1" == "c2" ]; then cleos=cleos2; fi

     #resp_case
     ${!cleos} transfer provider1111 ${contract_oracle} "200.0000 BOS" "5,1,''" -p provider1111
}

case "$1" in
"regs") test_regs ;;
"rega") transfer_regarbi ;;
"appeal") transfer_appeal ;;
"resp") transfer_respcase ;;
"acc") test_acceptarbi ;;
"upre") test_uploadresult ;;
"upev") test_uploadeviden ;;
"arbi") test_arbi ;;
"timer") test_timer ;;
*) echo "usage: rega|appeal|resp|acc||upreupev" ;;
esac

arbi() {
     cleos=cleos1 && if [ "$1" == "c2" ]; then cleos=cleos2; fi

     # Private key: 5JNzcBuxPGmF3Saw3cedYzE6jL7VksFayxqpjokMTRpARkCwmHa
     # Public key: EOS7UCx8GSeEHC4XE8jQ1R5WJqw5Vp2vZqWgQx94obFVbebnYg6eq

     # PUBKEY=EOS7UCx8GSeEHC4XE8jQ1R5WJqw5Vp2vZqWgQx94obFVbebnYg6eq

     # ###=============================================== 创建账号

     # EOS_TOKEN=eosio.token
     # ################################################################## 发币
     # cleos set contract $EOS_TOKEN /bos.contracts/build/contracts/eosio.token -p $EOS_TOKEN@active
     # cleos push action $EOS_TOKEN create '[ "eosio.token", "10000000000.0000 BOS", 0, 0, 0]' -p $EOS_TOKEN
     # cleos push action $EOS_TOKEN issue '["eosio.token", "1000000000.0000 BOS", ""]' -p $EOS_TOKEN

     # ###=============================================== 部署合约
     # EOS_ORACLE=bos.oracle
     # cleos set contract ${contract_oracle} /bos.contracts/contracts/bos.oracle -p ${contract_oracle}
     # ###=============================================== set permission
     # cleos set account permission ${contract_oracle} active '{"threshold": 1,"keys": [{"key": "EOS7UCx8GSeEHC4XE8jQ1R5WJqw5Vp2vZqWgQx94obFVbebnYg6eq","weight": 1}],"accounts": [{"permission":{"actor":"bos.oracle","permission":"eosio.code"},"weight":1}]}' -p ${contract_oracle}@active

     # TODO: 测试大众仲裁人数不够

     ${!cleos} get table ${contract_oracle} 1 arbicase
     ${!cleos} get table ${contract_oracle} 1 arbiprocess
     # cleos get table ${contract_oracle} ${contract_oracle} arbiresults

     # ###=============================================== Tables
     # cleos get table ${contract_oracle} ${contract_oracle} arbitrators
     # cleos get table ${contract_oracle} ${contract_oracle} appealreq
     # cleos get table ${contract_oracle} ${contract_oracle} arbievidence
     # cleos get table ${contract_oracle} ${contract_oracle} fairawards
     # cleos get table ${contract_oracle} ${contract_oracle} arbistakeacc
     # cleos get table ${contract_oracle} ${contract_oracle} arbistakes
     # cleos get table ${contract_oracle} ${contract_oracle} arbiincomes
     # cleos get table ${contract_oracle} ${contract_oracle} dataservices
     # cleos get table ${contract_oracle} 0 svcprovision

}
