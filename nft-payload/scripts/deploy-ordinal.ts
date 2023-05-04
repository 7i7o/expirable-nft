import { ethers } from "hardhat";

async function main() {
  // console.log("TEST");
  const OrdinalDesc = await ethers.getContractFactory('OrdinalDesc');
  const ordinalDesc = await OrdinalDesc.deploy();
  await ordinalDesc.deployed();
  console.log("OrdinalDesc deployed to: ", ordinalDesc.address);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});