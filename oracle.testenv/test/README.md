   合约账户以外需要创建账户
  static constexpr eosio::name provider_account{"provider.bos"_n};
  static constexpr eosio::name consumer_account{"consumer.bos"_n};
  static constexpr eosio::name riskctrl_account{"riskctrl.bos"_n};
  static constexpr eosio::name arbitrat_account{"arbitrat.bos"_n};

###### 1. 部署合约

```
./boracle_test.sh set

- test_set_contracts
- oracle.bos
- dappuser.bos

contract_oracle=oraclebosbos
contract_oracle_folder=bos.oracle

contract_consumer=consumer1234
contract_consumer_folder=bos.dappuser

  ${!cleos} set contract ${contract_oracle} ${CONTRACTS_DIR}/${contract_oracle_folder} -x 1000 -p ${contract_oracle}
 
    ${!cleos} set contract ${contract_consumer} ${CONTRACTS_DIR}/${contract_consumer_folder} -x 1000 -p ${contract_consumer}@active
  
```

##### 2. 注册服务

```
test_reg_service
 ${!cleos} push action ${contract_oracle} regservice '{"service_id":0,  "account":"'${provider1111}'", "amount":"10.0000 EOS", "service_price":"1.0000 EOS",
                          "fee_type":1, "data_format":"", "data_type":0, "criteria":"",
                          "acceptance":0, "declaration":"", "injection_method":0, "duration":1,
                          "provider_limit":3, "update_cycle":1, "update_start_time":"2019-07-29T15:27:33.216857+00:00"}' -p ${provider1111}@active

```

##### 3. 初始化服务如费用

```
test_fee

    ${!cleos} push action ${contract_oracle} addfeetypes '{"service_id":"0","fee_types":[0,1],"service_prices":["1.0000 EOS","2.0000 EOS"] }' -p ${contract_oracle}@active

```

##### 4.抵押

```
transfer stake
stake unstake  eosio.code
  $cleos1 transfer ${provider1111} ${contract_oracle} "0.0001 EOS" "0,0" -p ${provider1111}

```

##### 5. 订阅/请求

```
test_subs
  ${!cleos} push action ${contract_oracle} subscribe '{"service_id":"0", 
    "contract_account":"'${contract_consumer}'", "action_name":"receivejson", "publickey":"",
                          "account":"'${consumer1111}'", "amount":"10.0000 EOS", "memo":""}' -p ${consumer1111}@active
}
test_req

  ${!cleos} push action ${contract_oracle} requestdata '{"service_id":0,  "contract_account":"'${contract_consumer}'", "action_name":"receivejson",
                         "requester":"'${consumer1111}'", "request_content":"eth usd"}' -p ${consumer1111}@active

```

##### 6. 支付服务费用

```
transfer pay
    $cleos1 transfer ${consumer2222} ${contract_oracle} "0.0001 EOS" "1,0" -p ${consumer2222}

```

##### 7.推送

```
"mpush") test_multipush c1 "$2" ;;

  # ${!cleos}  set account permission ${provider1111}  active '{"threshold": 1,"keys": [{"key": "'${provider1111_pubkey}'","weight": 1}],"accounts": [{"permission":{"actor":"'${contract_oracle}'","permission":"eosio.code"},"weight":1}]}' owner -p ${provider1111}@owner
    ${!cleos} set account permission ${contract_oracle} active '{"threshold": 1,"keys": [{"key": "'${oracle_c_pubkey}'","weight": 1}],"accounts": [{"permission":{"actor":"'${contract_oracle}'","permission":"eosio.code"},"weight":1}]}' owner -p ${contract_oracle}@owner

    # sleep .2
    ${!cleos} push action ${contract_oracle} multipush '{"service_id":0, "provider":"'${provider1111}'", 
                          "data_json":"test multipush data json","is_request":'${reqflag}'}' -p ${provider1111}

"push") test_push c1 ;;


    ${!cleos} push action ${contract_oracle} pushdata '{"service_id":0, "provider":"'${provider1111}'", "contract_account":"'${contract_consumer}'", "action_name":"receivejson",
                         "request_id":0, "data_json":"test data json"}' -p ${provider1111}

"pushr") test_pushforreq c1 "$2" ;;

    ${!cleos} push action ${contract_oracle} pushdata '{"service_id":0, "provider":"'${provider1111}'", "contract_account":"'${contract_consumer}'", "action_name":"receivejson",
                         "request_id":'"$2"', "data_json":"test data json"}' -p ${provider1111}


${!cleos} push action ${contract_oracle} autopublish '{"service_id":1, "provider":"'${p}'", 
                         "request_id":0, "data_json":"auto publish test data json"}' -p ${p}

```

