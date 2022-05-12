// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// When running the script with `npx hardhat run <script>` you'll find the Hardhat
// Runtime Environment's members available in the global scope.
import { ethers } from "hardhat";

async function main() {
  // Hardhat always runs the compile task when running scripts with its command
  // line interface.
  //
  // If this script is run directly using `node` you may want to call compile
  // manually to make sure everything is compiled
  // await hre.run('compile');

  // We get the contract to deploy
  const Token = await ethers.getContractFactory("Tears");
  const token = await Token.deploy();

  await token.deployed();

  console.log("Token deployed to:", token.address);

  const Faucet = await ethers.getContractFactory("TearsFaucet");
  const faucet = await Faucet.deploy(token.address,"0x23396cF899Ca06c4472205fC903bDB4de249D6fC", "0x156ab3346823B651294766e23e6Cf87254d68962");

  await faucet.deployed()

  await token.transfer(faucet.address, (await token.totalSupply()).mul(95).div(100))

  console.log("Faucet deployed to: ", faucet.address);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
