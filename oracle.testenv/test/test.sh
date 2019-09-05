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
# test_for


# shell中获取时间戳的方式为：date -d “$currentTime” +%s

# $ date -d @1337743485671 "+%c"
# Sun 28 May 44361 12:41:11 PM CST

# 如果要将一个日期转为时间戳，方式如下：

# 1、得到当前时间

# currentTime=`date “+%Y-%m-%d %H:%M:%S”`

# 2、将日期转为时间戳

# currentTimeStamp=`date -d “$currentTime” +%s`
# echo $currentTimeStamp

# 3.字符串转换为时间戳可以这样做：

# date -d "2010-10-18 00:00:00" +%s

# 输出形如：

# 1287331200

# 其中，-d参数表示显示指定的字符串所表示的时间，+%s表示输出时间戳。

# 4.而时间戳转换为字符串可以这样做：

# date -d @1287331200

# 输出形如：

# Mon Oct 18 00:00:00 CST 2010
test_date_timestamp()
{
# currentTime="2019-07-29T15:27:33.216857+00:00"
# currentTimeStamp="date -d "$currentTime" +%s"
# echo $currentTimeStamp
# currentTime=`date “+%Y-%m-%d %H:%M:%S”`


# currentTimeStamp=`date -d "$currentTime" +%s`
# echo $currentTimeStamp
# date -d "2010-10-18 00:00:00" +%S
# date -d @1287331200
# date -d "1970-01-01 UTC 1287331200 seconds" "+%F %T"
date +%s
date -r 1456303554 
date -j -f "%Y-%m-%d %H:%M:%S" "2018-12-01 00:00:00" "+%s"
start_time=$(date -j -f "%Y-%m-%d %H:%M:%S" "2019-07-29 15:23:33" "+%s")
datetime1=$(date "+%s#%N")
datetime2=$(echo $datetime1 | cut -d"#" -f1) #取出秒
diff_time=$(($datetime2-$start_time))
echo $datetime2
echo ${start_time}
echo $diff_time
update_start_time_date="2019-07-29"
update_start_time_time="15:27:33"
u_start_time=$(date -j -u -f "%Y-%m-%d %H:%M:%S" $update_start_time_date" "$update_start_time_time "+%s")
echo $u_start_time

echo $(((1564385253-1564414053)/3600))

}
test_date_timestamp