#### 风控

##### 1. 存入金额

```
"deposit") test_deposit c1 ;; dappuser()->dapp(data consumer) save

    $cleos1 transfer ${consumer2222} ${contract_oracle} "0.0001 EOS" "2,consumer2222,consumer1111,0" -p ${consumer2222}
   
```

##### 2. 提取金额 

```
"withdraw") test_withdraw c1 ;; dapp(data consumer) -> dappuser()

  ${!cleos} push action ${contract_oracle} withdraw '{"service_id":0,  "from":"'${consumer1111}'", "to":"oraclize1111",
                         "quantity":"1.0000 EOS", "memo":""}' -p ${contract_oracle}@active
}
```


#### 仲裁
##### 前提条件  
注册服务

1.注册仲裁员（抵押）
专业，大众

```
./boracle_test.sh arbi rega

cleos push action $EOS_ORACLE regarbitrat '["arbitrator11", "EOS7UCx8GSeEHC4XE8jQ1R5WJqw5Vp2vZqWgQx94obFVbebnYg6eq", 1, "1.0000 EOS", "hello world"]' -p arbitrator11@active

 $cleos1 transfer ${consumer2222} ${contract_oracle} "0.0001 EOS" "3,0" -p ${consumer2222}
```

2.申诉（抵押）仲裁开始

```
cleos push action $EOS_ORACLE complain '["complainant1", 0, "1.0000 EOS", "complainant1", 1]' -p complainant1@active
```

3.上传证据

```  
cleos push action $EOS_ORACLE uploadeviden '["complainant1", 0, "evidence"]' - p complainant1 @active
```

3.应诉（抵押）

```
cleos push action $EOS_ORACLE respcase '["provider1111", 0, 0]' -p provider1111@active
```

4.接受仲裁邀请

```
cleos push action $EOS_ORACLE respcase '["provider1111", 0, 0]' -p provider1111@active
```

5.上仲裁结果

```
cleos push action $EOS_ORACLE uploadresult '["arbitrator12", 0, 1, 0]' -p arbitrator12@active
当前仲裁结果得出   通知transfer memo 再申诉等待
```

6.再申诉（抵押）

```
cleos push action $EOS_ORACLE reappeal '["complainant1", 0, 0, 1, 1, false, "1.0000 EOS", 1, "数据使用者不服, 再次申诉"]' -p complainant1@active
```

7.再应诉（抵押）

```
cleos push action $EOS_ORACLE rerespcase '["provider1111", 0, 0, 1, true]' -p complainant1@active
```


transfer memo format type

