bos.oracle
----------

BOS的预言机增加BOS的应用场景，将区块链应用落地不依靠任何权威背书，去中心化仲裁解决方案。与其他已有预言机的对比,竞品分析,
 
BOS解决方案：采用对信息提供者的松耦合设计，基于bos底层的功能引入以及数据存储。 引入第三方仲裁方案来处理非确定性的问题。为了应对不同情形，不同级别的预言机服务冲突进行处理，
采用双向举证，不同的仲裁员和多轮仲裁判决确定最终仲裁结果。在仲裁中采用抵押机制作为最终处罚锚点，申诉制和检举制同时进行，相互监督；用收益分成以及惩罚金作为奖励的方式激励仲裁员，
并且引入信用体系以实现非一次性博弈下模型的稳定和可信。

* 预言机服务功能：提供数据、获取数据、仲裁功能
* 预言机服务角色：提供者、 使用者、 合约、 仲裁员
* 预言机服务特点：完善的仲裁体系,博弈模型,正向激励仲裁员

1. 提供数据功能 预言机服务主要是提供数据服务平台，有数据资源的参与方，可以在BOS上创建自己的数据服务，上传数据供大家使用，将数据变现。
2. 获取数据功能 数据使用者可以根据自己的需求使用已有预言机服务，也可以作为发起方参与到对应预言机服务当中，并从服务上获取自己想要的数据。
3. 仲裁功能 引入仲裁的作用是保证整个预言机系统是一个完备的博弈系统，保证系统贡献者可以获取收益，作弊者可以收到对应的惩罚。在使用过程中，如果预言机提供的数据有问题可以通过仲裁的方式来解决。并且支持多轮仲裁,经过多轮不重复的仲裁员裁决,保证最终仲裁结果是最公平的结果。


### 模块


* [数据提供者--bos.provider.cpp](https://github.com/boscore/bos.contracts/tree/oracle.bos/contracts/bos.oracle/src/bos.provider.cpp)
* [数据使用者--bos.consumer.cpp](https://github.com/boscore/bos.contracts/tree/oracle.bos/contracts/bos.oracle/src/bos.consumer.cpp)
* [仲裁--bos.arbitration.cpp](https://github.com/boscore/bos.contracts/tree/oracle.bos/contracts/bos.oracle/src/bos.arbitration.cpp)
* [风控--bos.riskcontrol.cpp](https://github.com/boscore/bos.contracts/tree/oracle.bos/contracts/bos.oracle/src/bos.riskcontrol.cpp)
* [计费统计--bos.fee.cpp](https://github.com/boscore/bos.contracts/tree/oracle.bos/contracts/bos.oracle/src/bos.fee.cpp)


### 文档

* [使用文档](https://github.com/vlbos/Documentation-1/blob/master/Oracle/bos_oracle_readme.md)
* [部署文档](https://github.com/vlbos/bos.oracle-test/blob/master/docs/bos_oracle_deployment.md)
* [一个简单的bos oracle 使用流程](https://github.com/vlbos/bos.oracle-test/blob/master/docs/bos_oracle_using_process.pdf)


### 源目录结构

```
├── include  
│   └── bos.oracle 
│       ├── bos.constants.hpp 
│       ├── bos.functions.hpp  
│       ├── bos.oracle.hpp  
│       ├── bos.util.hpp  
│       ├── example  
│       │   └── consumer.contract.hpp  
│       ├── murmurhash.hpp  
│       └── tables  
│           ├── arbitration.hpp 
│           ├── consumer.hpp  
│           ├── oracle_api.hpp 
│           ├── provider.hpp 
│           └── riskcontrol.hpp 
└── src 
    ├── bos.arbitration.cpp 
    ├── bos.consumer.cpp 
    ├── bos.fee.cpp 
    ├── bos.oracle.cpp 
    ├── bos.provider.cpp 
    ├── bos.riskcontrol.cpp 
    ├── bos.util.cpp 
    └── example 
        └── consumer.contract.cpp 
```