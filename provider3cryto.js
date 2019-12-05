const OracleProvider = require('./Provider');
const schedule = require("node-schedule");  
const cheerio = require('cheerio');
const axios = require('axios');
(async()=>{
    const service_id = Number(process.env.SERVICE_ID) || 0;
    const update_cycle = Number(process.env.UPDATE_CYCLE) || 0;
    const duration = Number(process.env.DURATION) ||0;
    const update_start_time = Number(process.env.UPDATE_START_TIME) || 0;
    const timer_sticker = process.env.TIMER_TICKER || '* * * * * *';
    let cache = {};

    function getFeixiaohaoPrice(res){
        const $ = cheerio.load(res);
        return $('.price_usd span').text();
    }

    schedule.scheduleJob(timer_sticker, async ()=>{
        let provider = new OracleProvider(service_id, update_cycle, duration, update_start_time);
        let start_time = new Date();

        const api1 = 'https://m.feixiaohao.com/currencies/eos';
        const api2 = 'https://m.feixiaohao.com/currencies/ethereum';
        const api3 = 'https://m.feixiaohao.com/currencies/bitcoin';
        const api4 = 'https://m.feixiaohao.com/currencies/bos';
        
        const result1 = await axios.get(api1).catch(e => console.error(e));
        const result2 = await axios.get(api2).catch(e => console.error(e));
        const result3 = await axios.get(api3).catch(e => console.error(e));
        const result4 = await axios.get(api4).catch(e => console.error(e));

       

        // 组装数据
            const data = {
                "source":"FeiXiaoHao",
                "eos": getFeixiaohaoPrice(result1.data) || cache.eos,
                "ethereum": getFeixiaohaoPrice(result2.data) || cache.ethereum,
                "bitcoin": getFeixiaohaoPrice(result3.data) || cache.bitcoin,
                "boscore": getFeixiaohaoPrice(result4.data) || cache.boscore,
                "timestamp": !result4.data || !result3.data || !result2.data || !result1.data ? cache.boscore : new Date() 
            }
            console.log(data);

        // 缓存处理
        if (!result4.data || !result3.data || !result2.data || !result1.data) {
            console.log('CoinGecko Api 出问题了')
        } else {
            cache = data;
        }
    
            let end_time = new Date();
        // 推送数据
            await provider.start(data);
            let end_end_time = new Date();
        console.log(`FeiXiaoHao\n⏱️ 数据请求耗时:${(end_time - start_time) / 1000} s \n🚀 数据推送耗时:${(end_end_time - end_time) / 1000} s  \n🚩 总耗时:${(end_end_time - start_time)/1000} s`);
        
        });

})();