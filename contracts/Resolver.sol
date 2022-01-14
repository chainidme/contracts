// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {IRegistry} from "./interfaces/IRegistry.sol";

contract Resolver {

    IRegistry public registrar;

    constructor(address _registrar){
        registrar = IRegistry(_registrar);
    }

    // function resolveID(bytes memory _id) public view returns(address) {
    //     return registrar.ownerOf(identity[keccak256(_id)]);
    // }

    function resolveID(bytes32 _id) external view returns(address) {
        return registrar.getIdentity(_id);
    }

    // function resolveSubID(bytes memory _id) external view returns(address){
    //     return registrar.getSubIdentity(_subId, _id);
    // }
}