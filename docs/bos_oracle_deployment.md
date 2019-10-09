1.eosio多签创建预言机相关账户、部署合约
1.写出创建账户的基础信息：testaccount.json
```
["eosio", "oracle.bos", {
      "threshold": 1,
      "keys": [],
      "accounts": [{
      "permission": {
      "actor": "eosio",
      "permission": "active"
     },
    "weight": 1
    }
  ],
  "waits": []
}, {
       "threshold": 1,
       "keys": [],
       "accounts": [{
       "permission": {
       "actor": "eosio",
       "permission": "active"
      },
     "weight": 1
   },{
     "permission": {
     "actor": "oracle.bos",
     "permission": "eosio.code"
    },
    "weight": 1
  }
 ],
 "waits": []
}]
```
  
2.生成newaccount交易
```
cleos  push action eosio newaccount ./testaccount.json -sdj -p eosio > testacc.trx
```
3.生成buyram的交易
```
cleos  system buyram -k eosio oracle.bos 3000 -sdj > testacc-ram.trx
```
4.生成delegatebw的交易
```
cleos   system delegatebw eosio oracle.bos "2 BOS" "2 BOS" -sdj > testacc-delegate.trx
```
5.把交易的action粘贴到一个文件newtest.json中，发起提案
```
cleos   multisig propose_trx createtest  bppermission.json  newaccount.json  boscorebos11
```
newtest.json：
```
{
  "expiration": "2019-04-27T01:43:42",
  "ref_block_num": 33447,
  "ref_block_prefix": 2283537730,
  "max_net_usage_words": 0,
  "max_cpu_usage_ms": 0,
  "delay_sec": 0,
  "context_free_actions": [],
  "actions": [{
      "account": "eosio",
      "name": "newaccount",
      "authorization": [{
          "actor": "eosio",
          "permission": "active"
        }
      ],
      "data": "0000000000ea3055000000bdf79eb1ca0100000000010000000000ea305500000000a8ed32320100000100000000010000000000ea305500000000a8ed3232010000"
    },{
      "account": "eosio",
      "name": "buyrambytes",
      "authorization": [{
          "actor": "eosio",
          "permission": "active"
        }
      ],
      "data": "0000000000ea3055000000bdf79eb1ca00240000"
    },{
      "account": "eosio",
      "name": "delegatebw",
      "authorization": [{
          "actor": "eosio",
          "permission": "active"
        }
      ],
      "data": "0000000000ea3055000000bdf79eb1ca102700000000000004424f5300000000102700000000000004424f530000000000"
    }
  ],
  "transaction_extensions": [],
  "signatures": [],
  "context_free_data": []
}
```

2)部署合约
```
cleos  set contract  oracle.bos  bos.oracle/   -p oracle.bos  -s -j -d > setcontract.json

cleos multisig propose_trx setcontract  bppermission.json  setcontract.json  -p boscorebos11   

cleos multisig approve  boscorebos11 updatasystem '{"actor":"boscorebos11","permission":"active"}'  -p  boscorebos11

cleos  multisig exec boscorebos11 setcontract -p boscorebos11@active
```

~~3)设置eosio.code权限~~
* ~~cleos set account permission oracle.bos active '{"threshold": 1,"keys": [],"accounts": [{"permission":{"actor":"eosio","permission":"active"},"weight":1},{"permission":{"actor":"oracle.bos","permission":"eosio.code"},"weight":1}]}' owner -p oracle.bos@owner -s -j -d > setpermisson.json~~
* ~~cleos multisig propose_trx setpermisson  bppermission.json  setpermisson.json  -p boscorebos11   ~~
* ~~cleos multisig approve  boscorebos11 setpermisson '{"actor":"boscorebos11","permission":"active"}'  -p  boscorebos11~~
* ~~cleos  multisig exec boscorebos11 setpermisson -p ~~[boscorebos11@active](mailto:boscorebos11@active)





2.导入仲裁员：
```
cleos push action oracle.bos importwps '[["arbitrator11","arbitrator12","arbitrator13","arbitrator14","arbitrator15","arbitrator21","arbitrator22","arbitrator23","arbitrator24","arbitrator25", "arbitrator31", "arbitrator32","arbitrator33", "arbitrator34", "arbitrator35",  "arbitrator41",  "arbitrator42", "arbitrator43", "arbitrator44", "arbitrator45"]]' -p oracle.bos -s -j -d > importwps.json

cleos multisig propose_trx insertwps  bppermission.json  importwps.json  -p boscorebos11   

cleos multisig approve  boscorebos11 insertwps '{"actor":"boscorebos11","permission":"active"}'  -p  boscorebos11

cleos  multisig exec boscorebos11 insertwps -p boscorebos11@active
```




