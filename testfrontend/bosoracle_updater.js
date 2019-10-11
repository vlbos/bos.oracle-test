const Eos = require('eosjs');
const dotenv = require('dotenv');
//const axios = require('axios');
const request = require('request');
//Helpers
const CoinGecko = require('./lib/CoinGecko');
// var sleep = require('sleep');

const eosUrl = "https://api.coincap.io/v2/assets/eos";
const bitcoinUrl = "https://api.coincap.io/v2/assets/bitcoin";
const ethereumUrl = "https://api.coincap.io/v2/assets/ethereum";
//"https://min-api.cryptocompare.com/data/price?fsym=EOS&tsyms=BTC,USD";
const btcUrl = "https://min-api.cryptocompare.com/data/price?fsym=BTC&tsyms=USD,CAD";
const btccnyUrl = "https://blockchain.info/ticker";

const oilUrl = "https://www.quandl.com/api/v3/datasets/CHRIS/CME_RB1/data.json?rows=1&api_key=BZsFDXt-xXb3WFNgLQ97";
const goldUrl = "https://www.quandl.com/api/v3/datasets/LBMA/GOLD/data.json?rows=1&api_key=BZsFDXt-xXb3WFNgLQ97";
const rmbUrl = "https://www.mycurrency.net/CN.json";

dotenv.load();

const interval = process.env.FREQ;
const owner = process.env.ORACLE;
const oracleContract = process.env.CONTRACT;

const oraclize = "oraclebosbos";
const consumer = "consumer1234";
const oracle = "oracleoracle";

const eos = Eos({
	httpEndpoint: process.env.EOS_PROTOCOL + "://" + process.env.EOS_HOST + ":" + process.env.EOS_PORT,
	keyProvider: [process.env.EOS_KEY, '5JhNVeWb8DnMwczC54PSeGBYeQgjvW4SJhVWXMXW7o4f3xh7sYk', '5JBqSZmzhvf3wopwyAwXH5g2DuNw9xdwgnTtuWLpkWP7YLtDdhp', '5JCtWxuqPzcPUfFukj58q8TqyRJ7asGnhSYvvxi16yq3c5p6JRG', '5K79wAY8rgPwWQSRmyQa2BR8vPicieJdLCXL3cM5Db77QnsJess', "5K2L2my3qUKqj67KU61cSACoxgREkqGFi5nKaLGjbAbbRBYRq1m", "5JN8chYis1d8EYsCdDEKXyjLT3QmpW7HYoVB13dFKenK2uwyR65", "5Kju7hDTh3uCZqpzb5VWAdCp7cA1fAiEd94zdNhU59WNaQMQQmE", "5K6ZCUpk2jn1munFdiADgKgfAqcpGMHKCoJUue65p99xKX9WWCW", "5KAyefwicvJyxDaQ1riCztiSgVKiH37VV9JdSRcrqi88qQkV2gJ"],
	chainId: process.env.EOS_CHAIN,
	verbose: false,
	logger: {
		log: null,
		error: null
	}
});


const require_permissions = ({ account, key, actor, parent }) => {
	return {
		account: `${account}`,
		permission: "active",
		parent: `${parent}`,
		auth: {
			threshold: 1,
			keys: [
				{
					key: `${key}`,
					weight: 1
				}
			],
			accounts: [
				{
					permission: {
						actor: `${actor}`,
						permission: "eosio.code"
					},
					weight: 1
				}
			],
			waits: []
		}
	};
};

const allowContract = (auth, key, contract, parent) => {
	let [account, permission] = auth.split("@");
	permission = permission || "active";
	parent = parent || "owner";

	const tx_data = {
		actions: [
			{
				account: "eosio",
				name: "updateauth",
				authorization: [
					{
						actor: account,
						permission: permission
					}
				],
				data: require_permissions({
					account: account,
					key: key,
					actor: contract,
					parent: parent
				})
			}
		]
	};

	return tx_data;
};

// const pub = "EOS89PeKPVQG3f48KCX2NEg6HDW7YcoSracQMRpy46da74yi3fTLP";
// eos.transaction(allowContract(consumer, pub, consumer));
//   await oraclizeContract.setup(oraclizeAccount, oracle, masterAccount, {
// 	authorization: [oraclizeAccount]
//   });

// function sleep(ms) {
// 	return new Promise(resolve => setTimeout(resolve, ms))
//   }

