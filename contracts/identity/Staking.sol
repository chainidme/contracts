// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { IStaking } from "./../interfaces/IStaking.sol";

abstract contract Staking is IStaking {

    mapping (address => bool) peerStake;

    /// @notice Owner could staking peer-to-peer relationships
    function stakePeer(address _peer) external {
        peerStake[_peer] = true;
        emit PeerStaked(_peer);
    }

    /// @notice Unstake peer
    function unstakePeer(address _peer) external {
        peerStake[_peer] = false;
        emit PeerUnstaked(_peer);
    }
}