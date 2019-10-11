
1. service_history提供服务数据历史
   
| **字段名**   | **字段类型**   | **字段含义**   | 
|:----|:----|:----|
| history_id   | int64   | 主键,自增   | 
| sid   | int64   | 服务ID   | 
| request_id   | int64   | 请求ID   | 
| cycle_number   | int64   | 更新序列号   | 
| timestamp   | int64   | 时间戳   | 
| provider   | string   | 数据提供者   | 
| data   | string   | 服务数据内容   | 

  数据来源
action oracle 合约 pushdata

1. service_history:使用服务数据历史  
   

| **字段名**   | **字段类型**   | **字段含义**   | 
|:----|:----|:----|
| history_id   | int64   | 主键,自增   | 
| sid   | int64   | 服务ID   | 
| request_id   | int64   | 请求ID   | 
| cycle_number   | int64   | 更新序列号   | 
| timestamp   | int64   | 时间戳   | 
| consumer   | string   | 数据使用者   | 
| consumer_contract   | string   | 数据使用者 合约账户   | 


数据来源
action oraclepush (deferred transaction)


1. finance_history:数据使用者支付套餐记录
   
| **字段名**   | **字段类型**   | **字段含义**   | 
|:----|:----|:----|
| record_id   | int64   | 主键,自增   | 
| sid   | int64   | 服务ID   | 
| consumer   | string   | 数据使用者   | 
| request_id   | int64   | 请求ID   | 
| package_id   | int64   | 套餐ID | 
| amount   | float64   | 数量   | 

数据来源
action eosio.token transfer memo '1，' 第一个参数为transfer类型值1 ,表示transfer为请求支付.


1. 数据服务套餐
   
| **字段名**   | **字段类型**   | **字段定义**   | 
|:----|:----|:----|
| sid   | int64   | 服务ID   | 
| Package ID   | uint64_t   | 套餐ID,自增   | 
| duration   | uint64_t   | 费用有效时长,单位：秒   | 
| Service Price   | asset   | 服务价格   | 
| times   | uint32_t   | 次数   | 
| ctime   | int64   | 创建时间   | 

数据来源
oracle 合约表  数据服务套餐费用表

| **中文表名**   | 数据服务套餐费用表 | 
|:----|:----:|
| **英文表名**   | Data Service Package Fee Table  | 
| **定义表名**   | data_service_package_fee | 
| **短表名**   | packagefees | 
| **作用域(scope)**   | service_id | 
| **表功能描述**   | 定义oracle数据服务费用信息 | 





### 5.请求数据服务

| **字段名**   | **字段类型**   | **字段定义**   | 
|:----|:----|:----|
| sid   | int64   | 服务ID   | 
| request_id   | int64   | 请求ID   | 
| payment ID   | uint64_t   | 支付ID   | 
| duration   | uint64_t   | 费用有效时长,单位：秒   | 
| Service Price   | asset   | 服务价格   | 
| times   | uint32_t   | 次数   | 
| ctime   | int64   | 创建时间   | 


数据来源
oracle action 'requestdata' 和 合约表 付款表

| **中文表名**   | 付款表 |    
|:----|:----:|
| **英文表名**   | payment Table |   
| **定义表名**   | payment |    
| **短表名**   | payment |    
| **作用域(scope)**   | service_id |   
| **表功能描述**   | 定义提供数据服务与数据使用者间关系 |    




