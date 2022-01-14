// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

abstract contract Base {
    modifier onlyIdentityOwner(bytes32 identity){
        require(ownerOf(uint(identity)) == msg.sender, "Base: Caller not identity owner");
        _;
    }

    function ownerOf(uint tokenId) public virtual returns(address);
}