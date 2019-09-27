const Eos = require('eosjs');
const dotenv = require('dotenv');
//const axios = require('axios');
const request = require('request');

const eosUrl = "https://api.coincap.io/v2/assets/eos";
//"https://min-api.cryptocompare.com/data/price?fsym=EOS&tsyms=BTC,USD";
const btcUrl = "https://min-api.cryptocompare.com/data/price?fsym=BTC&tsyms=USD,CAD";
const btccnyUrl = "https://blockchain.info/ticker";

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


function repeat(str, n) {
	return new Array(n + 1).join(str);
}

function current_time() {
	return Date.parse(new Date()) / 1000;
}

function to_timestamp(time) {
	return Date.parse(new Date(time)) / 1000;
}

const service_id = 1;
const request_id = 0;
const update_cycle = 120;
const update_cycle_ms = 120000;
const duration = 30;
const update_start_time = "2019-09-16 09:09:09";

function write(updat_number) {

	request.get(eosUrl, function (err, res, eosRes){
		// request.get(btcUrl, function (err, res, btcRes){
		// 	request.get(btccnyUrl, function (err, res, btccnyRes){

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
			var eosprice = JSON.parse(eosRes).data.priceUsd;
			console.log("EOSUSDeosprice:", eosprice);
			// console.log("EOSUSD:", JSON.parse(eosRes).USD);
			// 	console.log("EOSBTC:", JSON.parse(eosRes).BTC);
			// 	console.log("BTCUSD:", JSON.parse(btcRes).USD);
            //                     console.log("BTCUSD:", JSON.parse(btcRes).CAD);
			// 	console.log("BTCCNY:", JSON.parse(btccnyRes).CNY.last);


				/* var quotes = [{"value": parseInt(Math.round(JSON.parse(eosRes).BTC * 100000000)), pair:"eosbtc"}, 
											{"value": parseInt(Math.round(JSON.parse(eosRes).USD * 10000)), pair:"eosusd"}, 
											{"value": parseInt(Math.round(JSON.parse(btcRes).USD * 10000)), pair:"btcusd"}, 
											{"value": parseInt(Math.round(JSON.parse(btccnyRes).CNY.last * 10000)), pair:"btccny"}];

						*/

				// 	var quotes = [{"value": parseInt(Math.round(JSON.parse(eosRes).USD * 10000)), pair:"eosusd"}];
				// console.log("quotes:", quotes);

				eos.contract(oracleContract)
					.then((contract) => {
						for (i = 1; i <= 5; i++) {
							provider = "provider" + repeat(i, 4);
							contract.pushdata({
								service_id: service_id,
								provider: provider,
								update_number: update_number,
								request_id: request_id,
								data: "" +  eosprice
							},
								{
									scope: oracleContract,
									authorization: [`${provider}@${process.env.ORACLE_PERMISSION || 'active'}`]
								})
								.then(results => {
									console.log("results:", results);
									setTimeout(start_timer, update_cycle_ms);
								})
								.catch(error => {
									console.log("error:", error);
									setTimeout(start_timer, update_cycle_ms);
								});
						}

					})
					.catch(error => {
						console.log("error:", error);
						setTimeout(start_timer, update_cycle_ms);
					});
				});
		// 	});
		// });

}

function start_timer() {
	update_start_timestamp = to_timestamp(update_start_time)+8*3600;
	console.log(" update_start_timestamp", update_start_timestamp);
	now_sec = current_time();
	update_number = Math.round((now_sec - update_start_timestamp) / update_cycle + 1);
	begin_time = update_start_timestamp + (update_number - 1) * update_cycle;
	end_time = begin_time + duration;
	next_begin_time = update_start_timestamp + (update_number) * update_cycle;
	if (now_sec >= begin_time && now_sec < end_time) {
		write(update_number);
		console.log(" now_sec", now_sec);
	}
	else {
		console.log(" (next_begin_time-now_sec)*1000", (next_begin_time-now_sec)*1000);
		setInterval(start_timer, (next_begin_time-now_sec)*1000);
	}

}
start_timer();

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