格式： ','隔开 
第一元素 类型  
具体类型如下
索引号以0开始  tc_service_stake = 0 ,以次递增
```
enum transfer_category : 
tc_service_stake  , 
tc_pay_service,
tc_deposit,
tc_arbitration_stake_complain,
tc_arbitration_stake_arbitrator,
tc_arbitration_stake_resp_case,
ts_arbitration_stake_reappeal,
tc_arbitration_stake_reresp_case,
tc_risk_guarantee};

具体类型 格式  最后一个参数数量不在memo出现 
数据提供者抵押，数据使用者支付充值
'类型=0或1，id'
# // enum class memo_index : uint8_t { index_category,index_id ,index_count};
风控存款
'类型=2，转出账户，转入账户，是否通知，'
# // enum class memo_index_deposit : uint8_t { deposit_category,deposit_from ,deposit_to,deposit_notify , index_count};

申诉
'类型=3，服务id，公示信息，证据，申诉原因'
# // enum class memo_index_complain : uint8_t { complain_category,index_id ,index_info,index_evidence,index_reason,index_count};
注册仲裁员
'类型=4，仲裁员类型'
# // enum class memo_index_arbitrator : uint8_t { arbitrator_category,index_type ,index_count};

应诉
'类型=5，服务id，仲裁轮次，证据'
# // enum class memo_index_resp_case : uint8_t { resp_case_category,index_id ,index_round,index_evidence,index_count};

再申诉
'类型=6，服务id，仲裁轮次，证据，是否是数据提供者，申诉原因，仲裁id'
# // enum class memo_index_reappeal : uint8_t { reappeal_category,index_id ,index_round,index_evidence,index_provider,index_reason,index_arbi_id ,index_count};
再应诉
'类型=6，服务id，仲裁轮次，证据，是否是数据提供者'
# // enum class memo_index_reresp_case : uint8_t { reresp_case_category,index_id ,index_round,index_evidence,index_provider,index_count};

添加风险担保金
'类型=6，服务id，有效时长'
# // enum class memo_index_risk_guarantee : uint8_t { risk_guarantee_category,index_id ,index_duration,index_count};

transfer0() {
    echo --- providers before transfer ---
    test_get_table providers
    echo --- svcprovision before transfer ---
    test_get_table1 0 svcprovision
    echo --- servicestake before transfer ---
    test_get_table servicestake
    echo --- cleos1 transfer service stake---
    $cleos1 transfer ${provider1111} ${contract_oracle} "0.0001 EOS" "0,0" -p ${provider1111}
    echo --- providers after transfer ---
    test_get_table providers
    echo --- svcprovision after transfer ---
    test_get_table1 0 svcprovision
    echo --- servicestake after transfer ---
    test_get_table servicestake
}

transfer1() {
    echo --- cleos1 subscription before transfer ---
    test_get_table1 0 subscription
    echo --- cleos1 pay service before transfer ---
    $cleos1 transfer ${contract_consumer} ${contract_oracle} "0.0001 EOS" "1,0" -p ${contract_consumer}
    echo --- cleos1 subscription after transfer ---
    test_get_table1 0 subscription
}

transfer2() {
    echo --- riskaccounts before transfer 2---
    test_get_table1 consumer1111 riskaccounts
    echo --- deposit transfer 2---
    $cleos1 transfer ${consumer2222} ${contract_oracle} "0.0001 EOS" "2,consumer2222,consumer1111,0" -p ${consumer2222}
    echo --- riskaccounts after transfer 2---
    test_get_table1 consumer1111 riskaccounts
}

# // enum class memo_index : uint8_t { index_category,index_id ,index_count};
# // enum class memo_index_deposit : uint8_t { deposit_category,deposit_from ,deposit_to,deposit_notify , index_count};
# // enum class memo_index_complain : uint8_t { complain_category,index_id ,index_evidence,index_info,index_reason,index_count};
# // enum class memo_index_arbitrator : uint8_t { arbitrator_category,index_type ,index_count};
# // enum class memo_index_resp_case : uint8_t { resp_case_category,index_id ,index_round,index_evidence,index_count};
# // enum class memo_index_reappeal : uint8_t { reappeal_category,index_id ,index_round,index_evidence,index_provider,index_reason,index_arbi_id ,index_count};
# // enum class memo_index_reresp_case : uint8_t { reresp_case_category,index_id ,index_round,index_evidence,index_provider,index_count};
# // enum class memo_index_risk_guarantee : uint8_t { risk_guarantee_category,index_id ,index_duration,index_count};

transfer3() {
    echo --- cleos1 transfer 3---

    #complain
    $cleos1 transfer ${consumer2222} ${contract_oracle} "0.0001 EOS" "3,1,'','','reason'" -p ${consumer2222}
    #arbitrator
    $cleos1 transfer ${consumer2222} ${contract_oracle} "0.0001 EOS" "4,1" -p ${consumer2222}
    #resp_case
    $cleos1 transfer ${consumer2222} ${contract_oracle} "0.0001 EOS" "5,0,1" -p ${consumer2222}
    #reappeal
    $cleos1 transfer ${consumer2222} ${contract_oracle} "0.0001 EOS" "6,1,2,0,'reason',0" -p ${consumer2222}
    #reresp_case
    $cleos1 transfer ${consumer2222} ${contract_oracle} "0.0001 EOS" "7,0,2" -p ${consumer2222}

}

```


