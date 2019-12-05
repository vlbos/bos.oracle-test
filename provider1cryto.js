const OracleProvider = require('./Provider');
const schedule = require("node-schedule");  
const CoinGecko = require('coingecko-api');

(async()=>{
    const service_id = Number(process.env.SERVICE_ID) || 0;
    const update_cycle = Number(process.env.UPDATE_CYCLE) || 0;
    const duration = Number(process.env.DURATION) ||0;
    const update_start_time = Number(process.env.UPDATE_START_TIME) || 0;
    const timer_sticker = process.env.TIMER_TICKER || '* * * * * *';
    let cache = {}

    schedule.scheduleJob(timer_sticker, async ()=>{
        let provider = new OracleProvider(service_id, update_cycle, duration, update_start_time);
        let start_time = new Date();
        let CoinGeckoClient = new CoinGecko();

        const sourceData = await CoinGeckoClient.simple.price({
            vs_currencies: 'usd',
            ids: ['bitcoin', 'ethereum', 'eos', 'boscore'],
        }
        ).catch(err => console.error(err));
        
 
        // 组装数据
            const data = {
                "source":"CoinGecko",
                "eos": sourceData.data.eos.usd || cache.eos,
                "ethereum": sourceData.data.ethereum.usd || cache.ethereum,
                "bitcoin": sourceData.data.bitcoin.usd || cache.bitcoin,
                "boscore": sourceData.data.boscore.usd || cache.boscore,
                "timestamp": sourceData.data ? new Date() : cache.timestamp
            }
            console.log(data);
            
            // 缓存处理
            if(!sourceData.data) {
                console.log('CoinGecko Api 出问题了')
            }else{
                cache = data;
            }

            let end_time = new Date();
        // 推送数据
            await provider.start(data);
            let end_end_time = new Date();
        console.log(`CoinGecko\n⏱️ 数据请求耗时:${(end_time - start_time) / 1000} s \n🚀 数据推送耗时:${(end_end_time - end_time) / 1000} s  \n🚩 总耗时:${(end_end_time - start_time)/1000} s`);
        
        });

})();