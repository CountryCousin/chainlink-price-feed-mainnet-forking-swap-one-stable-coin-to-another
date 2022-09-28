// SPDX-License-Identifier:MIT
pragma solidity ^0.8.4;

import "./DegenToken.sol";

contract Staking is DegenToken {

    struct StakeData {
        uint stakedAmount;
        uint noOfDays;
        uint yearLater;
    }

    mapping(address => StakeData) stakes;

    address admin;

    constructor() {
        admin = msg.sender;
    }

    function stake(uint _days) external payable {
        require(msg.value > 0, "You can't stake zero value");
        require(_days > 0, "staking period can't be less than 0 days");

        StakeData storage sData = stakes[msg.sender];
        sData.stakedAmount += msg.value;
        sData.noOfDays = block.timestamp + (_days * 1 days);
        sData.yearLater = block.timestamp + 365 days;

        mint(msg.value);
    }

    function withdraw() external {
        StakeData memory userStake = stakes[msg.sender];

        require(block.timestamp > userStake.noOfDays, "staking period not reached");
        require(userStake.stakedAmount > 0, "you don't have a stake");
        require(balanceOf(msg.sender) >= userStake.stakedAmount, "placeholder token not enough");

        uint calculatedYield = calculateYield(userStake.noOfDays, userStake.stakedAmount, userStake.yearLater);

        uint transferable = userStake.stakedAmount + calculatedYield;

        stakes[msg.sender].stakedAmount = 0;
        stakes[msg.sender].noOfDays = 0;

        _transfer(msg.sender, address(this), userStake.stakedAmount);
        payable(msg.sender).transfer(transferable);
    }

    function calculateYield(uint _days, uint stakedAmount, uint _yearLater) private pure returns (uint yield) {
        uint daysQuotient = _days/_yearLater;
        yield = daysQuotient * stakedAmount;
    }

    function showCalculatedAPY() external view returns (uint apy) {
        StakeData storage userStake = stakes[msg.sender];
        uint daysQuotient = userStake.noOfDays/userStake.yearLater;
        apy = daysQuotient * userStake.stakedAmount;
    }

    function checkContractBalance() external view returns (uint bal) {
        bal = address(this).balance;
    }

    receive() external payable {}

    function withFromContract(uint _amount) external {
        require(msg.sender == admin, "not owner");
        payable(admin).transfer(_amount);
    }
}