# 1. 部署合约 


    ${!cleos} set contract ${contract_oracle} ${CONTRACTS_DIR}/${contract_oracle_folder} -x 1000 -p ${contract_oracle}
   
    ${!cleos} set contract ${contract_consumer} ${CONTRACTS_DIR}/${contract_consumer_folder} -x 1000 -p ${contract_consumer}@active


1. 注册预言机数据服务接口

| 中文接口名   | 注册预言机数据服务接口   |    |    |    | 
|:----|:----|:----|:----|:----|
| 英文接口名   | Register oracle Data Service Interface    |    |    |    | 
| 定义接口名   | regservice   |    |    |    | 
| 接口功能描述   | 注册oracle数据服务   |    |    |    | 
| 中文参数名           |   英文参数名               | 参数定义   | 参数类型   |      参数描述    | 
| 数据服务ID    | Data Service ID   | uint64_t service_id   | 整型   |  注册id：int 从1开始自增，用于表示一类预言机服务   | 
| 服务价格   | Service Price   | uint64_t service_price   | 整型   |    | 
| 费用类型   |  Fee Type    | uint64_t fee_type   | 整型   |  按0-次，1-月   | 
| 数据格式   | data_format   | std::string data_format   | 字符串   |  data_format：提前约定数据展现形式，比如：Jianeng2Hongyang:100   | 
| 数据类型   | Data Type   | uint64_t data_type   | 整型   | (确定性/非确定性) type：是指数据提者提供的数据是否允许差异   | 
| 准则   | criteria   | std::string criteria   | 字符串   | （出现时评判准则）  备注类型   | 
| 接受方式     | accept_mode     | uint64_t  acceptance   | 整型   |  数据接受规则  比例/人数   | 
| 声明    | registration_instructions   | std::string declaration   |    |    | 
| 数据注入方式    | Data injection method    | uint64_t injection _method   | 整型   | 数据注入方式    链上直接，链接间接（over oracle），链外   | 
| 基础抵押金额   | basic_mortgage_amount   | uint64_t amount   | 整型   | 基础抵押金额    | 
| 数据收集持续时间   | Data Collection Duration   | uint64_t duration   | 整型   | 数据收集持续时间（从第一个数据提供者注入数据算起，多久后不再接受同一project_id ^update_number 的数据）duration 单位：秒   | 
| 数据提供者下限   | Data Provider Limit   | uint64_t provider_limit   | 整型   | 数据提供者下限（大于3） data_provider_min_number    | 
| 数据更新周期 | Data Update Cycle   | uint64_t update_cycle   | 整型   | 数据更新周期 单位：秒  | 
| 数据更新开始时间 | Data update start time    | uint64_t update_start_time   | 整型   | 数据更新开始时间   | 


```
  ${!cleos} push action ${contract_oracle} regservice '{"service_id":0,  "account":"'${provider1111}'", "amount":"10.0000 EOS", "service_price":"1.0000 EOS",
                          "fee_type":1, "data_format":"", "data_type":0, "criteria":"",
                          "acceptance":0, "declaration":"", "injection_method":0, "duration":1,
                          "provider_limit":3, "update_cycle":1, "update_start_time":"2019-07-29T15:27:33.216857+00:00"}' -p ${provider1111}@active
```


2. 注销数据服务接口

| 中文接口名 | 注销数据服务接口 |    |    |    | 
|:----:|:----:|:----|:----|:----|
| 英文接口名 | unregister Data service provision interface |    |    |    | 
| 定义接口名 | unregservice |    |    |    | 
| 接口功能描述 | 定义提供数据服务与数据服务提供者 关系 |    |    |    | 
| 中文参数名         |   英文参数名             | 参数定义 | 参数类型 |      参数描述  | 
| 数据服务ID   | Data Service ID | uint64_t service _id | 整型 |    | 
| 数据提供者签名 | Data provider signature | std::string signature  | 字符串 |    | 
| 数据提供者账户 | Data Provider Account | name account | 整型 |    | 
| 是否临时注销 | Stop Service Flag | uint64_t is_suspense | 整型 | 为1为临时注销 | 


3. 数据服务操作接口

