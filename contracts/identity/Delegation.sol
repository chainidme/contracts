// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// import { IDelegation } from "./../interfaces/IDelegation.sol";

abstract contract Delegation /** is IDelegation */ {

    // hash(delegateType, delegate) => validity
    mapping (bytes32 => uint) delegates;

    function addDelegate(address to, bytes32 delegateType, address delegate, uint validity) 
    public
    {
        // delegates[_delegateHash(delegateType, delegate)] = validity;
        // emit DelegateAdded(delegateType, delegate, validity);
    }

    function revokeDelegate(bytes32 delegateType, address delegate) 
    public
    {
        // delegates[_delegateHash(delegateType, delegate)] = block.timestamp;
        // emit DelegateRevoked(delegateType, delegate);
    }

    function validDelegate(bytes32 delegateType, address delegate) 
        public 
        view 
        returns(bool)
    {
        // return block.timestamp < delegates[_delegateHash(delegateType, delegate)];
    }
}