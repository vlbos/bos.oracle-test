const Eos = require('eosjs');
const dotenv = require('dotenv');
//const axios = require('axios');
const request = require('request');
//Helpers
const CoinGecko = require('./lib/CoinGecko');

const eosUrl = "https://api.coincap.io/v2/assets/eos";
const bitcoinUrl = "https://api.coincap.io/v2/assets/bitcoin";
const ethereumUrl = "https://api.coincap.io/v2/assets/ethereum";
//"https://min-api.cryptocompare.com/data/price?fsym=EOS&tsyms=BTC,USD";
const btcUrl = "https://min-api.cryptocompare.com/data/price?fsym=BTC&tsyms=USD,CAD";
const btccnyUrl = "https://blockchain.info/ticker";

const oilUrl = "https://www.quandl.com/api/v3/datasets/CHRIS/CME_RB1/data.json?rows=1&api_key=BZsFDXt-xXb3WFNgLQ97";
const goldUrl = "https://www.quandl.com/api/v3/datasets/LBMA/GOLD?rows=1&api_key=BZsFDXt-xXb3WFNgLQ97";
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

// const service_id = 1;
// const request_id = 0;
// const update_cycle = 120;
// const duration = 30;
// const update_start_time = "2019-09-16 09:09:09";

class OracleTimer {
	constructor(service_id, update_cycle, duration, update_start_time) {
		this.service_id = 1;
		this.update_cycle = 120;
		this.duration = 30;
		this.update_start_time = "2019-09-16 09:09:09";
	}



	push_data(update_number, data, begin, end) {
		eos.contract(oracleContract)
			.then((contract) => {
				for (i = begin; i <= end; i++) {
					provider = "provider" + repeat(i, 4);
					contract.pushdata({
						service_id: service_id,
						provider: provider,
						update_number: update_number,
						request_id: request_id,
						data: "" + newdata
					},
						{
							scope: oracleContract,
							authorization: [`${provider}@${process.env.ORACLE_PERMISSION || 'active'}`]
						})
						.then(results => {
							console.log("results:", results);
							setTimeout(start_timer, update_cycle * 1000);
						})
						.catch(error => {
							console.log("error:", error);
							setTimeout(start_timer, update_cycle * 1000);
						});
				}

			})
			.catch(error => {
				console.log("error:", error);
				setTimeout(start_timer, update_cycle * 1000);
			});
	}

	write(updat_number) {

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

					push_data(update_number, newdata, 1, 2);

				});
			});
		});

	}



	writeusd(updat_number) {

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

					console.log("OILUSD:", JSON.parse(oilRes).dataset_data.data[4]);
					console.log("GOLDUSD:", JSON.parse(goldRes).dataset.data[2]);
					var arr = find_from_array(JSON.parse(rmbRes).rates);
					console.log("RMBUSD:", arr.rate);
					var newdata = {
						"oil": JSON.parse(oilRes).dataset_data.data[4],
						"gold": JSON.parse(goldRes).dataset.data[2],
						"rmb": arr.rate,
					}
					console.log("EOSUSDeosprice:", newdata);

					push_data(update_number, newdata, 1, 5);

				});
			});
		});

	}


	start_timer() {
		update_start_timestamp = to_timestamp(update_start_time) + 8 * 3600;
		console.log(" update_start_timestamp", update_start_timestamp);
		now_sec = current_time();
		update_number = Math.round((now_sec - update_start_timestamp) / update_cycle + 1);
		begin_time = update_start_timestamp + (update_number - 1) * update_cycle;
		end_time = begin_time + duration;
		next_begin_time = update_start_timestamp + (update_number) * update_cycle;
		if (now_sec >= begin_time && now_sec < end_time) {
			if (1 == this.service_id) {
				write(update_number);
				test_bos(update_number);
			}
			else {
				writeusd(update_number);
			}

			console.log(" now_sec", now_sec);
		}
		else {
			console.log(" (next_begin_time-now_sec)*1000", (next_begin_time - now_sec) * 1000);
			setInterval(start_timer, (next_begin_time - now_sec) * 1000);
		}

	}

	test_bos(update_number) {
		CoinGeckoClient = new CoinGecko();

		CoinGeckoClient.simple.price({
			vs_currencies: 'usd',
			ids: ['bitcoin', 'ethereum', 'eos', 'boscore'],
		}).then((data) => {
			this.data = data;
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
			var newdata = {
				"eos": JSON.parse(data).data.eos.usd,
				"ethereum": JSON.parse(data).data.ethereum.usd,
				"bitcoin": JSON.parse(data).data.bitcoin.usd,
				"boscore": JSON.parse(data).data.boscore.usd
			}
			push_data(update_number, newdata, 3, 5);
			console.log(data);
		});
	}
}

// start_timer();

function start_coin_timer() {
	const service_id = 1;
	const request_id = 0;
	const update_cycle = 120;
	const duration = 30;
	const update_start_time = "2019-09-16 09:09:09";
	var timer = OracleTimer(service_id, update_cycle, duration, update_start_time);
	timer.start_timer();
}

start_coin_timer();
function start_usd_timer() {
	const service_id = 2;
	const request_id = 0;
	const update_cycle = 120;
	const duration = 30;
	const update_start_time = "2019-09-16 09:09:09";
	var timer = OracleTimer(service_id, update_cycle, duration, update_start_time);
	timer.start_timer();

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