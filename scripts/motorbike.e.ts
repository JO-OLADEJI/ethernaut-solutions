import { ethers } from "hardhat";

async function main() {
  const [exploiter] = await ethers.getSigners();

  const motorbikeAddress = "0x2bA6E3a288F890Fe00543b2eA8E1B27544730632";

  // gets contract address of `Engine` (logic) contract stored in `Motorbike` contract
  const engineAddress = await ethers.provider.getStorageAt(
    motorbikeAddress,
    "0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc" // `_IMPLEMENTATION_SLOT` variable
  );

  console.log({ engineAddress });
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
