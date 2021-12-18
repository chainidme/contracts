// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IAttributes {

    struct Attribute {
        address from;
        string name;
        string value;
        bytes32 commitment;
    }

    function setAttribute(address to, bytes32 name, bytes32 value, uint validForSeconds) external;

    function revokeAttribute(bytes32 name) external; 


    /* ========== View functions ========== */

    function verifyAttribute(address from, bytes32 name, bytes32 value) external view returns(bool result);

    function getAttribute(address to, uint index) external view returns(Attribute memory);

    /* ========== Events ========== */

    event AttributeAdded(address _from, address _to, string _name, string _value, uint validity);
    event AttributeCommitted(address _from, address _to, string _name, string _value, uint validity);

    event AttributeRevoked(address _from, bytes32 _attr);
}