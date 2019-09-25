#!/usr/bin/env bash

# contract_repo_dir=ibc/eosio.contracts  /Users/lisheng/abos/bos.contract-prebuild
# contract_repo_dir=bos.contract-prebuild
contract_repo_dir=bos.contracts

# CONTRACTS_DIR=/Users/lisheng/${contract_repo_dir}/build/contracts/
CONTRACTS_DIR=/Users/lisheng/mygit/vlbos/oracle/${contract_repo_dir}/build/contracts/
# CONTRACTS_DIR=/Users/lisheng/abos/${contract_repo_dir}
WALLET_DIR=/Users/lisheng/eosio-wallet

cleos1='cleos -u http://127.0.0.1:8888'
cleos2='cleos -u http://127.0.0.1:8889'

contract_oracle=oraclebosbos
contract_oracle_folder=bos.oracle

contract_consumer=consumer1234
contract_consumer_folder=consumer.contract

contract_ocbc=consumer5555
contract_consumer_folder=ocbc

oraclize_c_pubkey=EOS6FZoCJr1o6VJAB4d1hduGjb1Z1FC69jNXZ6BtvrzPbnssik5DH
oraclize_c_prikey=5JhNVeWb8DnMwczC54PSeGBYeQgjvW4SJhVWXMXW7o4f3xh7sYk

consumer_c_pubkey=EOS89PeKPVQG3f48KCX2NEg6HDW7YcoSracQMRpy46da74yi3fTLP
consumer_c_prikey=5JBqSZmzhvf3wopwyAwXH5g2DuNw9xdwgnTtuWLpkWP7YLtDdhp

oracle_c_pubkey=EOS547kdHMjA9zrpYtPBW4ixZ4g3K4KGqp1GXyzyxx7ugPrvwHjhe
oracle_c_prikey=5JCtWxuqPzcPUfFukj58q8TqyRJ7asGnhSYvvxi16yq3c5p6JRG

oracleoracle_c_pubkey=EOS6Sc4BuA7dEGRU6u4VSuEKusESFe61qD8LmguGEMULrghKDSPaU
oracleoracle_c_prikey=5K79wAY8rgPwWQSRmyQa2BR8vPicieJdLCXL3cM5Db77QnsJess

# [[

provider_pubkeys=(
  "EOS6U2CbfrXa9hdKauZJxxbmoXACZ4MmAWHKaQPzCk5UiBmVhZRTJ" "EOS7qsja8UCa1ExokEb5wxCwBmJWi9aW1intH1sihNNHKoAGD6J7X" "EOS7yghCVnJHEu3TEB2nnSv1mgS5Rx8ofDyQK7C4dgbUWZCP1TtD1" "EOS6jmPJZAPAB7hBwYxwfKiwVuqSrkSyRy2E4mjTmQ2CyYas4ESuv" "EOS8hvj4KPjjGvfRfJsGEEbVvCXvAiGQ7GW345MH1r122g8Ap7xw3"
)

provider_prikeys=(
  "5K2L2my3qUKqj67KU61cSACoxgREkqGFi5nKaLGjbAbbRBYRq1m" "5JN8chYis1d8EYsCdDEKXyjLT3QmpW7HYoVB13dFKenK2uwyR65" "5Kju7hDTh3uCZqpzb5VWAdCp7cA1fAiEd94zdNhU59WNaQMQQmE" "5K6ZCUpk2jn1munFdiADgKgfAqcpGMHKCoJUue65p99xKX9WWCW" "5KAyefwicvJyxDaQ1riCztiSgVKiH37VV9JdSRcrqi88qQkV2gJ"
)

# #   ],[
# provider1111_pubkey=EOS6U2CbfrXa9hdKauZJxxbmoXACZ4MmAWHKaQPzCk5UiBmVhZRTJ
# provider1111_prikey=5K2L2my3qUKqj67KU61cSACoxgREkqGFi5nKaLGjbAbbRBYRq1m
# #   ],[

# #   ],[
# provider2222_pubkey=EOS7qsja8UCa1ExokEb5wxCwBmJWi9aW1intH1sihNNHKoAGD6J7X
# provider2222_prikey=5JN8chYis1d8EYsCdDEKXyjLT3QmpW7HYoVB13dFKenK2uwyR65
# #   ],[
# provider3333_pubkey=EOS7yghCVnJHEu3TEB2nnSv1mgS5Rx8ofDyQK7C4dgbUWZCP1TtD1
# provider3333_prikey=5Kju7hDTh3uCZqpzb5VWAdCp7cA1fAiEd94zdNhU59WNaQMQQmE
# #   ],[
# provider4444_pubkey=EOS6jmPJZAPAB7hBwYxwfKiwVuqSrkSyRy2E4mjTmQ2CyYas4ESuv
# provider4444_prikey=5K6ZCUpk2jn1munFdiADgKgfAqcpGMHKCoJUue65p99xKX9WWCW
# #   ],[
# provider5555_pubkey=EOS8hvj4KPjjGvfRfJsGEEbVvCXvAiGQ7GW345MH1r122g8Ap7xw3
# provider5555_prikey=5KAyefwicvJyxDaQ1riCztiSgVKiH37VV9JdSRcrqi88qQkV2gJ
# #   ]
# # ]