// function* sleep(ms) {
// 	yield new Promise(function (resolve, reject) {
// 		console.log(new Date());
// 		setTimeout(resolve, ms);
// 	})
// }


// function Person(name){
// 	this.name=name;
// 	var f=function(){alert('My name is '+this.name)};



// 	// setTimeout(f,50); //错误

// 	var THIS=this;
// 	setTimeout(function(){f.apply(THIS)},50); //正确，通用
// 	setTimeout(function(){f.call(THIS)},50); //正确，通用
// }
// new Person('Jack');



function sleep(ms){
	return new Promise((resolve)=>setTimeout(resolve,ms));
  }
  async function test(){
	var temple=await sleep(1000);
	console.log(new Date());
	return temple
  }


function find_from_array(arr) {
	var newArr = arr.filter(function (p) {
		return p.name === "United States";
	});

	return newArr;
}

function repeat(str, n) {
	return new Array(n + 1).join(str);
}

function current_time() {
	return Date.parse(new Date()) / 1000;
}

function to_timestamp(time) {
	return Date.parse(new Date(time)) / 1000;
}

const request_id = 0;

// const service_id = 1;
// const update_cycle = 120;
// const duration = 30;
// const update_start_time = "2019-09-16 09:09:09";
var myself;
class OracleTimer {
	constructor(service_id, update_cycle, duration, update_start_time) {
		this.service_id = service_id;
		this.update_cycle = update_cycle;
		this.duration = duration;
		this.update_start_time = update_start_time;
	}

	pushdatax(update_number, data, begin, end) {
		console.log("update_number=", update_number);
		eos.contract(oracleContract)
			.then((contract) => {
			test();
				for (var i = begin; i <= end; i++) {
					var provider = "provider" + repeat(i, 4);
					contract.pushdata({
						service_id: this.service_id,
						provider: provider,
						update_number: update_number,
						request_id: request_id,
						data: "" + JSON.stringify(data)
					},
						{
							scope: oracleContract,
							authorization: [`${provider}@${process.env.ORACLE_PERMISSION || 'active'}`]
						})
						.then(results => {
							console.log("results:", results);
						})
						.catch(error => {
							console.log("error:", error);
						});
					console.log(new Date());
					test();
					console.log(new Date());
				}

			})
			.catch(error => {
				console.log("error:", error);
			});
	}

	write(update_number) {
		// const pricesWs = new WebSocket('wss://ws.coincap.io/prices?assets=bitcoin,ethereum,monero,litecoin')

		// pricesWs.onmessage = function (msg) {
		// 	console.log(msg.data)
		// }

		myself = this;
		request.get(eosUrl, function (err, res, eosRes) {
			request.get(ethereumUrl, function (err, res, ethereumRes) {
				request.get(bitcoinUrl, function (err, res, bitcoinRes) {

					// {
					// 	"data": {
					// 		"id": "eos",
					// 		"rank": "7",
					// 		"symbol": "EOS",
					// 		"name": "EOS",
					// 		"supply": "931377543.1387000000000000",
					// 		"maxSupply": null,
					// 		"marketCapUsd": "3459800395.6626011241621507",
					// 		"volumeUsd24Hr": "694193196.4939930771219022",
					// 		"priceUsd": "3.7147131377070044",
					// 		"changePercent24Hr": "-1.1373653211375365",
					// 		"vwap24Hr": "3.7271304162291967"
					// 	},
					// 	"timestamp": 1568274617161
					// }

					console.log("EOSUSD:", JSON.parse(eosRes).data.priceUsd);
					console.log("ETHUSD:", JSON.parse(ethereumRes).data.priceUsd);
					console.log("BTCUSD:", JSON.parse(bitcoinRes).data.priceUsd);
					var eosprice = JSON.parse(eosRes).data.priceUsd;
					var newdata = {
						"eos": JSON.parse(eosRes).data.priceUsd,
						"ethereum": JSON.parse(ethereumRes).data.priceUsd,
						"bitcoin": JSON.parse(bitcoinRes).data.priceUsd,
						"boscore": 0
					}
					console.log("EOSUSDeosprice:", newdata);

					myself.pushdatax(update_number, newdata, 1, 2);

				});
			});
		});

	}



