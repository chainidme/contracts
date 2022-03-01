// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";

contract Validator is Ownable {

    uint public MAX_LENGTH = 100;
    uint public MIN_LENGTH = 3;

    mapping (bytes1 => bool) public isCharInvalid;

    constructor(){
        isCharInvalid[bytes1(".")] = true;
    }

    function validateIdentity(bytes memory identity) external view returns(bool){
        require(identity.length < MAX_LENGTH);

        for(uint i = 0; i < identity.length; i++){
            require(!isCharInvalid[identity[i]]);
        }
        
        return true;
    }


    function setCharInvalid(bytes1 _char) external onlyOwner {
        isCharInvalid[_char] = true;
    }

    function setMaxLength(uint maxLen) external onlyOwner {
        MAX_LENGTH = maxLen;
    }

    function setMinLength(uint minlen) external onlyOwner {
        MIN_LENGTH = minlen;
    }
}