| 中文接口名 | 数据服务操作接口   |    |    |    | 
|:----:|:----|:----|:----|:----|
| 英文接口名 | Data  service action interface   |    |    |    | 
| 定义接口名 | servaction   |    |    |    | 
| 接口功能描述 | 定义数据服务操作如冻结，紧急处理   |    |    |    | 
| 中文参数名         |   英文参数名             | 参数定义   | 参数类型 |      参数描述  | 
| 数据服务ID   | Data Service ID | uint64_t service _id | 整型 |    | 
| 操作类型   | operation type   | std::string operation_type   | 整型   | 1 冻结  2 紧急   | 


4. 增减数据提供者抵押金额接口

| 中文接口名 | 增减数据提供者抵押金额接口   |    |    |    | 
|:----:|:----|:----|:----|:----|
| 英文接口名 | Data provider  stake amount  of increase or decrease interface   |    |    |    | 
| 定义接口名 | stakeamount   |    |    |    | 
| 接口功能描述 | 数据提供者增减抵押金额接口   |    |    |    | 
| 中文参数名         |   英文参数名             | 参数定义   | 参数类型 |      参数描述  | 
| 数据服务ID   | Data Service ID | uint64_t service _id | 整型 |    | 
| 数据提供者ID   | Data Provider ID   | uint64_t provider _id | 整型 |    | 
| 数据提供者账户   | Data Provider Account   | name account | 整型 |    | 
| 数据提供者签名   | Data Provider signature   | std::string signature    | 字符串 |    | 
| 抵押金额   | Total Mortgage Amount   | uint64_t total _stake_amount | 整型 |    | 


5. 订阅数据服务接口

| 中文接口名 | 订阅数据服务接口   |    |    |    | 
|:----:|:----|:----|:----|:----|
| 英文接口名 | Data Service Usage Interface   |    |    |    | 
| 定义接口名 | subscribeserv   |    |    |    | 
| 接口功能描述 | 定义数据使用者订阅数据服务   |    |    |    | 
| 中文参数名         |   英文参数名             | 参数定义   | 参数类型 |      参数描述  | 
| 数据服务ID    | Data Service ID   | uint64_t service _id | 整型 |    | 
| 接收数据合约账户   | Receive Data Contract Account   | name contract_account | 整型 |    | 
| 接收数据acion名称   | Receive data acion name   | name action_name  | 整型   |    | 
| 数据使用者publickey | Data User publickey  | std::string publickey | 字符串 |    | 
| 转账账户   | Transfer account   | uint64_t account | 整型 |    | 
| 充值金额   | deposit amount   | uint64_t amount | 整型 |    | 

    ${!cleos} push action ${contract_oracle} subscribe '{"service_id":"0", 
    "contract_account":"'${contract_consumer}'", "action_name":"receivejson", "publickey":"",
                          "account":"'${consumer1111}'", "amount":"10.0000 EOS", "memo":""}' -p ${consumer1111}@active

6. 请求服务数据接口

| 中文接口名 | 请求服务数据接口   |    |    |    | 
|:----:|:----|:----|:----|:----|
| 英文接口名 | Request Service Data   Interface   |    |    |    | 
| 定义接口名 | reqservdata   |    |    |    | 
| 接口功能描述 | 定义数据使用者主动请求数据服务的接口   |    |    |    | 
| 中文参数名         |   英文参数名             | 参数定义 | 参数类型 |      参数描述  | 
| 请求更新序列号    | update_number   | uint64_t update _number | 整型 |    | 
| 请求数据服务ID   | Request Data Service ID   | uint64_t service _id | 整型 |    | 
| 请求签名   | Request Signature   | name request_signature  | 字符串 |    | 
| 请求内容   | Request Content    | uint64_t request_content | 字符串 |   定义规则   | 


    ${!cleos} push action ${contract_oracle} requestdata '{"service_id":0,  "contract_account":"'${contract_consumer}'", "action_name":"receivejson",
                         "requester":"'${consumer1111}'", "request_content":"eth usd"}' -p ${consumer1111}@active


7. 推送服务数据接口  