	writeusd(update_number) {
		myself = this;
		request.get(oilUrl, function (err, res, oilRes) {
			request.get(goldUrl, function (err, res, goldRes) {
				request.get(rmbUrl, function (err, res, rmbRes) {
					// {
					// 	"dataset_data": {
					// 		"limit": 1,
					// 		"transform": null,
					// 		"column_index": null,
					// 		"column_names": ["Date", "Open", "High", "Low", "Last", "Change", "Settle", "Volume", "Previous Day Open Interest"],
					// 		"start_date": "2005-10-03",
					// 		"end_date": "2019-10-09",
					// 		"frequency": "daily",
					// 		"data": [
					// 			["2019-10-09", 1.5793, 1.6126, 1.575, 1.5833, 0.0062, 1.5871, 60980.0, 106203.0]
					// 		],
					// 		"collapse": null,
					// 		"order": null
					// 	}
					// }

					// {
					// 	"dataset": {
					// 	  "id": 11304240,
					// 	  "dataset_code": "GOLD",
					// 	  "database_code": "LBMA",
					// 	  "name": "Gold Price: London Fixing",
					// 	  "description": "Gold Price: .",
					// 	  "refreshed_at": "2019-10-09 23:25:19 UTC",
					// 	  "newest_available_date": "2019-10-09",
					// 	  "oldest_available_date": "1968-01-02",
					// 	  "column_names": [
					// 		"Date",
					// 		"USD (AM)",
					// 		"USD (PM)",
					// 		"GBP (AM)",
					// 		"GBP (PM)",
					// 		"EURO (AM)",
					// 		"EURO (PM)"
					// 	  ],
					// 	  "frequency": "daily",
					// 	  "type": "Time Series",
					// 	  "premium": false,
					// 	  "limit": 1,
					// 	  "transform": null,
					// 	  "column_index": null,
					// 	  "start_date": "1968-01-02",
					// 	  "end_date": "2019-10-09",
					// 	  "data": [
					// 		[
					// 		  "2019-10-09",
					// 		  1503.4,
					// 		  1507.25,
					// 		  1228.43,
					// 		  1232.93,
					// 		  1369.0,
					// 		  1372.65
					// 		]
					// 	  ],
					// 	  "collapse": null,
					// 	  "order": null,
					// 	  "database_id": 139
					// 	}
					//   }
					console.log(oilRes);
					console.log(JSON.parse(oilRes).dataset_data.data[0][4]);
					console.log("OILUSD:", JSON.parse(oilRes).dataset_data.data[0][4]);
					console.log("GOLDUSD:", goldRes);
					console.log("GOLDUSD:", JSON.parse(goldRes).dataset_data);
					console.log("GOLDUSD:", JSON.parse(goldRes).dataset_data.data[0][2]);
					
					// console.log("RMBUSD:", rmbRes);
					// console.log("RMBUSD:", JSON.parse(rmbRes).rates);
					var arr = find_from_array(JSON.parse(rmbRes).rates);
					console.log("RMBUSD:", arr);
					console.log("RMBUSD:", arr[0].rate);
					var newdata = {
						"oil": JSON.parse(oilRes).dataset_data.data[0][4],
						"gold": JSON.parse(goldRes).dataset_data.data[0][2],
						"rmb": arr[0].rate,
					}
					console.log("EOSUSDeosprice:", newdata);

					myself.pushdatax(update_number, newdata, 1, 5);

				});
			});
		});

	}


	start_timer() {
		var update_start_timestamp = this.update_start_time;//1570758862;
		//to_timestamp(update_start_time) + 8 * 3600;
		console.log(" update_start_timestamp", update_start_timestamp);
		var now_sec = current_time();
		var update_number = Math.round((now_sec - update_start_timestamp) / this.update_cycle + 1);
		var begin_time = update_start_timestamp + (update_number - 1) * this.update_cycle;
		var end_time = begin_time + this.duration;
		var next_begin_time = update_start_timestamp + (update_number) * this.update_cycle;
		if (now_sec >= begin_time && now_sec < end_time) {
			// if (1 == this.service_id) {
			// 	this.write(update_number);
			// 	this.test_bos(update_number);
			// }
			// else
			 {
				this.writeusd(update_number);
			}

			console.log(" now_sec", now_sec);
		}
		else {
			console.log(" (next_begin_time-now_sec)*1000", (next_begin_time - now_sec) * 1000);
		}

		setInterval(start_usd_timer, (next_begin_time - now_sec) * 1000);


	}

