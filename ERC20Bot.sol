pragma solidity ^0.8.0;

interface IUniswapV2Router02 {
    function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline) external payable returns (uint[] memory amounts);
    function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline) external returns (uint[] memory amounts);
    function getAmountsOut(uint amountIn, address[] memory path) external view returns (uint[] memory amounts);
}

interface IERC20 {
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
}

contract ERC20Bot {
    address private owner;
    address private uniswapRouter;
    address private dexTools;
    uint256 private buyPercentage;
    uint256 private sellPercentage;
    uint256 private minMarketCap;
    bool private isPaused;

    mapping(address => bool) private alreadyBought;
    mapping(address => bool) private alreadySold;

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function.");
        _;
    }

    modifier whenNotPaused() {
        require(!isPaused, "Contract is paused.");
        _;
    }

    constructor(address _uniswapRouter, address _dexTools, uint256 _buyPercentage, uint256 _sellPercentage, uint256 _minMarketCap) {
        owner = msg.sender;
        uniswapRouter = _uniswapRouter;
        dexTools = _dexTools;
        buyPercentage = _buyPercentage;
        sellPercentage = _sellPercentage;
        minMarketCap = _minMarketCap;
    }

    function buyToken(address _tokenAddress) external payable whenNotPaused {
        require(!alreadyBought[_tokenAddress], "Token has already been bought.");
        require(!alreadySold[_tokenAddress], "Token has already been sold.");
        require(IERC20(_tokenAddress).balanceOf(address(this)) == 0, "Contract already holds this token.");
        require(getMarketCap(_tokenAddress) <= minMarketCap, "Token market cap is too high.");

        uint256 amountIn = msg.value;
        uint256 amountOutMin = calculateBuyAmount(_tokenAddress, amountIn);

        address[] memory path = new address[](2);
        path[0] = uniswapRouter.WETH();
        path[1] = _tokenAddress;

        uint256[] memory amounts = IUniswapV2Router02(uniswapRouter).swapExactETHForTokens{value: amountIn}(amountOutMin, path, address(this), block.timestamp + 30 minutes);

        alreadyBought[_tokenAddress] = true;

        uint256 sellAmount = calculateSellAmount(_tokenAddress, amounts[1]);

        IERC20(_tokenAddress).approve(uniswapRouter, sellAmount);
        IUniswapV2Router02(uniswapRouter).swapExactTokensForETH(sellAmount, 0, path, owner, block.timestamp + 30 minutes);

        uint256 profit = (amounts[1] - amountOutMin);
        uint256 profitPercentage = (profit * 100) / amountOutMin;

        if (profitPercentage >= sellPercentage) {
            uint256 ethToTransfer = address(this).balance;
            (bool success, ) = owner.call{value: ethToTransfer}("");
            require(success, "Failed to transfer ETH to the owner.");
        }

        alreadySold[_tokenAddress] = true;
    }

    function calculateBuyAmount(address _tokenAddress, uint256 _amountIn) private view returns (uint256) {
        address[] memory path = new address[](2);
        path[0] = uniswapRouter.WETH();
        path[1] = _tokenAddress;

        uint256[] memory amounts = IUniswapV2Router02(uniswapRouter).getAmountsOut(_amountIn, path);

        return (amounts[1] * buyPercentage) / 100;
    }

    function calculateSellAmount(address _tokenAddress, uint256 _amountIn) private view returns (uint256) {
        address[] memory path = new address[](2);
        path[0] = _tokenAddress;
        path[1] = uniswapRouter.WETH();

        uint256[] memory amounts = IUniswapV2Router02(uniswapRouter).getAmountsOut(_amountIn, path);
        return (amounts[1] * sellPercentage) / 100;
    }

    function getMarketCap(address _tokenAddress) private view returns (uint256) {
        // Implement the logic to fetch the market cap of the token from DexTools or any other external source
    }

    function pause() external onlyOwner {
        isPaused = true;
    }

    function unpause() external onlyOwner {
        isPaused = false;
    }

    receive() external payable {}

    fallback() external payable {}
}

