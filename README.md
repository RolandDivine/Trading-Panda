# Trading-Panda
# # ERC20Bot

Automated ERC20 trading bot that buys and sells tokens on Uniswap with a profit target.

## Description

ERC20Bot is a Solidity smart contract that enables automated trading of ERC20 tokens on the Uniswap decentralized exchange. The bot aims to achieve a profit target of 5% for each token purchase. It fetches token data from DexTools to make informed trading decisions. The contract is designed to independently trade 100 different ERC20 tokens with ETH. It can use ETH from the owner's wallet for trades and also send ETH profits to designated wallets.

The smart contract incorporates essential features such as reentrancy guard and pause functions to ensure security and prevent unauthorized access or malicious actions.

## Requirements

- Solidity compiler ^0.8.0
- OpenZeppelin Contracts ^4.4.0
- Uniswap V2 Periphery ^1.1.0
- Hardhat ^2.9.0
- Hardhat Deploy ^0.14.1
- Hardhat Deploy Ethers ^0.14.1
- Hardhat Ethers ^2.0.2
- Mocha ^9.2.0
- Web3 ^1.6.0

## Installation

1. Clone the repository:

   ```
   git clone https://github.com/your-username/erc20-bot.git
   ```

2. Navigate to the project directory:

   ```
   cd erc20-bot
   ```

3. Install dependencies:

   ```
   npm install
   ```

## Configuration

Before deploying the ERC20Bot contract, ensure the following configurations are correctly set:

- `UniswapRouterAddress`: The address of the Uniswap Router contract.
- `DexToolsAddress`: The address of the DexTools contract.
- `BuyPercentage`: The desired profit percentage for token purchases.
- `SellPercentage`: The desired profit percentage for token sales.
- `MinMarketCap`: The maximum market cap limit for tokens that can be bought by the contract.

## Deployment

To deploy the ERC20Bot contract, run the following command:

```
npx hardhat run --network rinkeby scripts/deploy.js
```

Make sure to configure your desired network in the `hardhat.config.js` file.

## Usage

Once the ERC20Bot contract is deployed, you can interact with it using the provided functions:

- `buyToken(address _tokenAddress)`: Initiates the purchase of the specified ERC20 token. The contract will calculate the amount of ETH required based on the profit target and execute the trade on Uniswap.
- `sellToken(address _tokenAddress)`: Initiates the sale of the specified ERC20 token. The contract will calculate the token amount to be sold based on the profit target and execute the trade on Uniswap.

## Testing

To run the tests for the ERC20Bot contract, use the following command:

```
npx hardhat test
```

The test suite includes various scenarios to verify the functionality and security of the ERC20Bot contract.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for more details.

**DISCLAIMER**: This project is for educational and demonstration purposes only. Use at your own risk. Always do thorough research and exercise caution when dealing with smart contracts and financial transactions.
