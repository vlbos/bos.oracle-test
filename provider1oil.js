const OracleProvider = require('./Provider');
const axios = require('axios');
const schedule = require("node-schedule");  

(async()=>{
    const service_id = Number(process.env.SERVICE_ID) || 0;
    const update_cycle = Number(process.env.UPDATE_CYCLE) || 0;
    const duration = Number(process.env.DURATION) ||0;
    const update_start_time = Number(process.env.UPDATE_START_TIME) || 0;
    const timer_sticker = process.env.TIMER_TICKER || '* * * * * *';
    
    schedule.scheduleJob(timer_sticker, async ()=>{
        let provider = new OracleProvider(service_id, update_cycle, duration, update_start_time);
        let start_time = new Date();
    
        const api1 = "https://www.quandl.com/api/v3/datasets/CHRIS/CME_RB1/data.json?rows=1&api_key=BZsFDXt-xXb3WFNgLQ97";
        const api2 = "https://www.quandl.com/api/v3/datasets/LBMA/GOLD/data.json?rows=1&api_key=BZsFDXt-xXb3WFNgLQ97";
        const api3 = "https://api.exchangeratesapi.io/latest?symbols=USD,CNY";
        // 获取数据
            const result1 = await axios.get(api1).catch(e => console.error(e));
            const result2 = await axios.get(api2).catch(e => console.error(e));
            const result3 = await axios.get(api3).catch(e => console.error(e));
            const cny = result3.data.rates.CNY;
            const usd = result3.data.rates.USD;
        // 组装数据
            const data = {
                "source":"www.quandl.com",
                "oil": result1.data.dataset_data.data[0][4],
                "gold": result2.data.dataset_data.data[0][2],
                "rmb": Number(usd) / Number(cny)
            }
            console.log(data);
    
            let end_time = new Date();
        // 推送数据
            await provider.start(data);
            let end_end_time = new Date();
        console.log(`QUANDL\n⏱️ 数据请求耗时:${(end_time - start_time) / 1000} s \n🚀 数据推送耗时:${(end_end_time - end_time) / 1000} s  \n🚩 总耗时:${(end_end_time - start_time)/1000} s`);
        
        });

})();