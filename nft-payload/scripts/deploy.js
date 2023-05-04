const hre = require("hardhat");
const fs = require('fs');

async function main() {
  const Moonlight = await hre.ethers.getContractFactory("Moonlight");
  const moonlight = await Moonlight.deploy();
  await moonlight.deployed();
  console.log("Moonlight is deployed to:", moonlight.address);

  fs.writeFileSync('./config.js', `
  export const moonlightAddress = "${moonlight.address}"
  `)
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
