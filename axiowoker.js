const axios = require('axios');
const { parentPort, workerData } = require('worker_threads');
const { api } = workerData;

(async()=>{
    const result = await axios.get(api);
    parentPort.postMessage(result);
})()