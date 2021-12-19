// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { SafeMath } from "@openzeppelin/contracts/utils/math/SafeMath.sol";
import { IAttributes } from "./../interfaces/IAttributes.sol";


// attributes
// assigner
// recipient
abstract contract Attributes is IAttributes {
    using SafeMath for uint;

    // hash(from, hash(to, name, value)) => validity
    mapping (bytes32 => uint) public attributeCommitment;

    // hash(to, attr_index) => Attribute
    mapping (bytes32 => Attribute) public attributes;
    mapping (address => uint) public attrCount;

    /// @notice Set Publically visible attribute to user
    /// @dev use `commitAttribute` to set private attribute
    /// @param to address to user to assign to
    /// @param name of attribute
    /// @param value of attribute
    /// @param validForSeconds validity in seconds
    function setAttribute(address to, string memory name, string memory value, uint validForSeconds) 
        public virtual override 
    {
        attrCount[to].add(1);
        Attribute storage new_attr = attributes[keccak256(abi.encodePacked(to, attrCount[to]))];

        new_attr.from = msg.sender;
        new_attr.name = name;
        new_attr.value = value;

        bytes32 commitment = keccak256(abi.encodePacked(msg.sender, abi.encodePacked(to, name, value)));

        new_attr.commitment = commitment;
        
        // store commitment
        attributeCommitment[commitment] = validForSeconds;

        emit AttributeAdded(msg.sender, to, new_attr.name, new_attr.value, validForSeconds);
    }

    function commitAttribute(bytes32 attr, uint validForSeconds)
        public virtual override 
    {
        attributeCommitment[keccak256(abi.encodePacked(msg.sender, attr))] = validForSeconds;
    }

    function revokeAttribute(bytes32 attr)
        external virtual override 
    {
        attributeCommitment[keccak256(abi.encodePacked(msg.sender, attr))] = block.timestamp;

        emit AttributeRevoked(msg.sender, attr);
    }

    /* ========== View functions ========== */

    function verifyAttribute(address from, address to, string memory name, string memory value)
        external
        view virtual override 
        returns(bool result)
    {
        uint validity = attributeCommitment[keccak256(abi.encodePacked(from, abi.encodePacked(to, name, value)))];
        return (validity < block.timestamp); 
    }


    function getAttribute(address to, uint index)
        public
        view virtual override 
        returns(Attribute memory)
    {
        return attributes[keccak256(abi.encodePacked(to, index))];
    }

    function getAllAttributes(address recipient)
    external 
    view virtual override 
    returns(Attribute[] memory)
    {
        Attribute[] memory attrs = new Attribute[](attrCount[recipient]);

        for(uint i = 0; i< attrCount[recipient]; i.add(1)){
            attrs[i] = getAttribute(recipient, i);
        }
        return attrs;
    }
}