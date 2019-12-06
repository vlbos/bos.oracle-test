const Eos = require('eosjs');
// const dotenv = require('dotenv');
// dotenv.config({ path: '/Users/chenpuxin/Code/BOSCORE/neworacletest/.env.local'})

module.exports = class OracleProvider {
    constructor(service_id, update_cycle, duration, update_start_timestamp) {
            this.service_id = service_id;
            this.update_cycle = update_cycle;
            this.duration = duration;
            this.update_start_timestamp = update_start_timestamp;
            this.eos = Eos({
                httpEndpoint: process.env.EOS_PROTOCOL + "://" + process.env.EOS_HOST + ":" + process.env.EOS_PORT,
                keyProvider: [process.env.EOS_KEY],
                chainId: process.env.EOS_CHAIN,
                verbose: false,
                logger: {
                    log: null,
                    error: null
                }
            });

        }

        current_time() {
            return Date.parse(new Date()) / 1000;
        }
    async pushdatax(cycle_number, data) {
            console.log("cycle_number=", cycle_number);
        const result = await this.eos.transaction({
            actions: [{
                account: process.env.CONTRACT,
                name: 'pushdata',
                authorization: [{
                    actor: process.env.PROVIDER,
                    permission: 'active',
                }],
                data: {
                    service_id: this.service_id,
                    provider: process.env.PROVIDER,
                    cycle_number,
                    request_id: 0,
                    data: "" + JSON.stringify(data)
                },
            },
            ],
        }).catch(err => {
            console.log("pushdata Error: " + err + "");
        })
        console.log("results:", result.transaction_id);
        }

    async start(data) {
            let now_sec = this.current_time();
            let cycle_number = Math.floor((now_sec - this.update_start_timestamp) / this.update_cycle) + 1;
            let begin_time = this.update_start_timestamp + (cycle_number - 1) * this.update_cycle;
            let end_time = begin_time + this.duration;
            let next_begin_time = this.update_start_timestamp + (cycle_number) * this.update_cycle;
            
            if (now_sec >= begin_time && now_sec < end_time) {
                await this.pushdatax(cycle_number, data);
                console.log(" now_sec", now_sec);
            }
            else {
                console.log(" (next_begin_time-now_sec)*1000", (next_begin_time - now_sec) * 1000);
            }
        }
    }

