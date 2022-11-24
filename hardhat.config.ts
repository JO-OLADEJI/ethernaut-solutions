import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
import "dotenv/config";

const config: HardhatUserConfig = {
  solidity: "0.8.17",
  defaultNetwork: "goerli",
  networks: {
    goerli: {
      url: process.env.GOERLI_RPC,
      accounts: [`0x${process.env.EXPLOITER_PRIVATE_KEY ?? ""}`],
    },
  },
  etherscan: {
    apiKey: "8DE28XGN9GQPNMS9UVJBE7QIGZI3SFKBMQ",
  }
};

export default config;
