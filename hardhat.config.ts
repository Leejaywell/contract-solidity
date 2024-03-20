import hardhatToolboxViemPlugin from "@nomicfoundation/hardhat-toolbox-viem";
import { configVariable, defineConfig } from "hardhat/config";
import hardhatEthers from "@nomicfoundation/hardhat-ethers";
import hardhatVerify from "@nomicfoundation/hardhat-verify";


import * as envEnc from "@chainlink/env-enc";
envEnc.config(); // Load environment variables
export default defineConfig({
  plugins: [
    hardhatToolboxViemPlugin,
    hardhatEthers,
    hardhatVerify
  ],
  solidity: {
    profiles: {
      default: {
        version: "0.8.30",
      },
      production: {
        version: "0.8.30",
        settings: {
          optimizer: {
            enabled: true,
            runs: 200,
          },
        },
      },
    },
  },
  networks: { 
    hardhatMainnet: {
      type: "edr-simulated",
      chainType: "l1",
    },
    hardhatOp: {
      type: "edr-simulated",
      chainType: "op",
    },
    sepolia: {
      type: "http",
      chainType: "l1",
      chainId: 11155111,
      url: configVariable("SEPOLIA_RPC_URL"),
      accounts: [configVariable("SEPOLIA_PRIVATE_KEY")],
    },
  },
  verify: {
    etherscan: {
      apiKey: "3NF8V6XZKAVGJYYHRXSFWANWR1YBR3F7SW"
    },
  },
});
