


``` 
# step 1
cd ./clains-mgmt
./cluster.sh init
./cluster.sh start
tail -f node1.log
#tail -f node2.log

# step 2 ( in a new shell )
cd ./test
. chains_init.sh


# step 3 ( in a new shell )
cd ./test
. task_ibc_test.sh


# clear shell backgroud processes and log files
cd ./test
. clear.sh

```
