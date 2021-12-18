// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { ERC721 } from "@openzeppelin/contracts/token/ERC721/ERC721.sol";

import { Attributes } from "./identity/Attributes.sol";
import { Delegation } from "./identity/Delegation.sol";
import { Staking } from "./identity/Staking.sol";

/// @title Identity Contract
/// @author Prasad Kumkar - <prasad@chainid.me>
contract Identity is 
Attributes,
Delegation,
Staking
{
    bytes32 public id;

    constructor(bytes32 _id) 
    {
        id = _id;
    }
}