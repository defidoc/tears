import { expect } from "chai";
import { ethers } from "hardhat";

import { Tears } from "../typechain/Tears"
import { TearsFaucet } from "../typechain/TearsFaucet"

describe("Tears", function () {
  it("Should deploy the token", async function () {
    const [owner, ...addrs] = await ethers.getSigners();
    const Token = await ethers.getContractFactory("Tears")
    const token:Tears = await Token.deploy()
    await token.deployed();

    const Faucet = await ethers.getContractFactory("TearsFaucet");
    const faucet:TearsFaucet = await Faucet.deploy(token.address);

    console.log(await token.balanceOf(owner.address))

    await token.transfer(faucet.address, await token.balanceOf(owner.address));

    await faucet.redeem("0x23396cF899Ca06c4472205fC903bDB4de249D6fC", ethers.utils.parseEther("1000"));    
  });
});
