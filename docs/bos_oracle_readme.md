# 
| 版本号   | 版本功能   | 修改时间   | 修改人   | 
|:----|:----|:----|:----|
| v1.0   | 数据提供+仲裁基础功能   | 2019/09/10   | zhangshiqi   | 
|    |    |    |    | 

# 一、背景
        区块链广为人知，底层技术已经有了比较大的突破，但是应用场景并不多，主要还是链处于一个封闭的系统，无法与外界信息通讯。但是如果大家将人类社会中已有的数据上传到链上，打通区块链与现实世界通路，这样就可以大大增加区块链的应用场景。      
        预言机是图灵机模型里引入的概念，由于停机问题以及数学不完备性的原因，引入该概念后会得到一些标准图灵机所不能得到结果。在图灵机里它的定义是确定性的，但在区块链中引入的预言机却很难得到理论上定义的特点，究其原因是因为区块链本身就是建立在容错逻辑上的，其本身并不要求输入的确定性，甚至允许存在欺骗行为(这也是区块链建立拜占庭容错理论之上的原因)，因此在区块链的预言机与传统意义上的预言机有着本质的区别。
# 二、介绍
        BOS的预言机增加BOS的应用场景，将区块链应用落地不依靠任何权威背书，去中心化仲裁解决方案。与其他已有预言机的对比,竞品分析,    

      BOS解决方案：采用对信息提供者的松耦合设计，基于bos底层的功能引入以及数据存储。 引入第三方仲裁方案来处理非确定性的问题。为了应对不同情形，不同级别的预言机服务冲突进行处理，采用双向举证，不同的仲裁员和多轮仲裁判决确定最终仲裁结果。在仲裁中采用抵押机制作为最终处罚锚点，申诉制和检举制同时进行，相互监督；用收益分成以及惩罚金作为奖励的方式激励仲裁员，并且引入信用体系以实现非一次性博弈下模型的稳定和可信。

预言机服务功能：提供数据、获取数据、仲裁功能
预言机服务角色：提供者、 使用者、 合约、 仲裁员
预言机服务特点：完善的仲裁体系,**博弈模型,正向激励**仲裁员
## 2.1 提供数据功能
       预言机服务主要是提供数据服务平台，有数据资源的参与方，可以在BOS上创建自己的数据服务，上传数据供大家使用，将数据变现。
## 2.2 获取数据功能
       数据使用者可以根据自己的需求使用已有预言机服务，也可以作为发起方参与到对应预言机服务当中，并从服务上获取自己想要的数据。
## 2.3 仲裁功能
       引入仲裁的作用是保证整个预言机系统是一个完备的博弈系统，保证系统贡献者可以获取收益，作弊者可以收到对应的惩罚。在使用过程中，如果预言机提供的数据有问题可以通过仲裁的方式来解决。并且支持多轮仲裁,经过多轮不重复的仲裁员裁决,保证最终仲裁结果是最公平的结果。
## 2.4 说明
下文出现的变量的含义：
${contract_oracle} 均为预言机服务在BOS上部署的合约账户
${provi_account} 服务的数据提供者
# 三、数据提供者如何使用预言机服务
## 3.1 创建服务
        任何人都可以创建数据服务，服务的基本参数由创建者设置。数据服务创建好后，任何人也均可以注册成为数据提供者，注册时需要**抵押保证金**，**不低于服务设置**的保证金才可以成功成为该服务的提供者。

创建服务命令：
```
cleos push action ${contract_oracle} regservice '{"account":"${create_account}","base_stake_amount":"1000.0000 BOS","data_format":"json", "data_type":0, "criteria":"以多数人为准", "acceptance":0, "declaration":"该数据具有时效性", "injection_method":0, "duration":500,"provider_limit":3, "update_cycle":600}' -p ${account}
```

参数说明：
* account：创建服务的账户名
* base_stake_amount：服务的最低抵押token的额度  1000
* data_format：string类型 数据格式 自己定义数据格式，text、json、custom ，如果是json格式，需要输入{"xxx":"xxxx"}
* data_type：数据类型为0  确定性 ，1为不确定性，暂不支持其他类型
* criteria：准则说明，当有人对服务发起申诉时，仲裁员会根据证据和准则进行裁判
* acceptance：服务提供者上传的数据，最低几个服务提供者上传数据才会显示（暂未使用）为3～100之间
* ~~declaration：服务声明~~
* injection_method：注入方式为0：写入表 
* duration: 数据收集持续时间，单位为秒
* provider_limit：数据服务开启的最低数据提供者的注册数量
* update_cycle: update_number更新周期，超过这个周期将进入下一个update_number，单位为秒
* ~~update_start_time：数据更新开始时间，格式：2019-07-29T15:27:33.216857+00:00，时间需要在未来的某一时刻，尽量保证该时间provider_limit个数据提供者已经注册，~~
## 3.2 注册服务
       提供者想注册服务的时候,可以通过命令 
