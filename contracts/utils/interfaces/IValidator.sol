// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IValidator {
    function validateIdentity(bytes memory identity) external view returns(bool);
    function validateSubIdentity(bytes memory identity) external view returns(bool);

    function setCharInvalid(bytes1 _char) external;
    function setMaxLength(uint maxLen) external;
    function setMinLength(uint minlen) external;
}