	test_bos(update_number) {
		var CoinGeckoClient = new CoinGecko();

		CoinGeckoClient.simple.price({
			vs_currencies: 'usd',
			ids: ['bitcoin', 'ethereum', 'eos', 'boscore'],
		}).then((data) => {
			this.data = data;
			console.log(data);
			// {
			// 	success: true,
			// 	message: 'OK',
			// 	code: 200,
			// 	data: {
			// 	  eos: { usd: 3.18 },
			// 	  ethereum: { usd: 192.94 },
			// 	  bitcoin: { usd: 8555.88 },
			// 	  boscore: { usd: 0.03517988 }
			// 	}
			console.log("eos", data.data.eos.usd);
			console.log("eos", data.data.eos.usd);
			console.log("ethereum", data.data.ethereum.usd);
			console.log("bitcoin", data.data.bitcoin.usd);
			console.log("boscore", data.data.boscore.usd);

			var newdata = {
				"eos": data.data.eos.usd,
				"ethereum": data.data.ethereum.usd,
				"bitcoin": data.data.bitcoin.usd,
				"boscore": data.data.boscore.usd
			}
			this.pushdatax(update_number, newdata, 3, 5);
			console.log(newdata);
		});
	}
}

// start_timer();
function start_coin_timer() {
	const service_id = 1;
	const update_cycle = 120;
	const duration = 30;
	const update_start_time = 1570770587;
	var timer = new OracleTimer(service_id, update_cycle, duration, update_start_time);
	timer.start_timer();
}

// start_coin_timer();
function start_usd_timer() {
	const service_id = 1;
	const update_cycle = 120;
	const duration = 30;
	const update_start_time = 1570770587;
	var timer = new OracleTimer(service_id, update_cycle, duration, update_start_time);
	timer.start_timer();
	// timer.writeusd(1);

}
start_usd_timer();
// write();
//setInterval(write, 60000);


function test_time() {
	const update_start_time = "2019-09-12 09:09:09";
	update_start_timestamp = to_timestamp(update_start_time);
	console.log(" update_start_timestamp", update_start_timestamp);
	now_sec = current_time();
	console.log(" now_sec", now_sec);

}

// test_time();


// test_bos();


// {
// 	"baseCountry": "US",
// 	"baseCurrency": "USD",
// 	"rates": [{
// 		"id": 301,
// 		"name": "Hong Kong",
// 		"name_zh": "中国香港",
// 		"code": "HK",
// 		"currency_name": "HKD",
// 		"currency_name_zh": "港币",
// 		"currency_code": "HKD",
// 		"rate": 7.84331,
// 		"hits": 30179,
// 		"selected": 0,
// 		"top": 0
// 	}, {
// 		"id": 449,
// 		"name": "Singapore",
// 		"name_zh": "新加坡",
// 		"code": "SG",
// 		"currency_name": "Dollar",
// 		"currency_name_zh": "新币",
// 		"currency_code": "SGD",
// 		"rate": 1.3785,
// 		"hits": 1148456,
// 		"selected": 0,
// 		"top": 0
// 	}, {
// 		"id": 356,
// 		"name": "China",
// 		"name_zh": "中国",
// 		"code": "CN",
// 		"currency_name": "Yuan Renminbi",
// 		"currency_name_zh": "人民币",
// 		"currency_code": "CNY",
// 		"rate": 7.1098,
// 		"hits": 238147,
// 		"selected": 1,
// 		"top": 5
// 	}]
// }

// {
// 	"baseCountry": "CN",
// 	"baseCurrency": "CNY",
// 	"rates": [{
// 		"id": 356,
// 		"name": "China",
// 		"name_zh": "中国",
// 		"code": "CN",
// 		"currency_name": "Yuan Renminbi",
// 		"currency_name_zh": "人民币",
// 		"currency_code": "CNY",
// 		"rate": 1,
// 		"hits": 238170,
// 		"selected": 1,
// 		"top": 5
// 	}, {
// 		"id": 449,
// 		"name": "Singapore",
// 		"name_zh": "新加坡",
// 		"code": "SG",
// 		"currency_name": "Dollar",
// 		"currency_name_zh": "新币",
// 		"currency_code": "SGD",
// 		"rate": 0.19345675027017922,
// 		"hits": 1148567,
// 		"selected": 0,
// 		"top": 0
// 	}, {
// 		"id": 297,
// 		"name": "United States",
// 		"name_zh": "美国",
// 		"code": "US",
// 		"currency_name": "USD",
// 		"currency_name_zh": "美元",
// 		"currency_code": "USD",
// 		"rate": 0.14035284705750256,
// 		"hits": 258867,
// 		"selected": 1,
// 		"top": 10
// 	}]
// }