// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {IERC721} from "@openzeppelin/contracts/token/ERC721/IERC721.sol";

interface IRegistry is IERC721 {
    
    event NewRegistration(bytes32 _id, address owner);

    function registerIdentity(bytes32 _id) external payable;
    // function registerSubIdentity(bytes memory _id, bytes memory _rootId) external;

    function getIdentity(bytes32 _id) external view returns(address);
    // function getSubIdentity(bytes32 _subId, bytes32 _id) external view returns(address);
}