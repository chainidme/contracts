// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {IStaking} from "./interfaces/IStaking.sol";
import {Base} from "./Base.sol";

abstract contract Staking is IStaking, Base {
    mapping(address => uint256) peerCount;
    mapping(bytes32 => uint256) stakeCount;

    // address => (stake_id => identity)
    // stake_id starts from 1 (not 0)
    mapping(address => mapping(uint256 => bytes32)) stakes;
    mapping(bytes32 => mapping(uint256 => address)) acknowledges;

    // (identity, address) => closeness [from address]
    // (address, identity) => closeness [from identity]
    mapping(bytes32 => uint256) public closeness;

    // (identity, address) => validity [from address]
    // (address, identity) => validity [from identity]
    mapping(bytes32 => uint256) public validity;

    /// @notice Owner could staking peer-to-peer relationships
    function stake(
        bytes32 _identity,
        uint256 _closeness,
        uint256 _validity
    ) external virtual override {
        if (hasStaked(msg.sender, _identity)) {
            peerCount[msg.sender] += 1;
            stakes[msg.sender][peerCount[msg.sender]] = _identity;
        }
        bytes32 idHash = keccak256(abi.encodePacked(_identity, msg.sender));
        closeness[idHash] = _closeness;
        validity[idHash] = _validity;

        emit Staked(_identity, msg.sender, _closeness, _validity);
    }

    function acknowledge(
        bytes32 _identity,
        address _peer,
        uint256 _closeness,
        uint256 _validity
    ) external virtual override onlyIdentityOwner(_identity) {
        if (hasAcknowledged(_identity, _peer)) {
            stakeCount[_identity] += 1;
            acknowledges[_identity][stakeCount[_identity]] = _peer;
        }
        bytes32 idHash = keccak256(abi.encodePacked(msg.sender, _identity));
        closeness[idHash] = _closeness;
        validity[idHash] = _validity;

        emit StakeAcknowledged(_identity, _peer, _closeness, _validity);
    }

    /// @notice Unstake peer
    function unstake(bytes32 _identity) external virtual override {
        uint256 stakeId = getStake(msg.sender, _identity);

        stakes[msg.sender][stakeId] = stakes[msg.sender][peerCount[msg.sender]];
        peerCount[msg.sender] -= 1;

        emit Unstaked(_identity, msg.sender);
    }

    function removeAcknowledgement(address _peer, bytes32 _identity)
        external
        virtual
        override
    {
        uint256 ackId = getAcknowledgement(_identity, msg.sender);

        acknowledges[_identity][ackId] = acknowledges[_identity][
            stakeCount[_identity]
        ];
        stakeCount[_identity] -= 1;

        emit AcknowledgementRemoved(_peer, _identity);
        (_identity, msg.sender);
    }

    function hasStaked(address _peer, bytes32 _identity)
        public
        view
        virtual
        override
        returns (bool)
    {
        return getStake(_peer, _identity) > 0;
    }

    function getStake(address _peer, bytes32 _identity)
        public
        view
        virtual
        override
        returns (uint256)
    {
        for (uint256 i = 0; i < peerCount[_peer]; i++) {
            if (stakes[_peer][i] == _identity) {
                return i;
            }
        }
        return 0;
    }

    function hasAcknowledged(bytes32 _identity, address _peer)
        public
        view
        virtual
        override
        returns (bool)
    {
        return getAcknowledgement(_identity, _peer) > 0;
    }

    function getAcknowledgement(bytes32 _identity, address _peer)
        public
        view
        virtual
        override
        returns (uint256)
    {
        for (uint256 i = 0; i < stakeCount[_identity]; i++) {
            if (acknowledges[_identity][i] == _peer) {
                return i;
            }
        }
        return 0;
    }

    function verifyStake(address _peer, bytes32 _identity)
        public
        view
        virtual
        override
        returns (bool, uint256)
    {
        return (
            hasStaked(_peer, _identity) &&
                (validity[keccak256(abi.encodePacked(_identity, _peer))] >
                    block.timestamp),
            closeness[keccak256(abi.encodePacked(_identity, _peer))]
        );
    }

    function verifyAcknowledgement(bytes32 _identity, address _peer)
        public
        view
        virtual
        override
        returns (bool, uint256)
    {
        return (
            hasAcknowledged(_identity, _peer) &&
                (validity[keccak256(abi.encodePacked(_peer, _identity))] >
                    block.timestamp),
            closeness[keccak256(abi.encodePacked(_peer, _identity))]
        );
    }

    function verifyBilateralStake(address _peer, bytes32 _identity)
        external
        view
        virtual
        override
        returns (bool, uint256)
    {
        uint256 mutualCloseness;
        if (
            closeness[keccak256(abi.encodePacked(_identity, _peer))] >
            closeness[keccak256(abi.encodePacked(_peer, _identity))]
        ) {
            mutualCloseness = closeness[
                keccak256(abi.encodePacked(_identity, _peer))
            ];
        } else {
            mutualCloseness = closeness[
                keccak256(abi.encodePacked(_peer, _identity))
            ];
        }

        (bool _hasStaked, ) = verifyStake(_peer, _identity);
        (bool _hasAck, ) = verifyAcknowledgement(_identity, _peer);

        return (_hasStaked && _hasAck, mutualCloseness);
    }
}