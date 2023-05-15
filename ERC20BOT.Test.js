const ERC20Bot = artifacts.require("ERC20Bot");

contract("ERC20Bot", (accounts) => {
  const owner = accounts[0];
  const uniswapRouter = "0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D";
  const dexTools = "0x5cAf454Ba92e6F2c929DF14667Ee360eD9fD5b26";
  const buyPercentage = 5;
  const sellPercentage = 5;
  const minMarketCap = 50000;

  it("should buy and sell tokens successfully", async () => {
    const erc20Bot = await ERC20Bot.new(uniswapRouter, dexTools, buyPercentage, sellPercentage, minMarketCap, { from: owner });

    // Mint some tokens to test with
    const tokenAddress = "0x1234567890123456789012345678901234567890";
    const token = await ERC20.at(tokenAddress);
    await token.mint(1000000000000000000, { from: owner });

    // Approve transfer of tokens to the ERC20Bot contract
    await token.approve(erc20Bot.address, 1000000000000000000, { from: owner });

    // Buy the tokens with ETH
    await erc20Bot.buyToken(tokenAddress, { value: web3.utils.toWei("1", "ether"), from: owner });

    // Check that the ERC20Bot contract now holds the tokens
    const balance = await token.balanceOf(erc20Bot.address);
    assert.equal(balance.toString(), "1000000000000000000");

    // Sell the tokens for ETH
    await erc20Bot.sellToken(tokenAddress, { from: owner });

    // Check that the ERC20Bot contract no longer holds the tokens
    const newBalance = await token.balanceOf(erc20Bot.address);
    assert.equal(newBalance.toString(), "0");
  });
});
