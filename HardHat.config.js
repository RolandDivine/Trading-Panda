require("@nomiclabs/hardhat-ethers");
require("@nomiclabs/hardhat-truffle5");
require("dotenv").config();

module.exports = {
  solidity: "0.8.0",
  networks: {
    hardhat: {},
    rinkeby: {
      url: process.env.RINKEBY_URL || "",
      accounts: [process.env.PRIVATE_KEY || ""],
    },
    // Add additional network configurations as needed
  },
};