# # #         password: [[
# consumer1111_pubkey=EOS5NkC58kuahypYnbyYXEZvwau1KbD1rmRDJD2R61CzKaznnWH3y
# consumer1111_prikey=5J1G4dhajiWDQduM3WSJ26vuoaMHi1AoqFLgVpazHL2aHsMkSb1
# #   ],[
# consumer2222_pubkey=EOS5ek5mix7jBFNox715fDevLfvCCvv1ks1Fv57CuJYtBYTb9UqkM
# consumer2222_prikey=5KGg63tz4CGkwoENGyhqoMaz8fnFNdqFiV8tKwepkheFdUTwxaX
# #   ],[
# consumer3333_pubkey=EOS7DYy6C1k35RsFD1iSKwSVNGnDwcUgtwSSpnmfzEhdrmF3pirDP
# consumer3333_prikey=5HpauMBdvhNEribfVfiYG1jniWrg1xRoRa5RmVdfg4JywkQFPP1
# #   ],[
# consumer4444_pubkey=EOS7uiCTbwNptteEUyMGjnbcsL9YezHnRnDRThSDZ8kAYzqw133v9
# consumer4444_prikey=5JXoS35W4Ys8VGwoRc1gZqEijW3R3uf8gPKLcY5i12qngydzvnR
# #   ],[
# consumer5555_pubkey=EOS8ACpi4GFsSA1RHom8TS8t5TxCjfe8J5F2PAvZrGiNb5Zhj9y2p
# consumer5555_prikey=5JvftBQsdzygzvgX93bX62wTDzbhPvqHCEDqkyBNahnTuAi4cDA

consumer_pubkeys=(
  "EOS5NkC58kuahypYnbyYXEZvwau1KbD1rmRDJD2R61CzKaznnWH3y" "EOS5ek5mix7jBFNox715fDevLfvCCvv1ks1Fv57CuJYtBYTb9UqkM" "EOS7DYy6C1k35RsFD1iSKwSVNGnDwcUgtwSSpnmfzEhdrmF3pirDP" "EOS7uiCTbwNptteEUyMGjnbcsL9YezHnRnDRThSDZ8kAYzqw133v9" "EOS8ACpi4GFsSA1RHom8TS8t5TxCjfe8J5F2PAvZrGiNb5Zhj9y2p"
)

consumer_prikeys=(
  "5J1G4dhajiWDQduM3WSJ26vuoaMHi1AoqFLgVpazHL2aHsMkSb1" "5KGg63tz4CGkwoENGyhqoMaz8fnFNdqFiV8tKwepkheFdUTwxaX" "5HpauMBdvhNEribfVfiYG1jniWrg1xRoRa5RmVdfg4JywkQFPP1" "5JXoS35W4Ys8VGwoRc1gZqEijW3R3uf8gPKLcY5i12qngydzvnR" "5JvftBQsdzygzvgX93bX62wTDzbhPvqHCEDqkyBNahnTuAi4cDA"
)

eosio_test_test() {

  a=eostest12345
  create_one ${a}
  cleos set contract ${a} ${CONTRACTS_DIR}/eosio.test -x 1000 -p ${a}

  cleos transfer eosfirstacnt ${a} "1.2345 BOS" -p eosfirstacnt

  cleos push action ${a} transfer '["eosfirstacnt","eostest12345","1.2356 BOS","memo"]' -p eosfirstacnt
}

#cleos push action eosio newaccount '{"creator":"eosio","name":"eosstore1111","owner":{"threshold":1,"keys":[{"key":"EOS6yuxPfeaDrAxgHCh6H4jT2kgGvuy11hPgfEPksa4SwxGr3ZC4d","weight":1}],"accounts":[],"waits":[]},"active":{"threshold":1,"keys":[{"key":"EOS6yuxPfeaDrAxgHCh6H4jT2kgGvuy11hPgfEPksa4SwxGr3ZC4d","weight":1}],"accounts":[],"waits":[]}}' -p  eosio

namelist() {
  cleos push action eosio namelist '["actor_blacklist", "insert", ["eosstoreff1a","eosstoreff1b","eosstoreff1c"]]' -p eosio
  #cleos get table eosio eosstoreff1a userres
  #cleos get table eosio eosio minguar
}

hallo() {
  cleos get account eosstoreff1a
  cleos push action eosio setminguar '[1,1,1]' -p eosio
  cleos push action eosio setlists '{
      "params": {
          "actor_blacklist":["111","222","333","444","555","aaa","bbb"],
          "contract_blacklist":["111","222"],
          "resource_greylist":["111"]
        }
    }' -p eosio

  cleos push action eosio setlists '{
      "params": {
          "actor_blacklist":[],
          "contract_blacklist":[],
          "resource_greylist":["111","222"]
        }
    }' -p eosio

  cleos push action eosio setlists '{
      "params": {
          "actor_blacklist": [
            "111",
            "222",
            "2221"
          ],
          "contract_blacklist": [
            "111",
            "222",
            "2221"
          ],
          "resource_greylist": [
            "111",
            "222"
          ]
        }
    }' -p eosio

  cleos get table eosio eosio lists
  cleos push action eosio setpriv '{"account": "eosio.msig", "is_priv": 1}' -p eosio
  cleos get table eosio eosio cntlrcfg
  cleos push action eosio setcontcfg '{
      "params": {
          "a": 101
        }
    }' -p eosio
}