```
cleos get table ${contract_oracle}  ${contract_oracle} dataservices 
```
      查看当前所有服务的详细信息,选择自己想要的服务进行注册;如果如果没有找到自己想要注册的服务,可以按照3.1 创建服务 先将服务创建出来,然后再进行本次注册步骤。

命令：
```
cleos transfer ${provi_account}  ${contract_oracle}  "1000.0000 BOS" "0,${service_id}" 
```

参数说明：
* 0：固定的参数，0表示功能类型为注册服务
* service_id：表示想要注册的服务的id

**例如:**
说明：预言机合约:oracletest31  数据提供者账户:oracleprovi1
步骤1：查看所有服务信息
```
:~# cleos get table oracletest31 oracletest31  dataservices
{
  "rows": [{
      "service_id": 1,
      "data_type": 0,
      "status": 1,
      "injection_method": 0,
      "acceptance": 3,
      "duration": 3000,
      "provider_limit": 3,
      "update_cycle": 3600,
      "last_update_number": 0,
      "appeal_freeze_period": 0,
      "exceeded_risk_control_freeze_period": 0,
      "guarantee_id": 0,
      "base_stake_amount": "1000.0000 BOS",
      "risk_control_amount": "0.0000 BOS",
      "pause_service_stake_amount": "0.0000 BOS",
      "data_format": "json",
      "criteria": "以多数人为准",
      "declaration": "该数据具有时效性",
      "update_start_time": "2019-09-18T03:00:00"
    },{
      "service_id": 2,
      "data_type": 0,
      "status": 0,
      "injection_method": 0,
      "acceptance": 3,
      "duration": 3000,
      "provider_limit": 3,
      "update_cycle": 3600,
      "last_update_number": 0,
      "appeal_freeze_period": 0,
      "exceeded_risk_control_freeze_period": 0,
      "guarantee_id": 0,
      "base_stake_amount": "1000.0000 BOS",
      "risk_control_amount": "0.0000 BOS",
      "pause_service_stake_amount": "0.0000 BOS",
      "data_format": "{\"data\":\"2019-05-07\",\"time\":\"12:22:21\"}",
      "criteria": "以多数人为准",
      "declaration": "该数据具有时效性",
      "update_start_time": "2019-09-19T03:00:00"
    }
  ],
  "more": false
}
```

步骤2：注册服务id为1 的服务(如果注册自己创建的服务,需要根据步骤1找到自己创建的服务id,再进行注册)
```
cleos transfer oracleprovi1 oracletest31 "1000.0000 BOS" "0,1"
```

步骤3：注册成功后，可以通过命令查看到当前服务下有自己的账户oracleprovi1
```
cleos get table oracletest32 1 svcprovision
{
  "rows": [{
      "service_id": 1,
      "account": "oracleprovi1",
      "amount": "1000.0000 BOS",
      "freeze_amount": "0.0000 BOS",
      "service_income": "0.0000 BOS",
      "status": 0,
      "public_information": "",
      "create_time": "2019-09-26T02:30:31"
    }
  ],
  "more": false
}
```
## 3.3 解抵押
      数据提供者的服务抵押金额可以减少，但是减少后的抵押金额不能低于服务设置的最低金额。

命令：
```
cleos push action ${contract_oracle} unstakeasset '{"service_id":${service_id},"account":"${provi_account}","amount":"1.0000 BOS","memo":"unstake mount"}' -p ${provi_account} 
```

参数说明：
* service_id：提供者想要解抵押的服务的id
* account：想要解抵押的提供者
* amount：解抵押金额
* memo：备注信息
## 3.4 上传数据
        用户注册成功后，即可将自己的数据上传到Oracle服务中，上传数据到服务器的想相关命令有三种：单个上传、修改、多个上传。

单个上传命令：
```
cleos push action ${contract_oracle} pushdata '{"service_id":1,"provider":"${provi_account} ","update_number":"3","request_id":0,"data_json":"1 test data json 3 "}' -p ${provi_account} 
```

