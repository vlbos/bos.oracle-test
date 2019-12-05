const OracleProvider = require('./Provider');
const schedule = require("node-schedule");  
const axios = require("axios");

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
        
        const api1 = 'https://api.newdex.vip/v1/candles?symbol=eosio.token-eos-usdt&time_frame=1min&size=1';
        const api2 = 'https://api.newdex.vip/v1/candles?symbol=bitpietokens-eeth-eusd&time_frame=1min&size=1';
        const api3 = 'https://api.newdex.vip/v1/candles?symbol=bitpietokens-ebtc-eusd&time_frame=1min&size=1';
        const api4 = 'https://api.newdex.vip/v1/candles?symbol=eosio.token-bos-eos&time_frame=1min&size=1';

        const result1 = await axios.get(api1).catch(e => console.error(e));
        const result2 = await axios.get(api2).catch(e => console.error(e));
        const result3 = await axios.get(api3).catch(e => console.error(e));
        const result4 = await axios.get(api4).catch(e => console.error(e));
 
        // 组装数据
            const data = {
                "source":"Newdex",
                "eos": result1.data.data[0][2] || cache.eos,
                "ethereum": result2.data.data[0][2] || cache.ethereum,
                "bitcoin": result3.data.data[0][2] || cache.bitcoin,
                "boscore": Number(result4.data.data[0][2]) * Number(result1.data.data[0][2]) || cache.boscore,
                "timestamp": !result4.data || !result3.data || !result2.data || !result1.data ? cache.timestamp : new Date() 
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
        console.log(`Newdex\n⏱️ 数据请求耗时:${(end_time - start_time) / 1000} s \n🚀 数据推送耗时:${(end_end_time - end_time) / 1000} s  \n🚩 总耗时:${(end_end_time - start_time)/1000} s`);
        
        });

})();