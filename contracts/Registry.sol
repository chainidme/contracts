// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {Counters} from "@openzeppelin/contracts/utils/Counters.sol";

import {Attributes} from "./identity/Attributes.sol";
import {Delegation} from "./identity/Delegation.sol";
import {Staking} from "./identity/Staking.sol";

import {IFeeProvider} from "./utils/interfaces/IFeeProvider.sol";
import {IRegistry} from "./interfaces/IRegistry.sol";

/// @title Identity Contract
/// @author Prasad Kumkar - <prasad@chainid.me>
contract Registry is IRegistry, Attributes, Delegation, Staking, ERC721 {
    using Counters for Counters.Counter;
    Counters.Counter private idCount;

    // hash(identifier) => tokenID
    mapping(bytes32 => uint256) public identity;

    address public feeProvider;

    string private __baseURI;

    constructor(string memory baseURI, address _feeProvider) ERC721("ChainID", "ID") {
        __baseURI = baseURI;
        feeProvider = _feeProvider;
    }

    function _baseURI() internal view virtual override returns (string memory) {
        return __baseURI;
    }

    function registerIdentity(bytes memory _id) public payable {
        require(identity[keccak256(_id)] == 0, "Identity already registered");
        require(msg.value >= IFeeProvider(feeProvider).getPrice(_id.length), "Insufficient fee");

        identity[keccak256(_id)] = _mintID(msg.sender);

        emit NewRegistration(_id, msg.sender);
    }

    function _mintID(address _idOwner) internal returns(uint tokenID) {
        idCount.increment();
        uint newIdCount = idCount.current();
        _mint(_idOwner, newIdCount);
        return newIdCount;
    }

    function resolveID(bytes memory _id) public view returns(address) {
        return ownerOf(identity[keccak256(_id)]);
    }
}
