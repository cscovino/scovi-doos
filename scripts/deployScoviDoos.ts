import { ethers } from "hardhat";

async function main() {
  const [deployer] = await ethers.getSigners();

  console.log(`Deploying contract with the account: ${deployer.address}`);

  const PlatziPunks = await ethers.getContractFactory("ScoviDoos");
  const deployed = await PlatziPunks.deploy(10000);

  console.log(`Scovi Doo is deployed at: ${deployed.address}`);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
