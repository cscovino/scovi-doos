import { HardhatUserConfig } from "hardhat/config";
import * as dotenv from 'dotenv';
import "@nomicfoundation/hardhat-toolbox";

dotenv.config();
const projectId = process.env.INFURA_PROJECT_ID || '';
const privateKey = process.env.DEPLOYER_SIGNER_PRIVATE_KEY || '';

const config: HardhatUserConfig = {
  solidity: "0.8.9",
  networks: {
    goerli: {
      url: `https://goerli.infura.io/v3/${projectId}`,
      accounts: [
        privateKey,
      ],
    },
    rinkeby: {
      url: `https://rinkeby.infura.io/v3/${projectId}`,
      accounts: [
        privateKey,
      ],
    },
  },
};

export default config;
