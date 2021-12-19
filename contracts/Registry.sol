// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {Counters} from "@openzeppelin/contracts/utils/Counters.sol";

import {Attributes} from "./identity/Attributes.sol";
import {Delegation} from "./identity/Delegation.sol";
import {Staking} from "./identity/Staking.sol";

/// @title Identity Contract
/// @author Prasad Kumkar - <prasad@chainid.me>
contract Registry is Attributes, Delegation, Staking, ERC721 {
    using Counters for Counters.Counter;
    Counters.Counter idCount;

    // hash(identifier) => tokenID
    mapping(bytes32 => uint256) public identity;

    uint256[] price = [
        0 ether,        // 0 letters
        10000 ether,    // 1 letter
        10000 ether,    // 2 letters
        1000 ether,     // 3 letters
        1000 ether,     // 4 letters
        100 ether,      // 5 letters
        100 ether,      // 6 letters
        10 ether,       // 7 letters
        10 ether,       // 8 letters
        1 ether         // 9+ letters
    ];

    string private __baseURI;

    constructor(string memory baseURI) ERC721("ChainID", "ID") {
        __baseURI = baseURI;
    }

    function _baseURI() internal view virtual override returns (string memory) {
        return __baseURI;
    }

    function registerIdentity(bytes memory _id) public payable {
        bytes32 idHash = keccak256(_id);
        require(identity[idHash] == 0, "Identity already registered");

        uint256 fee = 0;
        if (_id.length <= 9) fee = price[_id.length];
        else fee = price[9];

        require(msg.value >= fee, "Insufficient fee");

        idCount.increment();
        _mint(msg.sender, idCount.current());

        emit NewRegistration(_id, msg.sender);
    }

    event NewRegistration(bytes _id, address owner);
}
