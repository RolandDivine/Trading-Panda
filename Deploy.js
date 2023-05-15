const { ethers } = require("hardhat");

async function main() {
  const UniswapRouterAddress = "0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D"; // Replace with actual Uniswap Router address
  const DexToolsAddress = "0x8cbdbeF1d8912b46b10139D1e30fb2E3e443C773"; // Replace with actual DexTools address
  const BuyPercentage = 5; // 5% buy profit target
  const SellPercentage = 5; // 5% sell profit target
  const MinMarketCap = 50000; // $50,000 market cap limit

  const ERC20Bot = await ethers.getContractFactory("ERC20Bot");
  const bot = await ERC20Bot.deploy(UniswapRouterAddress, DexToolsAddress, BuyPercentage, SellPercentage, MinMarketCap);

  console.log("ERC20Bot deployed to:", bot.address);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
