const hre = require("hardhat");

async function main() {
  const RentFlow = await hre.ethers.getContractFactory("RentFlow");
  const rentFlow = await RentFlow.deploy();
  await rentFlow.deployed();

  console.log("RentFlow deployed to:", rentFlow.address);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