参数说明：
* service_id：服务id
* provider：上传数据的提供者
* update_number：更新编号，编号是根据服务的update_start_time和update_cycle计算出来的，计算公式update_number=**(当前时间-update_start_time)/update_cycle;**其中超过duration时，是不允许上传数据的
* request_id：数据使用者发起请求的时候带的id，数据提供者上传数据需要对应，1.0版本request_Id为0
* data_json：为上传数据的格式，所有的数据提供者需要按照服务的规定上传数据，否则回认为数据不一致，服务无法显示上传的数据
# 四、DAPP项目方如何使用预言机服务提供的数据
       1.0版本中获取数据很方便，只要数据服务提供者按照规则正确上传了数据，根据服务id通过查数据表即可获取数据。如果服务是确定性数据类型，则每个update_number只能看到一条数据；若服务为不确定性数据类型，服务的每个update_number能看到多条数据，用户需要根据自己的需要进行选择。

命令：
```
cleos get table ${contract_oracle} ${service_id} oracledata
```

参数说明：
* service_id：服务id，为1、3、4、5.....

**确定性数据：**
以彩票结果为例，oracletest32为预言机合约账户，服务id 5 为彩票结果服务
```
:~#cleos get table oracletest32 5 oracledata
{
  "rows": [{
      "record_id": 0,
      "request_id": 0,
      "update_number": 2,
      "data": "02 03 01 17 12 04 05",
      "timestamp": 1569554558
    },{
      "record_id": 1,
      "request_id": 0,
      "update_number": 4,
      "data": "02 12 34 11 02 04 15",
      "timestamp": 1569563694
    }
  ],
  "more": false
}
```


**不确定数据：**
以btc价格为例，先使用命令查找到当前的服务id，oracletest32为预言机合约账户
```
:~#cleos get table oracletest32 oracletest32  dataservices
{
      "service_id": 7,
      "data_type": 1,
      "status": 0,
      "injection_method": 0,
      "acceptance": 3,
      "duration": 3000,
      "provider_limit": 3,
      "update_cycle": 3600,
      "last_update_number": 0,
      "appeal_freeze_period": 0,
      "exceeded_risk_control_freeze_period": 0,
      "guarantee_id": 0,
      "base_stake_amount": "1000.0000 BOS",
      "risk_control_amount": "0.0000 BOS",
      "pause_service_stake_amount": "0.0000 BOS",
      "data_format": "json",
      "criteria": "BTC price,the data is not certain,user should according to your own needs.",
      "declaration": "",
      "update_start_time": "2019-09-27T02:52:34"
    }
    
```
通过服务id获取当前服务所有的btc价格
```
:~#cleos get table oracletest32 7 oracledata
{
  "rows": [{
      "record_id": 0,
      "request_id": 0,
      "update_number": 1,
      "data": "time:2019-09-27T03:27:33.216857+00:00,price:8901 USDT",
      "timestamp": 1569552869
    },{
      "record_id": 1,
      "request_id": 0,
      "update_number": 1,
      "data": "time:2019-09-27T03:29:33.216857+00:00,price:8911 USDT",
      "timestamp": 1569552932
    },{
      "record_id": 2,
      "request_id": 0,
      "update_number": 1,
      "data": "time:2019-09-27T03:29:33.216857+00:00,price:8910 USDT",
      "timestamp": 1569552965
    }
  ],
  "more": false
}
```
# 五、如何使用预言机服务进行仲裁
## 5.1 注册仲裁员（抵押）
        第一届全职仲裁员由21个指定的BOS WPS Auditors来担任；后期开放社区注册，为了保证仲裁有效且公正，仲裁员竞选者需要经过社区的投票，满足条件才有资格当选。注册时最低抵押金不低于 100000  BOS。

命令：
```
cleos transfer ${provi_account}  ${contract_oracle} "10000.0000 BOS" "4,1" -p ${provi_account}  
```

参数说明:
* 4:功能类型为注册仲裁员
* 仲裁员类型:可以填写1  或 2;1为全职仲裁员，2为大众仲裁员（暂不支持大众仲裁员）
## 5.2 仲裁
      如果用户在使用过程中，预言机服务数据有问题，需要仲裁解决，可以申请仲裁。

