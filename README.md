# 自动上传预言机数据

## 一 创建特定provider JS文件

## 二 pm2的配置
```shell
cd pm2

touch provider${number}${biz}.json
```

```json
{
    "apps": [
        {
            "name": "provider1oil",        //进程名称
            "script": "provider1oil.js",   //提供者获取数据上传主逻辑
            "cwd": "/Users/chenpuxin/Code/BOSCORE/neworacletest",  //项目绝对路径
            "exec_mode": "fork",
            "max_memory_restart": "1G",
            "autorestart": true,
            "node_args": [],
            "args": [],
            "env": {                                      //项目的环境变量
                                                          //节点信息
                "EOS_PROTOCOL":"https",
                "EOS_HOST":"api-bostest.blockzone.net",
                "EOS_PORT":"443",
                "EOS_CHAIN":"33cc2426f1b258ef8c798c34c0360b31732ea27a2d7e35a65797850a86d1ba85",
                                                        //数据提供者信息
                "PROVIDER" : "oracleprovi1",            //数据提供者名称
                "EOS_KEY":"5JH2RzGXnxpmZVaThbbUBjRzXhr5NrpkTngopKUg491xxxxxxx",
                "ORACLE_PERMISSION":"active",           //数据提供者权限

                "ORACLE":"eosio",
                "CONTRACT":"oracle.bos",               //合约名称
                "FREQ":"600000",
                "SERVICE_ID" : "7",                     //服务id
                "UPDATE_CYCLE" : "60",                  //数据提供周期 60s推送数据一次
                "DURATION" : "51",                      //可以提供数据的期限
                "UPDATE_START_TIME" : "1575517550",     //服务创建的时间
                "TIMER_TICKER" : "0 */1 * * * *"        //定时器表达式
            }
        }
    ]
}
```

## 三 运行所有服务
```shell
#terminal启动
pm2 start pm2/*

#查看程序的log
pm2 log
``` 