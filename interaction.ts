import { ethers } from "hardhat";

const main = async () => {

//   const stakingJuliet = await ethers.getContractAt("IStaking", "0x5C8f5D80FD653a885832dF5c1f09978C81A8cDC4");

    ////// Alternative way of interactng with a deployed contract without using Contract Interface /////
    const StakingJuliet = await ethers.getContractFactory("Staking");
    const stakingJuliet = StakingJuliet.attach("0xAb4155dad989DFa948cC1ea25438e6b9e3C2A6E7");

  const stakeTxn = await stakingJuliet.stake(1, { value: ethers.utils.parseEther("0.1")});
  const stakeTxnReciept = await stakeTxn.wait();
  console.log("Stake: ", stakeTxnReciept);

    const stakeBalanceTxn = await stakingJuliet.checkContractBalance();
    console.log("Stake: ", stakeBalanceTxn);

//  const stakeWithdrawTxn = await stakingJuliet.withdraw();
//  const stakeWithdrawTxnReciept = await stakeWithdrawTxn.wait();
//  console.log("Stake: ", stakeWithdrawTxnReciept);
  

}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
