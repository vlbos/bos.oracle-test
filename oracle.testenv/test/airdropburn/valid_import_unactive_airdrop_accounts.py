#!/usr/bin/env python3

import argparse
import json
import numpy
import os
import random
import re
import subprocess
import sys
import time
import csv

args = None
logFile = None

cleos="/Users/lisheng/mygit/boscore/bos/build/programs/cleos/cleos --url http://127.0.0.1:8888 "

def jsonArg(a):
    return " '" + json.dumps(a) + "' "

def getOutput(args):
    # print('bios-boot-tutorial.py:', args)
    # logFile.write(args + '\n')
    proc = subprocess.Popen(args, shell=True, stdout=subprocess.PIPE)
    return proc.communicate()[0].decode('utf-8')

def getJsonOutput(args):
    return json.loads(getOutput(args))

def writeResult(resCsv):
    if len(resCsv)==0:
        return
    nonactive_airdrop_accounts_file="no.csv"
    with open(nonactive_airdrop_accounts_file, 'w') as cfile:
        writer = csv.writer(cfile)
        for item in resCsv:
            writer.writerow(item)

    cfile.close()

def loadcsv(csvFile):
    f = open(csvFile, 'r')
    reader = csv.reader(f)
    for item in reader:
        validAccount(item[0],item[1])
    f.close()

def validAccount(account,quantity):
    table = getJsonOutput(cleos + 'get table burn.bos ' + account + ' accounts -l 100')
    resCsv = []
    for row in table['rows']:
        if not row['account'] or row['quantity']!=quantity:
            resCsv.append([row['account'], row['quantity']])
        else:
            print(row['account'], row['quantity']," Yes ")
    writeResult(resCsv)

def validAccounts():
    loadcsv("./unactive_airdrop_accounts.csv")


validAccounts()

# contracts/bos.burn/scripts/valid_import_unactive_airdrop_accounts.py
# /Users/lisheng/mygit/boscore/bos/build 
# python3 valid_import_unactive_airdrop_accounts.py  -V