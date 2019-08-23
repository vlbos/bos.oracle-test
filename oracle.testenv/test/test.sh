# #!/usr/bin/env bash

# transfernormal() {
#     echo $1
#     cleos -u http://47.245.57.192:2027 get block $1 | grep name
# }

# once() {
#     # for i in {8873..9999}; do transfernormal ${i} && sleep .1 ;done
#     # for i in {1..5}; do
#     # echo provider${i}${i}${i}${i}
#     # p=provider${i}${i}${i}${i}
#     # echo 'p='${p}
#     #  sleep .1
#     # done
#     datetime1=$(date "+%s#%N")
#     datetime2=$(echo $datetime1 | cut -d"#" -f1) #取出秒

#     echo $datetime2
#     d=$(($datetime2 + 1))
#     echo $d
#     echo $(($datetime2 / $d))

# }

# # once

# current_update_number=0
# datetime1=$(date "+%s#%N")
# datetime2=$(echo $datetime1 | cut -d"#" -f1) #取出秒

# get_current_date() {
#     datetime1=$(date "+%s#%N")
#     datetime2=$(echo $datetime1 | cut -d"#" -f1) #取出秒
# }

# waitnext() {
#     get_current_date
#     i=$(($datetime2))
#     while [ $i -le $1 ]; do
#         get_current_date
#         i=$datetime2
#         sleep 10
#     done
# }

# get_update_number() {
#     a=$1
#     b=$2
#     if [ $a -eq 0 ]; then return 0; fi
#     if [ $b -eq 0 ]; then return 0; fi

#     get_current_date

#     current_update_number=$(($datetime2 / $a))
#     begin_time=$(($current_update_number * $a))
#     end_time=$(($begin_time + $b))
#     # if [ 0 -le  $1 ]; then return 0; fi
#     if [ $datetime2 -le $end_time ]; then return $current_update_number; fi
#     next_begin_time=$(($begin_time + $a))
#     waitnext $next_begin_time
#     get_update_number $a $b

# }

# test() {
#     get_update_number $1 $2

#     echo 'end='$current_update_number
# }

# test 300 100

# #  test1 50 70
# #将命令的结果赋给变量total
test_for()
{
  ACCOUNTS=("appeallant" "arbitrator")

for a in ${ACCOUNTS[*]}; do
    for i in {1..5}; do
    for j in {1..5}; do
        account=${a}${i}${j}
        # echo  -e "\n creating $account \n"; 
        # new_account c1 ${account}; 
       # sleep 1; 
    done
    done
done
}
test_for