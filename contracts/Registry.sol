// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {Counters} from "@openzeppelin/contracts/utils/Counters.sol";

import {Attributes} from "./identity/Attributes.sol";
import {Delegation} from "./identity/Delegation.sol";
import {Staking} from "./identity/Staking.sol";

import {IFeeProvider} from "./utils/interfaces/IFeeProvider.sol";

/// @title Identity Contract
/// @author Prasad Kumkar - <prasad@chainid.me>
contract Registry is Attributes, Delegation, Staking, ERC721 {
    using Counters for Counters.Counter;
    Counters.Counter idCount;

    // hash(identifier) => tokenID
    mapping(bytes32 => uint256) public identity;

    address public feeProvider;

    string private __baseURI;

    constructor(string memory baseURI, address _feeProvider) ERC721("ChainID", "ID") {
        __baseURI = baseURI;
    }

    function _baseURI() internal view virtual override returns (string memory) {
        return __baseURI;
    }

    function registerIdentity(bytes memory _id) public payable {
        bytes32 idHash = keccak256(_id);
        require(identity[idHash] == 0, "Identity already registered");

        require(msg.value >= IFeeProvider(feeProvider).getPrice(_id.length), "Insufficient fee");

        idCount.increment();
        _mint(msg.sender, idCount.current());

        emit NewRegistration(_id, msg.sender);
    }

    event NewRegistration(bytes _id, address owner);
}