| 中文接口名 | 推送服务数据接口   |    |    |    | 
|:----:|:----:|:----|:----|:----|
| 英文接口名 | push Service Data   Interface |    |    |    | 
| 定义接口名 | pushservdata |    |    |    | 
| 接口功能描述 | 定义推送服务数据，包括直接推送数据使用者，间接通过oracle合约推送。   |    |    |    | 
| 中文参数名         |   英文参数名             | 参数定义 | 参数类型 |      参数描述  | 
| 数据服务ID   | Data Service ID   | uint64_t service _id | 整型 |    | 
| 数据更新序列号     | Data Update Serial Number    | uint64_t update_number | 整型 |    | 
| 具体数据json    | Specific data json   | uint64_t data_json | 字符串 |    | 
| 数据提供者签名    | Data Provider Signature    | uint64_t provider _signature  | 字符串 |    | 
| 数据服务请求ID | Data Service Request ID  | uint64_t request_id | 整型 |    | 

  ${!cleos} push action ${contract_oracle} pushdata '{"service_id":0, "provider":"'${provider1111}'", "contract_account":"'${contract_consumer}'", "action_name":"receivejson",
                         "request_id":'"$2"', "data_json":"test data json"}' -p ${provider1111}

  # ${!cleos}  set account permission ${provider1111}  active '{"threshold": 1,"keys": [{"key": "'${provider1111_pubkey}'","weight": 1}],"accounts": [{"permission":{"actor":"'${contract_oracle}'","permission":"eosio.code"},"weight":1}]}' owner -p ${provider1111}@owner

    ${!cleos} set account permission ${contract_oracle} active '{"threshold": 1,"keys": [{"key": "'${oracle_c_pubkey}'","weight": 1}],"accounts": [{"permission":{"actor":"'${contract_oracle}'","permission":"eosio.code"},"weight":1}]}' owner -p ${contract_oracle}@owner

    # sleep .2
    ${!cleos} push action ${contract_oracle} multipush '{"service_id":0, "provider":"'${provider1111}'", 
                          "data_json":"test multipush data json","is_request":'${reqflag}'}' -p ${provider1111}

  reqflag=false && if [ "$2" != "" ]; then reqflag="$2"; fi

    echo ===multipush
    # ${!cleos}  set account permission ${provider1111}  active '{"threshold": 1,"keys": [{"key": "'${provider1111_pubkey}'","weight": 1}],"accounts": [{"permission":{"actor":"'${contract_oracle}'","permission":"eosio.code"},"weight":1}]}' owner -p ${provider1111}@owner
    ${!cleos} set account permission ${contract_oracle} active '{"threshold": 1,"keys": [{"key": "'${oracle_c_pubkey}'","weight": 1}],"accounts": [{"permission":{"actor":"'${contract_oracle}'","permission":"eosio.code"},"weight":1}]}' owner -p ${contract_oracle}@owner

    # sleep .2
    ${!cleos} push action ${contract_oracle} multipush '{"service_id":0, "provider":"'${provider1111}'", 
                          "data_json":"test multipush data json","is_request":'${reqflag}'}' -p ${provider1111}

# 2.  
8. 申诉接口

| 中文接口名 | 申诉接口 |    |    |    | 
|:----:|:----|:----|:----|:----|
| 英文接口名 | Complain Interface   |    |    |    | 
| 定义接口名 | complain   |    |    |    | 
| 接口功能描述 | 定义数据服务使用者对提供数据质疑时提出申诉接口   |    |    |    | 
| 中文参数名         |   英文参数名             | 参数定义 | 参数类型 |      参数描述  | 
| 申诉者签名   | Appellant   | name applicant   | 整型 |    | 
| 数据服务ID | Data Service ID   | uint64_t service_id  | 整型 |    | 
| 申诉抵押金额   | stake amount   | asset amount   | 整型 |    | 
| 申诉原因 | Reason for appeal   | std::string reason   | 字符串   |    | 
| ~~申诉者发起人~~   | ~~Sponsors~~   | ~~bool is_~~~~sponsor~~   | ~~布尔~~   |    | 
| 仲裁方式 | Arbitration   | uint8_t arbi_method   | 整型 | 仲裁方式  大众仲裁，多轮仲裁 | 

# 3.  
9. 应诉接口  