申请仲裁的流程如下图：
![图片](https://uploader.shimo.im/f/bjEksSfs6rIToPPq.png!thumbnail)

       其中，裁定结果根据一半以上的仲裁员的结果为准。 当1/2全职仲裁员仲裁结果一致，此轮仲裁结束；如果败诉的一方，有异议，可以再规定的时间-24小时内，发起再次上诉，会由更多的全职仲裁员裁决，全职仲裁员的增长指数 2^n+1 且不重复，保证仲裁员的公平，直至第三轮结束后，仲裁最终结束，不能再次申诉。

说明：
* 如果受诉方没有接受应诉，系统会判定该角色败诉，扣除相应的押金，若为数据提供者扣除该服务的抵押保证金。
* 如果仲裁员没有应诉，系统会重新从剩余的仲裁员中选择适合的人数发送邀请通知。
* 仲裁过程会通过转账方式发送通知给相应的账户，希望相关方能够关注。

可以通过命令查看仲裁当前的流程以及相关信息
```
cleos get table ${contract_oracle} ${service_id} arbicase
```

仲裁执行状态"arbi_step"：
   step 1：仲裁开始
   step 2：选择仲裁员
   step 3：等待应诉
   step 4：等待仲裁员接受邀请
   step 5：等待仲裁员上传结果
   step 6：等待再申诉
   step 7：应诉超时
   step 8：再申诉超时
   step 9：仲裁公布结果


**举例：**查看仲裁id为4的仲裁情况，oracle 合约名称为oracletest32
```
:~# cleos get table oracletest32 4 arbicase
{
  "rows": [{
      "arbitration_id": 4,
      "arbi_step": 6,
      "arbitration_result": 2,
      "last_round": 2,
      "final_result": 0,
      "arbitrators": [
        "arbitrator12",
        "arbitrator14",
        "arbitrator35",
        "arbitrator23",
        "arbitrator15",
        "arbitrator42",
        "arbitrator22",
        "arbitrator13"
      ],
      "chosen_arbitrators": [
        "arbitrator12",
        "arbitrator35",
        "arbitrator14",
        "arbitrator23",
        "arbitrator15",
        "arbitrator42",
        "arbitrator22",
        "arbitrator13"
      ]
    }
  ],
  "more": false
}
```
由上面可以看出，当前仲裁流程走到了“等待再应诉”（这个过程超过24小时没有人发起应诉，仲裁结束），当前仲裁结果为“2--数据提供者胜利”，以及轮次和仲裁员等相关信息。


### 5.2.1 账户发起申诉
        数据使用者或者某个数据提供者发现有人作弊，提供错误的虚假信息，都可以发起申诉，申诉时抵押金额不得低于200BOS，再次申诉时候，抵押金不得低于400 BOS，最低抵押金额成指数2^n增长。

命令:
```
cleos transfer ${provi_account}  ${contract_oracle} "200.0000 BOS" "3,${service_id},'evidence','info','reason'" -p ${provi_account} 
```

参数说明:
* 3:功能类型为申诉
* service_id:想要申诉的服务id
* evidence:申诉时提交的证据
* info:公示信息
* reason:申诉该服务的原因

        申诉命令发出后，会通过transfer发出通知，通知给所有受诉方，任何一个账户应诉（包含通知之外的账户），案件均可以成立。
### 5.2.2 受诉账户应诉
        当有人申诉时，相关人员会接收申诉通知，这时需要执行应诉命令告知对方接受申诉，这时仲裁流程正式开启；如果没有人应诉，超时后，将直接判定申诉者为胜利一方，如果是数据提供者是败诉方，会将该数据服务所有 抵押金均扣除，分配给申诉者。
        其中申诉抵押金第一轮至少200BOS，之后以指数方式 2^n 增长，n为轮数。

命令：
```
cleos  transfer ${provi_account}   ${contract_oracle}  "200.0000 BOS" "5,${arbitrat_id}],'evidence'" -p ${provi_account} 
```

参数说明:
* 5：功能类型为“应诉“
* arbitrat_id：服务id
* evidence：应诉时提交的证据
### 5.2.3 仲裁员接受邀请
        当数据提供者应诉后，会给仲裁员发送仲裁邀请，只有2^n+1个仲裁员接受邀请后，才能进入下一步--上传仲裁结果，如果有仲裁员超时接受邀请，则会重新从剩余的仲裁员中选择，直至2^n+1个仲裁员全部接受，其中n代表轮数。

命令：
```
cleos push action ${contract_oracle}  acceptarbi '["${arbitrator}",${arbitrat_id}]' -p ${arbitrator}@active 
```
参数说明：
* arbitrator：接收仲裁邀请的仲裁员
* arbitrat_id：接收邀请的仲裁id
### 5.2.4 仲裁员上传仲裁结果
 接受仲裁邀请的人可以上传自己的仲裁结果。

命令：
```
cleos push action ${contract_oracle} uploadresult '["${arbitrator}",${arbitrat_id}, ${result},'memo']' -p arbitrator12@active
```

参数说明：
* arbitrator：仲裁员
* arbitrat_id：仲裁id
* result：1/2  1-数据使用者胜利  2-数据提供者胜利；最终结果以这个结果为准
* memo：备注信息
### 5.2.5 仲裁结束
仲裁结束有两种：
* 仲裁结果上传后，如果没有人再次发起申诉， 72小时后，该仲裁关闭；
* 同一个仲裁案件，进行了三轮仲裁后，立即结束仲裁。

仲裁结束后，本次仲裁得出最终结果，相关账户得奖励/惩罚。

## 5.3 仲裁相关者可以领取仲裁案件的收益
    仲裁案件结束之后，参与仲裁的相关人员可以得到奖励，因为仲裁过程中涉及到三个不同的角色，申诉者、应诉者、仲裁员，针对不同的觉得收益的分配方式也不同。仲裁员：仲裁收益主要来源于**败诉者抵押金**。胜利者：如果是**数据使用者**胜利，则数据提供者所有的**服务抵押金**额都会被平均分配给所有的**申诉账户**；如果是**数据提供者**胜利，则没有仲裁收益。仲裁收益需要主动领取。

查看仲裁收益命令：
```
cleos get table ${contract_oracle} ${account}  arbiincomes
```

领取收益的命令：
```
cleos push action ${contract_oracle} claimarbi '["${account_1}","${account_2}"]' -p ${account_1}
```

参数说明：
* account_1：在仲裁案件中有收益的账户
* account_2: 领取收益时，收益的接收账户


## 5.4解除仲裁抵押
仲裁结束后，胜利者可以将自己抵押的token解抵押，通过查表方式查看自己的抵押金额。

1. **查询该仲裁当前抵押token数命令：**
```
cleos get table ${contract_oracle}  ${arbitrat_id} arbistakeacc
```

参数说明：
arbitrat_id:表示想要查询的仲裁案件id，若当前仲裁案件已经结束，该值为9223372036854775808+arbitrat_id
1. **解抵押命令：**
```
cleos push action ${contract_oracle} unstakearbi  '{"arbitration_id":${arbitrat_id},"account":"${account_1}","amount":"100.0000 BOS","memo":"unstake mount"}' -p ${account_1} 
```

参数说明：
arbitration_id：仲裁id
account：解抵押的账户名
amount：解抵押的token的个数，不能大于抵押的数量
memo：备注

# 六、transfer memo涉及到的说明
### memo整体格式：
memo说明："功能类型,服务id,....."

1. **注册服务：**

memo说明："0,服务id"
```
cleos transfer ${provi_account}  ${contract_oracle}  "1000.0000 BOS" "0,${service_id}" 
```

1. **申诉服务：**

memo说明："3,服务id,证据,公示信息,申诉原因"
```
cleos transfer ${provi_account}  ${contract_oracle} "200.0000 BOS" "3,${service_id},'evidence','info','reason'" -p ${provi_account}   
```

1. **应诉：**

memo说明："5,服务id,证据"
```
cleos transfer ${provi_account}  ${contract_oracle} "200.0000 BOS" "5,${service_id},'evidence'" -p ${provi_account} 
```

1. **注册仲裁员：**

memo说明："4,服务id"
```
cleos transfer ${provi_account}  ${contract_oracle} "10000.0000 BOS" "4,1" -p ${provi_account}  
```
# 七、预言机合约表查表汇总
1. **查询所有当前服务信息**
```
cleos get table ${contract_oracle} ${contract_oracle}                                                dataservices
```

2. **查询某个服务的详细信息**
```
cleos get table ${contract_oracle} ${service_id} svcprovision
```

3. **查询某个服务的所有数据显示**
```
cleos get table ${contract_oracle} ${service_id} oracledata
```

4. **查询当前所有数据提供者信息**
```
cleos get table ${contract_oracle} ${contract_oracle} providers
```

5. **查询当前所有仲裁人员信息**
```
cleos get table ${contract_oracle} ${contract_oracle} arbitrators
```

6. **查询某个仲裁案件的流程进度**
```
cleos get table ${contract_oracle} ${arbitrat_id} arbicase
```

7. **查询某个仲裁案件上传的证据**
```
cleos get table ${contract_oracle} ${arbitrat_id} arbievidence
```

8. **查询某个正处于仲裁案件中的抵押金的信息**
```
cleos get table ${contract_oracle} ${arbitrat_id} arbistakeacc
```

9. **查询某个已结束的仲裁案件的抵押金信息**
```
cleos get table ${contract_oracle}  ${9223372036854775808+arbitrat_id} arbistakeacc
```

10. **查看仲裁收益表**
```
cleos get table ${contract_oracle} ${account}  arbiincomes
```


# 

# --------------分割线--下方不写入1.0 版本文档-----------------
## 1.2 风控
风控用户解决提供者和使用者**信息不对称问题**
oracle提供**法庭**，给一个公正决策
让服务提供者损失大于收益，但惩罚需要滞后性


首个服务提供者注册之后可以设置：
1. 设置费用、包括单次、按月、费用类型、价格；
2. 设置订阅费用，订阅以后需要预付费，单条、m多条的费用（同一条数据推给多个订阅）
3.  withdraw deposit 

注意：
* 同一个服务器，第二个注册的用户不少于第一个用户抵押的token。
* 服务注册之后，若第一个人设置最低三个人提供数据，当数据提供者达到3个用户的时候，用户才能够获取数据
* 如果第一个人初始化的时候，设置的最低提供这人数为2，那么至少要有两个用户注册这个服务并提供数据，这个服务才可以提供外部使用。

服务的价格格式验证，接受方式，确定性的数据类型，不确定的类型需要注意i一下。五个使用者，抵押命令需要直接扣除，action的时候 transfer可以直接抵押，第一个注册抵押一万，后一个至少一晚，数据持续时间，多长时间推送一次，超过的时间就无效，服务注册以后，最低需要3个数据提供者有3个，3个以上的数据才有效，达不到就没消
## 2.3 注销
      数据提供者不想提供数据的时候，可以选择注销。用户注销后，不能再上传数据，也不能获得之后的收益，但是注销后，用户依旧可以领取之前未领取的收益。

执行命令：
```

```

临时注销：
用户注销后，数据还存在，但是无法上传数据，服务被申诉后，无法收到申诉通知（临时注销暂时不提供服务，资金会冻结，用户表状态status变成2，冻结了不能解抵押，比如有3个人提供数据，其中一个人冻结了，整个服务不可以用）

## 2.4 领取收入
        数据提供者提供了数据之后，有人使用，便可以获得奖励，可以采用下面的命令领取。奖励每隔24小时才可以领取一次。
```
cleos push action ${contract_oracle} claimreward '{"service_id":"0","claim_account":"'${consumer1111}'"}' -p ${consumer1111}@active
```


数据使用者

BOS提供Oracle功能，有用户想要获取链外的数据，可以通过Oracle合约中的服务，Oracle中有人注册响应的服务并提供数据，用户即可以获取到自己想要的该服务的数据。

        数据使用者使用数据有两种方式，包月和单次。如果用户想以包月方式获取数据，需要使用订阅命令；如果用户想只获取一次数据，直接执行requestdata。但是在使用之前需要给自己的账户进行充值，充值后，会根据操作进行不同的扣费方式。
## 3.1 充值
充值的方式通过cleos的转账进行，在转账的时候通过memo备注，memo的格式："1,服务id"

例如：
```
 cleos transfer ocdappuser11  ${contract_oracle} "0.0001 BOS" "1,1" 
```
## 3.2 订阅服务
订阅命令：
```
cleos push action ${contract_oracle} subscribe   '{"service_id":"0","contract_account":"'${contract_consumer}'","action_name":"receivejson", "publickey":"","account":"'${consumer1111}'","amount":"10.0000 BOS", "memo":"test"}' -p ${consumer1111}@active
```

## 3.3 获取数据
用户通过命令单次获取单次收费
```
cleos push action ${contract_oracle} requestdata '{service_id":0,  "contract_account":"'${contract_consumer}'","action_name":"receivejson","requester":"'${consumer1111}'", "request_content":"eth usd"}' -p ${consumer1111}@active
```

注册仲裁员
只有数据的提供者和使用者才可以注册仲裁员。仲裁员分为全职仲裁员和大众仲裁员，用户在注册仲裁员的时候可以自己选择注册全职仲裁员还是大众仲裁员。主要区别是：1）注册全职仲裁员时抵押的token比大众仲裁员抵押的token多。2）走仲裁流程时，仲裁员的裁决过程。

按照eosio的模板整理oracle文档：[https://developers.eos.io/eosio-home/docs/10-big-picture](https://developers.eos.io/eosio-home/docs/10-big-picture)
