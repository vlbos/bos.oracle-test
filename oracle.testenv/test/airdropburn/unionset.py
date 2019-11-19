# coding:utf-8
import csv
import re
import json
# txt


def loadtxt(txt):
    f = open(txt, 'r')
    sourceInline = f.readlines()
    dataset = []
    for line in sourceInline:
        temp1 = line.strip('\x00')
        temp1 = temp1.strip('\n')
        if (temp1 == ''):
            continue
        dataset.append(temp1.strip())
    f.close
    return dataset

# csv


def loadcsv(csvFile):
    f = open(csvFile, 'r')
    reader = csv.reader(f)
    csvset = {}
    csvlist = []
    for item in reader:
        csvset[item[0]] = item[1]
        csvlist.append(item[0])
    f.close()
    return csvset, csvlist


def unionset():
    # 读取txt获取插件账户
    txt = './dataset/nonactivated_bos_accounts.txt'
    tacclist = loadtxt(txt)

    # 读取csv集合
    csvFile = './dataset/airdrop_accounts.csv'
    caccset, cacclist = loadcsv(csvFile)

    # 创建数值集合
    tc = set(tacclist) & set(cacclist)

    resCsv = []
    sumBurn = 0
    # 构造交集结果
    for item in tc:
        resCsv.append([item, caccset[item]])
        sumBurn += float(caccset[item].replace('BOS', '').strip())

    print('len of unactive', len(resCsv))
    msig, sumBurnmsig = intersectmsigset()
    resCsv += msig

    # 写结果
    with open('./airdrop_unactive_account.csv', 'w') as cfile:
        writer = csv.writer(cfile)
        for item in resCsv:
            writer.writerow(item)

    cfile.close()

    print('len of unactive include msig', len(resCsv))
    print('sumBurn inclue msig', (sumBurn+sumBurnmsig))


def msigfromjson():
    # 由于文件中有多行，直接读取会出现错误，因此一行一行读取
    file = open("/Users/lisheng/Downloads/burn/bos-airdrop-snapshots-master/accounts_info_bos_snapshot.airdrop.msig.json", 'r', encoding='utf-8')
    papers = []
    for line in file.readlines():
        dic = json.loads(line)
        print(dic)
        papers.append(dic)


    print(len(papers))
    print(papers)
    # print(papers['bos_account'])
    # print(papers['bos_balance'])
    for key in papers:
        print(key['bos_account'], key['bos_balance'])

def readmsigfromlog():
    txt = './dataset/seq.log'
    f = open(txt, 'r')
    sourceInline = f.read()
    #'get_unused_accounts  ] ----- rncsqdohedjq -- auth_sequence: 0 -----'
    'get_unused_accounts  ] ----- (.*?) -- auth_sequence: (\d+) -----'
    pattern = re.compile(
        'get_unused_accounts  ] ----- (.*?) -- auth_sequence: (\d+) -----', re.S)
    # compile可以在多次使用中提高效率，这里影响不大
    results = re.findall(pattern, sourceInline)
    accseqmap = {}
    for result in results:
        acc, nums = result
        accseqmap[acc] = nums
        # print(acc,  nums)
    return accseqmap


def intersectmsigset():
    # 读取csv集合
    csvFile = './dataset/airdrop_msig.csv'
    msigmap, msiglist = loadcsv(csvFile)

    accseq = readmsigfromlog()

    # 创建数值集合
    # tc = set(tacclist) & set(cacclist)

    resCsv = []
    acacc = []
    sumBurn = 0
    # 构造交集结果
    for item in msiglist:
        if int(accseq[item]) == 2:
            resCsv.append([item, msigmap[item]])
            sumBurn += float(msigmap[item].replace('BOS', '').strip())
        else:
            acacc.append([item, msigmap[item], accseq[item]])

    # # 写结果
    # with open('./output/msig_unactive_acc.csv','w') as cfile:
    #     writer = csv.writer(cfile)
    #     for item in resCsv:
    #         writer.writerow(item)
    # cfile.close()

    # with open('./output/msig_active_acc.csv','w') as mcfile:
    #     writer = csv.writer(mcfile)
    #     for item in acacc:
    #         writer.writerow(item)
    # mcfile.close()

    print('len unactive', len(resCsv))
    print('len active', len(acacc))
    print('msumBurn', sumBurn)
    return resCsv, sumBurn


msigfromjson()
