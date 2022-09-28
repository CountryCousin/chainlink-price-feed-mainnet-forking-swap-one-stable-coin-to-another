// SPDX-License-Identifier:MIT
pragma solidity ^0.8.4;

interface IStaking {


    function stake(uint _days) external payable;

    function withdraw() external;

    function checkContractBalance() external view returns (uint bal);
}