| 中文接口名 | 应诉接口   |    |    |    | 
|:----|:----|:----|:----|:----|
| 英文接口名 | response to arbitration Interface   |    |    |    | 
| 定义接口名 | acceptarbi   |    |    |    | 
| 接口功能描述 | 应诉仲裁案件   |    |    |    | 
| 中文参数名         |   英文参数名             | 参数定义 | 参数类型 |      参数描述  | 
| 应诉者   | arbitrator   | name arbitrator   | name   |    | 
| 仲裁项ID  | Arbitration ID  | uint64_t arbitration_id | 整型 |    | 
| 应诉者签名 | signature | signature sig | 整型 |    | 

10. 注册仲裁员接口   

| 中文接口名 | 仲裁员接口 |    |    |    | 
|:----:|:----:|:----|:----|:----|
| 英文接口名 | register Arbitrators Interface |    |    |    | 
| 定义接口名 | regarbitrat   |    |    |    | 
| 接口功能描述 |   定义注册仲裁员接口，包括职业仲裁员，大众仲裁员 |    |    |    | 
| 中文参数名         |   英文参数名             | 参数定义 | 参数类型 |      参数描述  | 
| 仲裁员账户 | Arbitrator Account | name account | 整型 |    | 
| 仲裁员publickey | Arbitrator publickey | public_key pubkey   | 公钥   |    | 
| 仲裁员类型 | Arbitrator type | uint8_t type   | 整型 |   1 - 职业仲裁员，2 -大众仲裁员 | 
| 仲裁员抵押金额 | Arbitrator Mortgage Amount | asset amount   | 整型 |    | 
| 仲裁员公示信息 | Arbitrator Public Information  | std::string public_info   | 字符串 |    | 


11. 仲裁员应答接口   

| 中文接口名 | 仲裁员应答接口      |    |    |    | 
|:----:|:----|:----|:----|:----|
| 英文接口名 | Arbitrator response Interface   |    |    |    | 
| 定义接口名 | respcase   |    |    |    | 
| 接口功能描述 |  定义仲裁员接受邀请仲裁案件   |    |    |    | 
| 中文参数名         |   英文参数名             | 参数定义 | 参数类型 |      参数描述  | 
| 仲裁员 |  Arbitrator Name   | name arbitrator   | name   |    | 
| 仲裁项ID | Arbitration ID | uint64_t arbitrate_id   | 整型 |    | 
| 仲裁结果 | Arbitration Results  | uint64_t result | 整型 |    | 
| 仲裁轮次 | Arbitration Process Record ID | uint64_t process_id | 整型 |    | 

12. 上传仲裁结果接口  

| 中文接口名 | 上传仲裁结果接口   |    |    |    | 
|:----:|:----|:----|:----|:----|
| 英文接口名 |  Upload Arbitration results interface   |    |    |    | 
| 定义接口名 |  uploadresult    |    |    |    | 
| 接口功能描述 | 定义仲裁人上传仲裁结果接口   |    |    |    | 
| 中文参数名         |   英文参数名             | 参数定义 | 参数类型 |      参数描述  | 
| 仲裁员名称   |  Arbitrator Name   | name  arbitrator   | 整型 |    | 
| 仲裁项ID   | Arbitration ID   | uint64_t arbitration_id   | 整型 |    | 
| 仲裁结果   | Arbitration Results    | uint64_t result | 整型 |    | 
| 仲裁轮次   | Arbitration Process Record ID   | uint64_t process_id | 整型 |    | 

# 4.  
13. 上传证据接口

| 中文接口名 | 上传证据接口      |    |    |    | 
|:----:|:----|:----|:----|:----|
| 英文接口名 | upload evidence Interface   |    |    |    | 
| 定义接口名 | uploadeviden   |    |    |    | 
| 接口功能描述 | 上传仲裁案件相关证据   |    |    |    | 
| 中文参数名         |   英文参数名             | 参数定义 | 参数类型 |      参数描述  | 
| 上传者签名   | uploader signature   | signature sig    | 整型 |    | 
| 仲裁项ID   | Arbitration ID   | uint64_t arbitration_id | 整型 |    | 
| 仲裁员证据    | Arbitrator Evidence   | std::string evidence  | 字符串   | 仲裁员证据  ipfs hash链接   | 

14. 转账风险担保金接口 

