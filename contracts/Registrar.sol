// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/access/Ownable.sol";


contract Registrar is Ownable, AccessControl {

    bytes32 public constant REGISTRAR_ROLE = keccak256('REGISTRAR_ROLE');

    constructor(){
        _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
    }

    function transferOwnership(address newOwner) public virtual override onlyOwner {
        super.transferOwnership(newOwner);
        _setupRole(DEFAULT_ADMIN_ROLE, newOwner);
    }

    function addRegistrar(address reg) external onlyRegistrar {
        _setupRole(REGISTRAR_ROLE, reg);
    }

    function removeRegistrar(address reg) external onlyOwner {
        revokeRole(REGISTRAR_ROLE, reg);
    }

    modifier onlyRegistrar() {
        require(hasRole(REGISTRAR_ROLE, msg.sender));
        _;
    }
}