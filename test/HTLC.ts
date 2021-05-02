import { expect } from "chai";
import { ethers } from "hardhat";
import { SignerWithAddress } from "@nomiclabs/hardhat-ethers/dist/src/signer-with-address";
import { Token, Token__factory, HTLC, HTLC__factory } from "../typechain";

// Alice has tokenA and wants to exchange her tokens with Bob's tokenB.

describe("Hash Time Locked Contracts", () => {
  let tokenA: Token, tokenB: Token, htlc: HTLC, signers: SignerWithAddress[];
  const totalSupply = ethers.utils.parseEther(String(10 ** 6));

  before("Deploy Contracts", async () => {
    signers = await ethers.getSigners();

    const Token: Token__factory = (await ethers.getContractFactory("Token")) as Token__factory;
    tokenA = await Token.deploy("TokenA", "A", totalSupply);
    tokenB = await Token.connect(signers[1]).deploy("TokenB", "B", totalSupply);

    const Htlc: HTLC__factory = (await ethers.getContractFactory("HTLC")) as HTLC__factory;
    htlc = await Htlc.deploy();
  });

  describe("Contracts", async () => {
    it("Should not be address(0)", async () => {
      expect(tokenA.address).not.equal(ethers.constants.AddressZero);
      expect(tokenB.address).not.equal(ethers.constants.AddressZero);
      expect(htlc.address).not.equal(ethers.constants.AddressZero);
    });

    it("Should match total supply", async () => {
      expect(await tokenA.totalSupply()).to.equal(totalSupply);
      expect(await tokenB.totalSupply()).to.equal(totalSupply);
    });
  });

  describe("New HTLC", async () => {

    // Task performed by Alice
    const amount = ethers.utils.parseEther("1");
    const password = ethers.utils.formatBytes32String("secret password");
    const hashedPassword = ethers.utils.keccak256(password);
    const current_time = Math.floor(Date.now() / 1000);
    const hour_seconds = 3600;
    const expiry_time = current_time + hour_seconds; // Expire in 1hr
    // Allow htlc contract to transfer token to itself at the time of creating new contract
    const approve_tx = await tokenA.approve(htlc.address, amount);
    await approve_tx.wait();

    const htlc_tx = await htlc.newContract(await signers[1].getAddress(), hashedPassword, expiry_time, tokenA.address, amount);
    await htlc_tx.wait() 

  });
});
