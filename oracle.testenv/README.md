


``` 
update part 
update file: test/env.sh
update  CONTRACTS_DIR
CONTRACTS_DIR=/Users/lisheng/mygit/vlbos/burn/${contract_repo_dir}/build/contracts/

update file: chains-mgmt/init.sh
update nodeos_repo_dir:
nodeos_repo_dir=${base_dir}/boscore/bos

# step 1
cd ./clains-mgmt
./cluster.sh init
./cluster.sh start
tail -f node1.log
#tail -f node2.log

# step 2 ( in a new shell )
cd ./test
. init_chains.sh


# step 3 ( in a new shell )
#deploy_test
cd ./test
. burn_test.sh set 


# clear shell backgroud processes and log files
cd ./test
. clear.sh


```
