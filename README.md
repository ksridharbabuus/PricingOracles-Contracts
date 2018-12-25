# PricingOracles-Contracts
Pricing Oracles Contracts

High level requirements for Pricing Contracts:

1. Contract to record the AGI Token Prices in BTC, ETH, USD

2. Post Beta allow fiat to be converted to AGI as well

3. Using any existing source like Coin Market Cap, Binance, Crypto Compare  to get the AGI prices in various crypto currencies like BTC, ETH

4. Sample API to get the prices used in the contract development are:
https://min-api.cryptocompare.com/data/price?fsym=AGI&tsyms=BTC,ETH,USD

5. Contract leverages Oraclize contract to get the Prices from outside of Blockchain

6. Need to load the contract with the sufficient fund to execute the Oraclize Queries



Note: 
Current version of Truffle doesnt support Solidity 0.5.0 and above.
Deployed the contract directlty from Remix IDE