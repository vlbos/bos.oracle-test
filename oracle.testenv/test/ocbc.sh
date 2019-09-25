# Private key: 5JNzcBuxPGmF3Saw3cedYzE6jL7VksFayxqpjokMTRpARkCwmHa
# Public key: EOS7UCx8GSeEHC4XE8jQ1R5WJqw5Vp2vZqWgQx94obFVbebnYg6eq

PUBKEY=EOS7UCx8GSeEHC4XE8jQ1R5WJqw5Vp2vZqWgQx94obFVbebnYg6eq

###=============================================== 创建账号

ACCOUNTS=(
    "eosio.token" "ocbc" "business1" "business2" "business3"  "business4" "business5" "bp1" "bp2" "bp3" "bp4" "bp5"
)
for account in ${ACCOUNTS[*]}
do
    echo -e "\n creating $account \n"; 
    cleos create account eosio ${account} ${PUBKEY}; 
    sleep 1;
done

EOS_TOKEN=eosio.token
################################################################## 发币
cleos set contract $EOS_TOKEN /bos.contract-prebuild/eosio.token -p $EOS_TOKEN@active
cleos push action $EOS_TOKEN create '[ "eosio.token", "10000000000.0000 BOS", 0, 0, 0]' -p $EOS_TOKEN
cleos push action $EOS_TOKEN issue '["eosio.token", "1000000000.0000 BOS", ""]' -p $EOS_TOKEN
cleos push action $EOS_TOKEN transfer '["eosio.token", "business1", "1000.0000 BOS", ""]' -p $EOS_TOKEN
cleos push action $EOS_TOKEN transfer '["eosio.token", "business2", "1000.0000 BOS", ""]' -p $EOS_TOKEN
cleos push action $EOS_TOKEN transfer '["eosio.token", "business3", "1000.0000 BOS", ""]' -p $EOS_TOKEN
cleos push action $EOS_TOKEN transfer '["eosio.token", "bp1", "1000.0000 BOS", ""]' -p $EOS_TOKEN
cleos push action $EOS_TOKEN transfer '["eosio.token", "bp2", "1000.0000 BOS", ""]' -p $EOS_TOKEN
cleos push action $EOS_TOKEN transfer '["eosio.token", "bp3", "1000.0000 BOS", ""]' -p $EOS_TOKEN
cleos push action $EOS_TOKEN transfer '["eosio.token", "ocbc", "1000.0000 BOS", ""]' -p $EOS_TOKEN

###=============================================== 部署合约
OCBC=ocbc
# cleos set contract $OCBC /ocbc/contracts/ocbc -p $OCBC
cleos set contract $OCBC /ocbc/build/contracts/ocbc -p $OCBC
###=============================================== set permission
cleos set account permission $OCBC active '{"threshold": 1,"keys": [{"key": "EOS7UCx8GSeEHC4XE8jQ1R5WJqw5Vp2vZqWgQx94obFVbebnYg6eq","weight": 1}],"accounts": [{"permission":{"actor":"ocbc","permission":"eosio.code"},"weight":1}]}' -p $OCBC@active

###=============================================== 1. 项目方
FROM=business1
cleos transfer ${FROM} ocbc "100.0000 BOS" "business-stake" -p ${FROM}
cleos transfer ${FROM} ocbc "100.0000 BOS" "business-deposit" -p ${FROM}

###=============================================== 2. BP
BP=bp1
cleos transfer ${BP} ocbc "100.0000 BOS" "bpstake-business1" -p ${BP}
cleos push action ocbc refund "bp1" -p ${OCBC}
cleos push action ocbc undelegate "bp1" -p ${BP}

###=============================================== Tables
cleos get table $OCBC $FROM business
cleos get table $OCBC $BP bp
cleos get table $OCBC $OCBC refunds
