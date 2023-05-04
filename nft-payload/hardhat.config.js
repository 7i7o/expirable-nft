require("@nomicfoundation/hardhat-toolbox");
require("@nomiclabs/hardhat-etherscan");
require("@nomiclabs/hardhat-ethers");

const fs = require('fs');
const privateKey = fs.readFileSync(".secret").toString().trim() || "01234567890123456789"
const infuraId = fs.readFileSync(".infuraid").toString().trim() || "";

module.exports = {
  defaultNetwork: "hardhat",
  networks: {
    hardhat: {
      chainId: 1337
    },
    mainnet: {
      url: `https://mainnet.infura.io/v3/${infuraId}`,
      accounts: [privateKey]
    },
    mumbai: {
      url: `https://polygon-mumbai.infura.io/v3/${infuraId}`,
      accounts: [privateKey]
    },
    matic: {
      url: `https://polygon-mainnet.infura.io/v3/${infuraId}`,
      accounts: [privateKey]
    },
    rinkeby: {
      url: `https://rinkeby.infura.io/v3/${infuraId}`,
      accounts: [privateKey]
    },
    arbitrum: {
      url: `https://arbitrum-mainnet.infura.io/v3/${infuraId}`,
      accounts: [privateKey]
    }
  },
  solidity: {
    version: "0.8.18",
    settings: {
      optimizer: {
        enabled: true,
        runs: 200
      }
    }
  },
  etherscan: {
    // Your API key for Etherscan
    // Obtain one at https://etherscan.io/
    apiKey:'2D134SPWU6WE6M7VXZUX4PWSSSUI9EKFUE'
  },
}