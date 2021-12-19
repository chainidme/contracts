// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IStaking {

    function stake(address _peer, uint validity) external;

    function unstake(address _peer) external;

    function verifyStake(address from, address to) external view returns(bool);

    function verifyBilateralStake(address user1, address user2) external view returns(bool);

    event Staked(address _peer);
    event Unstaked(address peer);
}