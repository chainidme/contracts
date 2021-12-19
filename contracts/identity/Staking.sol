// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { IStaking } from "./../interfaces/IStaking.sol";

abstract contract Staking is IStaking {

    mapping (bytes32 => uint) public isStaked;

    /// @notice Owner could staking peer-to-peer relationships
    function stake(address _peer, uint validity) external virtual override {
        isStaked[keccak256(abi.encodePacked(_peer, msg.sender))] = validity;
        emit Staked(_peer);
    }

    /// @notice Unstake peer
    function unstake(address _peer) external virtual override {
        isStaked[keccak256(abi.encodePacked(_peer, msg.sender))] = block.timestamp;
        emit Unstaked(_peer);
    }

    function verifyStake(address from, address to) public view virtual override returns(bool) {
        return isStaked[keccak256(abi.encodePacked(from, to))] < block.timestamp;
    }

    function verifyBilateralStake(address user1, address user2) external view virtual override returns(bool) {
        return verifyStake(user1, user2) && verifyStake(user2, user1);
    }
}