const Eos = require('eosjs');
const dotenv = require('dotenv');
const axios = require('axios');

const url = "https://min-api.cryptocompare.com/data/price?fsym=EOS&tsyms=USD";

dotenv.load();

const interval = process.env.FREQ;
const owner = process.env.ORACLE;
const oracleContract = process.env.CONTRACT;

const oraclize = "oraclebosbos";
const oraclized = "bosoraclebos";
const oracle = "oracleoracle";

const eos = Eos({ 
  httpEndpoint: process.env.EOS_PROTOCOL + "://" +  process.env.EOS_HOST + ":" + process.env.EOS_PORT,
  keyProvider: process.env.EOS_KEY,
  chainId: process.env.EOS_CHAIN,
  verbose:false,
  logger: {
    log: null,
    error: null
  }
});


function push(){
	
	eos.contract(oraclize)
					.then((contract) => {
						const price = {
							value: 200000,
							decimals: 4
						};
						const priceBinary = contract.fc.toBuffer("price", price);
						contract.addoracle(oracle, {
							authorization: [`${oraclize}@${process.env.ORACLE_PERMISSION || 'active'}`] 
						});
						contract.push(oracle, oraclized, "0xae1cb3a8b6b4c49c65d22655c1ec4d28a4b3819065dd6aaf990d18e7ede951f1", "", priceBinary, {
							authorization: [`${oraclized}@${process.env.ORACLE_PERMISSION || 'active'}`] 
						}.then(results=>{
							console.log("results:", results);
							s
						})
						.catch(error=>{
							console.log("error:", error);
						
						});
						
					})
					.catch(error=>{
						console.log("error:", error);
						setTimeout(write, interval);
					});

}
push();

function write(){

	axios.get(`${url}`)
		.then(results=>{

			if (results.data && results.data.USD){

				console.log(" results.data.USD",  results.data.USD);

				eos.contract(oracleContract)
					.then((contract) => {
						contract.write({
								owner: owner,
								value: parseInt(Math.round(results.data.USD * 10000))
							},
							{
								scope: oracleContract,
								authorization: [`${owner}@${process.env.ORACLE_PERMISSION || 'active'}`] 
							})
							.then(results=>{
								console.log("results:", results);
								setTimeout(write, interval);
							})
							.catch(error=>{
								console.log("error:", error);
								setTimeout(write, interval);
							});

					})
					.catch(error=>{
						console.log("error:", error);
						setTimeout(write, interval);
					});

			}
			else setTimeout(write, interval);

		})
		.catch(error=>{
			console.log("error:", error);
			setTimeout(write, interval);
		});

}


// write();

//setInterval(write, 60000);
