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
test_for() {
  ACCOUNTS=("provider" "consumer")
  provider_pubkeys=("p1" "p2" "p3" "p4" "p5")
  consumer_pubkeys=("c1" "c2" "c3" "c4" "c5")

  for a in ${ACCOUNTS[*]}; do
    for i in {1..5}; do
      account=${a}${i}${i}${i}${i}
      account_pubkey_arr=${a}"_pubkeys"
      account_pubkey_v=${account_pubkey_arr}[${i}]
      account_pubkey=${account_pubkey_v}
      echo -e "\n creating $account  $account_pubkey\n"
      # new_account c1 ${account};
      # sleep 1;
    done
  done
}
# test_for

test_dyn_arr() {
  # sepulchers
  # shell动态数组变量
  A=('B' 'C')
  B_1=(1 2)
  C_1=('a' 'b')

  for index in ${A[@]}; do
    tmp_arr_name=${index}_1[@]

    declare -a combine           #声明combine数组
    combine=(${!tmp_arr_name})   #combine是数组city和person的连接，连接操作将不连续的元素按序存放到combine数组中

    element_count=${#combine[@]} #while循环输出combine数组
    index=0
    while [ "$index" -lt "$element_count" ]; do
      echo "11Element[$index]=${combine[$index]}" #数组标号与值的对应关系
      let "index=$index+1"
    done

    # declare -a subcombine=${!tmp_arr_name} #声明数组时赋值
    # element_count=${#subcombine[@]}
    # index=0
    # while [ "$index" -lt "$element_count" ]; do
    #   echo "Element[$index]=${subcombine[$index]}"
    #   let "index=$index+1"
    # done

    # for val in ${!tmp_arr_name}; do
    #   echo $val
    # done
  done
}

# test_dyn_arr

test_array() {
  city=("1" "2" "3")
  person=("a" "b" "c")              #数组不连续地赋值

  declare -a combine                #声明combine数组
  combine=(${city[@]} ${person[@]}) #combine是数组city和person的连接，连接操作将不连续的元素按序存放到combine数组中

  element_count=${#combine[@]} #while循环输出combine数组
  index=0
  while [ "$index" -lt "$element_count" ]; do
    echo "Element[$index]=${combine[$index]}" #数组标号与值的对应关系
    let "index=$index+1"
  done
  ###################
  echo
  unset combine           #清空combine数组
  combine[0]=${city[@]}   #将city数组赋给combine[0]的一个元素
  combine[1]=${person[@]} #将person数组赋给combine[1]的一个元素
  element_count=${#combine[@]}
  index=0
  while [ "$index" -lt "$element_count" ]; do
    echo "Element[$index]="${combine[$index]}
    let "index=$index+1"
  done
  ###################
  echo
  declare -a subcombine=${combine[1]} #声明数组时赋值
  element_count=${#subcombine[@]}
  index=0
  while [ "$index" -lt "$element_count" ]; do
    echo "Element[$index]=${subcombine[$index]}"
    let "index=$index+1"
  done

}

# test_array

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
test_date_timestamp() {
  # currentTime="2019-07-29T15:27:33.216857+00:00"
  # currentTimeStamp="date -d "$currentTime" +%s"
  # echo $currentTimeStamp
  # currentTime=`date “+%Y-%m-%d %H:%M:%S”`

  # currentTimeStamp=`date -d "$currentTime" +%s`
  # echo $currentTimeStamp
  # date -d "2010-10-18 00:00:00" +%S
  # date -d @1569467251
  # date -d "1970-01-01 UTC 1287331200 seconds" "+%F %T"
  date +%s
  date -r 1456303554
  date -j -f "%Y-%m-%d %H:%M:%S" "2018-12-01 00:00:00" "+%s"
  start_time=$(date -j -f "%Y-%m-%d %H:%M:%S" "2019-07-29 15:23:33" "+%s")
  datetime1=$(date "+%s#%N")
  datetime2=$(echo $datetime1 | cut -d"#" -f1) #取出秒
  diff_time=$(($datetime2 - $start_time))
  echo $datetime2
  echo ${start_time}
  echo $diff_time
  update_start_time_date="2019-07-29"
  update_start_time_time="15:27:33"
  u_start_time=$(date -j -u -f "%Y-%m-%d %H:%M:%S" $update_start_time_date" "$update_start_time_time "+%s")
  echo $u_start_time

  echo $(((1564385253 - 1564414053) / 3600))

  echo begin

  u_start_time=$(date -j -u -f "%Y-%m-%d %H:%M:%S" "2019-09-09 08:00:00" "+%s")
  log_start_time=$(date -j -u -f "%Y-%m-%d %H:%M:%S" "2019-09-09 08:20:32" "+%s")
  log_end_time=$(date -j -u -f "%Y-%m-%d %H:%M:%S" "2019-09-09 08:22:23" "+%s")
  u_n=$((($log_start_time - $u_start_time) / 600))

  echo $(($u_start_time+(u_n*600)))
  echo $log_end_time
  echo $((($log_end_time - $u_start_time) / 600))
  echo $((($log_start_time - $u_start_time) / 600))

  echo end


 test_start_time=$(date -j -f "%Y-%m-%d %H:%M:%S" "2019-09-12 09:09:09" "+%s")
 echo $test_start_time
 echo $datetime2

 date -d "1970-01-01 UTC 1569467251 seconds" "+%F %T"
}
# test_date_timestamp

provider_pubkeys=(
  "EOS6U2CbfrXa9hdKauZJxxbmoXACZ4MmAWHKaQPzCk5UiBmVhZRTJ" "EOS7qsja8UCa1ExokEb5wxCwBmJWi9aW1intH1sihNNHKoAGD6J7X" "EOS7yghCVnJHEu3TEB2nnSv1mgS5Rx8ofDyQK7C4dgbUWZCP1TtD1" "EOS6jmPJZAPAB7hBwYxwfKiwVuqSrkSyRy2E4mjTmQ2CyYas4ESuv" "EOS8hvj4KPjjGvfRfJsGEEbVvCXvAiGQ7GW345MH1r122g8Ap7xw3"
)

provider_prikeys=(
  "5K2L2my3qUKqj67KU61cSACoxgREkqGFi5nKaLGjbAbbRBYRq1m" "5JN8chYis1d8EYsCdDEKXyjLT3QmpW7HYoVB13dFKenK2uwyR65" "5Kju7hDTh3uCZqpzb5VWAdCp7cA1fAiEd94zdNhU59WNaQMQQmE" "5K6ZCUpk2jn1munFdiADgKgfAqcpGMHKCoJUue65p99xKX9WWCW" "5KAyefwicvJyxDaQ1riCztiSgVKiH37VV9JdSRcrqi88qQkV2gJ"
)

consumer_pubkeys=(
  "EOS6U2CbfrXa9hdKauZJxxbmoXACZ4MmAWHKaQPzCk5UiBmVhZRTJ" "EOS7qsja8UCa1ExokEb5wxCwBmJWi9aW1intH1sihNNHKoAGD6J7X" "EOS7yghCVnJHEu3TEB2nnSv1mgS5Rx8ofDyQK7C4dgbUWZCP1TtD1" "EOS6jmPJZAPAB7hBwYxwfKiwVuqSrkSyRy2E4mjTmQ2CyYas4ESuv" "EOS8hvj4KPjjGvfRfJsGEEbVvCXvAiGQ7GW345MH1r122g8Ap7xw3"
)

consumer_prikeys=(
  "5K2L2my3qUKqj67KU61cSACoxgREkqGFi5nKaLGjbAbbRBYRq1m" "5JN8chYis1d8EYsCdDEKXyjLT3QmpW7HYoVB13dFKenK2uwyR65" "5Kju7hDTh3uCZqpzb5VWAdCp7cA1fAiEd94zdNhU59WNaQMQQmE" "5K6ZCUpk2jn1munFdiADgKgfAqcpGMHKCoJUue65p99xKX9WWCW" "5KAyefwicvJyxDaQ1riCztiSgVKiH37VV9JdSRcrqi88qQkV2gJ"
)

create_pro_con_accounts() {

  ACCOUNTS=("provider" "consumer")

  for a in ${ACCOUNTS[*]}; do
    prikeys=${a}_prikeys[@]
    pubkeys=${a}_pubkeys[@]
    declare -a prikeys_arr    #声明combine数组
    prikeys_arr=(${!prikeys}) #combine是数组city和person的连接，连接操作将不连续的元素按序存放到combine数组中
    declare -a pubkeys_arr    #声明combine数组
    pubkeys_arr=(${!pubkeys}) #combine是数组city和person的连接，连接操作将不连续的元素按序存放到combine数组中

    for i in {1..5}; do
      account=${a}${i}${i}${i}${i}
      echo ${prikeys_arr[$(($i - 1))]}
      echo c1 ${account} ${pubkeys_arr[$(($i - 1))]}
      sleep 1
    done
  done

}

# create_pro_con_accounts


function usage(){
    echo "-h --help \n" \
         "  将10/13位时间戳转换为本地时间 \n"\
         "  参数：时间戳，支持10/13位两种 \n"\
         "  默认值：当前时间向后5min \n"\
         "  e.g. 1483430400(10位秒时间戳),1483430400000(13位毫秒时间戳) \n"
    exit 1
}

function t2dusage(){
###
os_platform=`uname -s`
if [[ $# -le 0 ]]; then
    echo "默认按照当前时间向后5min取值"
    if [[ "${os_platform}" = "Darwin" ]];then
        echo `date -v+5M +"%Y-%m-%d %H:%M:%S"`
    elif [[ "${os_platform}" = "Linux" ]];then
        echo `date -d +5min +"%Y-%m-%d %H:%M:%S"`
    fi
else
    case $1 in
      -h|--help)
          usage
      ;;
      *)
          timestampStr=${1}
          length=`echo ${#timestampStr}`
          if [[ ${length} -ne 10 ]] && [[ ${length} -ne 13 ]];then
              echo "请输入10/13位数字时间戳"
              exit 1
          elif [[ ${length} -eq 13 ]];then
              timestampStr=${timestampStr:0:10}
          fi
          echo "时间戳位：${timestampStr}"
      if [[ "${os_platform}" = "Darwin" ]];then
              dateStr=`date -r${timestampStr} +"%Y-%m-%d %H:%M:%S"`
          elif [[ "${os_platform}" = "Linux" ]];then
              dateStr=`date -d @${timestampStr} +"%Y-%m-%d %H:%M:%S"`
          fi
          echo "${1}对应的本地时间为${dateStr}"
      ;;
    esac
fi
}

t2dusage 1569467251
t2dusage 1569469800

function usage2(){
    echo "-h --help \n" \
         "  将本地时间转换为13位时间戳(毫秒时间戳) \n"\
         "  只有1个参数:本地时间，参数格式：'%Y-%m-%d %H:%M:%S' \n"\
         "  默认值：当前时间向后5min \n"\
         "  e.g. 2017-01-01 16:00:00 \n"
    exit 1
}

function d2tusage(){
##时间采用正则匹配
time_pattern="^[0-9]{4}-[0-9]{1,2}-[0-9]{1,2} [0-9]{1,2}:[0-9]{1,2}:[0-9]{1,2}"
os_platform=`uname -s`

if [[ $# -le 0 ]]; then
    echo "默认按照当前时间向后5min取值"
    if [[ "${os_platform}" = "Darwin" ]];then
        echo `date -v+5M +%s`000
    elif [[ "${os_platform}" = "Linux" ]];then
        echo `date -d +5min +%s`000
    fi
else
    case $1 in
      -h|--help)
          usage2
      ;;
      *)
          dateStr=${1}
          echo ${dateStr}
          if [[ "${dateStr}" =~ ${time_pattern} ]];then
              if [[ "${os_platform}" = "Darwin" ]];then
                  echo `date -j -f "%Y-%m-%d %H:%M:%S" "${dateStr}" +%s`000
              elif [[ "${os_platform}" = "Linux" ]];then
                  echo `date -d "${dateStr}" +%s`000
              fi
          else
              echo "时间格式不正确，请按照'%Y-%m-%d %H:%M:%S'格式输入，如'2017-01-01 16:00:00' "
          fi
      ;;
    esac
fi
}
count=1
if (($count == 1)) 
then
 echo "==1"
fi