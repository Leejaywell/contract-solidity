import hre from "hardhat";
import { verifyContract } from "@nomicfoundation/hardhat-verify/verify";

async function main() {
  const connection = await hre.network.connect();
  const { ethers } = connection;

  console.log("Deploying FundMe contract...");
  const fundMe = await ethers.deployContract("FundMe", [300]);

  // 等待部署完成 (推荐)
  const deployed = await fundMe.waitForDeployment();
  // 获取地址
  const fundMeAddress = await deployed.getAddress();
  console.log(`FundMe deployed to: ${fundMeAddress}`);

   // 如果要验证
  if (connection.networkConfig.chainId === 11155111) {
    // 如果你要等待额外确认
    const tx = await deployed.deploymentTransaction();
    await tx.wait(4);

    console.log("Verifying contract...");
    await verifyContract(
      {
        address: fundMeAddress,
        constructorArgs: [10],
        provider: "etherscan",  // 使用 Etherscan 作为验证服务
      },
      hre
    );
    console.log("Contract verified!");
  }

//   const [irstAccount, secondAmount] = await ethers.getSigners();
//   const funTx = await fundMe.fund({value: ethers.parseEther("0.01")});
//   await funTx.wait();
//   console.log(`Funded 0.01 ETH from ${irstAccount.address}`);
//   const balance = await ethers.provider.getBalance(fundMeAddress);
//   console.log(`Contract balance: ${ethers.formatEther(balance)} ETH`);
 
}

main().catch((error) => {
  console.error("Error:", error);
  process.exit(1);
});