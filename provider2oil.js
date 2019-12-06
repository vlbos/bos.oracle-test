const OracleProvider = require('./Provider');
const axios = require('axios');
const schedule = require("node-schedule");  
const cheerio = require('cheerio');
const iconv = require('iconv-lite');

function getGoldPrice(res) {
    const $ = cheerio.load(iconv.decode(res, "gb2312"));
    return $('.jia > span').text();
}
function getOilPrice(res) {
    const $ = cheerio.load(iconv.decode(res, "gb2312"));
    return $('.jia > span').text();
}

function getUsdPrice(res) {
    const $ = cheerio.load(res);
    return 100/Number($('body > section > div > div > article > table > tbody > tr:nth-child(2) > td:nth-child(2)').text());
} 

(async()=>{
    const service_id = Number(process.env.SERVICE_ID) || 0;
    const update_cycle = Number(process.env.UPDATE_CYCLE) || 0;
    const duration = Number(process.env.DURATION) ||0;
    const update_start_time = Number(process.env.UPDATE_START_TIME) || 0;
    const timer_sticker = process.env.TIMER_TICKER || '* * * * * *';
    let cache = {};

    schedule.scheduleJob(timer_sticker, async ()=>{
        let provider = new OracleProvider(service_id, update_cycle, duration, update_start_time);
        let start_time = new Date();
    
        const api1 = "https://info.usd-cny.com/wti/";
        const api2 = "https://gold.usd-cny.com/niuyuehuangjin.htm";
        const api3 = "https://www.usd-cny.com/";
        // 获取数据
        const result1 = await axios.get(api1, { responseType: "arraybuffer" }).catch(e => console.error(e));
        const result2 = await axios.get(api2, { responseType: "arraybuffer" }).catch(e => console.error(e));
            const result3 = await axios.get(api3).catch(e => console.error(e));

        // 组装数据
            const data = {
                "source":"usd-cny.com",
                "oil": getOilPrice(result1.data) || cache.oil,
                "gold": getGoldPrice(result2.data) || cache.gold,
                "rmb": getUsdPrice(result3.data) || cache.rmb,
                "timestamp": result1.data ? new Date() : cache.timestamp
            }
            console.log(data);
        // 缓存处理
        if (!result1.data || !result3.data) {
            console.log('usd-cny Api 出问题了')
        } else {
            cache = data;
        }
            let end_time = new Date();
        // 推送数据
            // await provider.start(data);
            let end_end_time = new Date();
        console.log(`usd-cny\n⏱️ 数据请求耗时:${(end_time - start_time) / 1000} s \n🚀 数据推送耗时:${(end_end_time - end_time) / 1000} s  \n🚩 总耗时:${(end_end_time - start_time)/1000} s`);
        
        });

})();