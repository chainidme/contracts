// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

contract IdentityValidator is Ownable {

    uint public constant MAX_LENGTH = 100;

    mapping (bytes1 => bool) isInvalid;

    constructor(){
        isInvalid[bytes1(".")] = true;
    }

    function validate(bytes memory identity) public view returns(bool){
        require(identity.length < MAX_LENGTH);

        for(uint i = 0; i < identity.length; i++){
            require(!isInvalid[identity[i]]);
        }
        
        return true;
    }

    function setCharInvalid(bytes1 _char) external onlyOwner {
        isInvalid[_char] = true;
    }
}