| 中文接口名 | 转账风险担保金接口   |    |    |    | 
|:----:|:----|:----|:----|:----|
| 英文接口名 | Transfer risk guarantee amount interface   |    |    |    | 
| 定义接口名 | transferrisk   |    |    |    | 
| 接口功能描述 | 转账风险担保金   |    |    |    | 
| 中文参数名         |   英文参数名             | 参数定义 | 参数类型 |      参数描述  | 
| 发送者   | sender   | name sender    | 整型 |    | 
| 接收者   | receiver   | name receiver   | 整型 |    | 
| 金额   | amount   | uint64_t amount | 整型 |    | 
| 转账方向 |  transfer direction | uint64_t direction | 整型 | 1 转入预言机合约2 转出预言机合约   | 

15. 领取数据服务收入接口 

| 中文接口名 | 领取数据服务收入接口   |    |    |    | 
|:----:|:----|:----|:----|:----|
| 英文接口名 | claim reward   |    |    |    | 
| 定义接口名 | claimreward   |    |    |    | 
| 接口功能描述 | 数据服务提供者领取数据服务收入   |    |    |    | 
| 中文参数名         |   英文参数名             | 参数定义 | 参数类型 |      参数描述  | 
| 数据服务ID   | Data Service ID   | uint64_t service _id | 整型 |    | 
| 发放账户   |  issuance of accounts    | name account  | 整型 |    | 

16. 添加数据服务风险担保接口

| 中文接口名 | 添加数据服务风险担保接口   |    |    |    | 
|:----:|:----|:----|:----|:----|
| 英文接口名 | Add data serivce Risk Guarantee Interface   |    |    |    | 
| 定义接口名 | addriskguara   |    |    |    | 
| 接口功能描述 | 定义添加数据服务风险担保接口。   |    |    |    | 
| 中文参数名         |   英文参数名             | 参数定义 | 参数类型 |      参数描述  | 
| 数据服务ID   | Data Service ID | uint64_t service _id | 整型   |    | 
| 风险担保ID | Risk Guarantee ID   | uint64_t risk _id | 整型 |    | 
| 风险担保账户 | Risk Guarantee Account   | name account | 整型 |    | 
| 风险担保金额 |  Risk Guarantee Amount   | name amount  | 整型 |    | 
| 风险担保时长 | Risk Guarantee Duration   | uint64_t duration | 整型 |    | 
| 风险担保签名 | Risk Guarantee Signature   | std::string signature | 字符串 |    | 

17. 链外握手协议接口(不实现）

| 中文接口名 | 链外握手协议 |    |    |    | 
|:----:|:----:|:----|:----|:----|
| 英文接口名 | handshakeoffchain Interface |    |    |    | 
| 定义接口名 | handshake |    |    |    | 
| 接口功能描述 | 定义数据服务使用者与数据服务提供者链外交互协议，不实现，另有单独接口提供验证双方身份合法性。 |    |    |    | 
| 中文参数名         |   英文参数名             | 参数定义 | 参数类型 |      参数描述  | 
| 数据提供者publickey | publickey | uint64_t publickey | 整型 |    | 
| hash | hash | uint64_t hash | 字符串 |    | 
| 数据提供者签名  | Data User Signature  | uint64_t user _signature  | 字符串 |    | 
| 数据服务ID | Data Service Request ID  | uint64_t request_id | 整型 |    | 
| 数据 hash | data hash | uint64_t data_hash | 字符串 |    | 


# 5. 疑问
### 5.0.1. 申诉接口: complain
初次申诉时, `arbicaseapp`表, `update_number` 更新逻辑
答：`arbicaseapp`表, `update_number` 更新逻辑，暂时没有了。表设计时申诉考虑具体到哪条数据。上次讨论具体到服务ID。
### 5.0.2. 应诉接口: acceptarbi
应诉接口签名参数有什么用？签名验证的内容是什么? 应诉逻辑? 修改arbicaseapp哪几个字段?
答：签名为出现争议使用，链就行了，action验证有效格式就行了。应诉，转账抵押金额。更新arbicaseapp，arbi_step为应诉状态，触发仲裁启动。判断仲裁方式，执行仲裁流程逻辑。
### 5.0.3. 上传证据: uploadeviden
签名参数有什么用? 签名验证什么内容? 
答：现在实现到验证签名是有效格式就行了，设计考虑如果有争议，发生抵赖或冒名等问题，保存证据。


