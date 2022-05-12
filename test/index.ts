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

    const TestToken = await ethers.getContractFactory("TestToken")
    const ust = await TestToken.deploy("UST", "UST", 46_000_000)
    const luna = await TestToken.deploy("Luna", "Luna", 640_000_000)

    const Faucet = await ethers.getContractFactory("TearsFaucet");
    const faucet:TearsFaucet = await Faucet.deploy(token.address, ust.address, luna.address);

    await token.transfer(faucet.address, (await token.totalSupply()).mul(9).div(10))

    

    console.log(await token.balanceOf(owner.address))

    await token.transfer(faucet.address, await token.balanceOf(owner.address));

    const out = await faucet.getOutput(ethers.utils.parseEther("500000000")); 
    console.log(out)
    
    console.log(out.mul(100).div(await token.totalSupply()))
    
    await ust.approve(faucet.address, ethers.utils.parseEther("10000"))
    await faucet.redeem(ust.address, ethers.utils.parseEther("10000"))

    console.log(ethers.utils.formatEther(await token.balanceOf(owner.address)))
  });
});
