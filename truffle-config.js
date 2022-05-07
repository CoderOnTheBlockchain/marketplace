const path = require("path");
const HDWalletProvider = require("@truffle/hdwallet-provider");
require('dotenv').config();

module.exports = {
  contracts_build_directory: path.join(__dirname, "client/src/contracts"),
  networks: {
    development: {
      host: "127.0.0.1",
      port: `${process.env.LOCAL_PORT}`,
      network_id: "*"
    },
    kovan: {
      provider: () =>
        new HDWalletProvider({
          mnemonic:       {phrase: `${process.env.MNEMONIC}`},
          providerOrUrl:  `https://kovan.infura.io/v3/${process.env.INFURA_ID}`,
        }),
      network_id: '42'
    },
    ropsten: {
      provider: () =>
        new HDWalletProvider({
          mnemonic:       {phrase: `${process.env.MNEMONIC}`},
          providerOrUrl:  `https://ropsten.infura.io/v3/${process.env.INFURA_ID}`,
        }),
      network_id: '3'
    },
    rinkeby: {
      provider: () =>
        new HDWalletProvider({
          mnemonic:       {phrase: `${process.env.MNEMONIC}`},
          providerOrUrl:  `https://rinkeby.infura.io/v3/${process.env.INFURA_ID}`,
        }),
      network_id: '4'
    }
  },
  compilers: {
    solc: {
      version: "0.8.13"
    }
  },
  mocha: {}
};
