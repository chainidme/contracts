// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


interface IAttributes {

    struct Attribute {
        address from;
        string name;
        string value;
        bytes32 commitment;
    }

    event AttributeAdded(address from, address to, string name, string value, uint validity);
    event AttributeRevoked(address from, bytes32 attr);

    function setAttribute(address to, string memory name, string memory value, uint validForSeconds) external;

    function commitAttribute(bytes32 attr, uint validForSeconds) external;

    function revokeAttribute(bytes32 attr) external;

    /* ========== View functions ========== */

    function verifyAttribute(address from, address to, string memory name, string memory value) external view returns(bool result);


    function getAttribute(address to, uint index) external view returns(Attribute memory);

    function getAllAttributes(address recipient) external view returns(Attribute[] memory);
}