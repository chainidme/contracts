// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IStaking {
    
    struct Stake {
        bytes32 identity;
        address peer;
        uint closeness;
        uint validity;
    }
    // (closeness, stake) => validity

    event Staked(bytes32 identity, address peer, uint closeness, uint validity);
    event StakeAcknowledged(bytes32 identity, address peer, uint closeness, uint validity);
    event Unstaked(bytes32 identity, address peer);
    event AcknowledgementRemoved(address peer, bytes32 identity);

    function stake(bytes32 _identity, uint _closeness, uint _validity) external;
    function acknowledge(bytes32 _identity, address _peer, uint _closeness, uint _validity) external;

    function unstake(bytes32 _identity) external;
    function removeAcknowledgement(address _peer, bytes32 _identity) external;

    function hasStaked(address _peer, bytes32 _identity) external view returns(bool);
    function getStake(address _peer, bytes32 _identity) external view returns(uint);

    function hasAcknowledged(bytes32 _identity, address _peer) external view returns(bool);
    function getAcknowledgement(bytes32 _identity, address _peer) external view returns(uint);

    function verifyStake(address _peer, bytes32 _identity) external view returns(bool, uint);
    function verifyAcknowledgement(bytes32 _identity, address _peer) external view returns(bool, uint);
    function verifyBilateralStake(address _peer, bytes32 _identity) external view returns(bool, uint);
}