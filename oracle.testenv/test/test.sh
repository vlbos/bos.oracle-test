#!/usr/bin/env bash

transfernormal(){
    echo $1
    cleos -u http://47.245.57.192:2027 get block $1|grep name 
}


once(){
    for i in {8873..9999}; do transfernormal ${i} && sleep .1 ;done
    

 }

once