// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {ERC721Enumerable} from "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";

import {Counters} from "@openzeppelin/contracts/utils/Counters.sol";

import {Attributes} from "./identity/Attributes.sol";
import {Delegation} from "./identity/Delegation.sol";
import {Staking} from "./identity/Staking.sol";

import {IFeeProvider} from "./utils/interfaces/IFeeProvider.sol";
import {IRegistry} from "./interfaces/IRegistry.sol";


/// @title Identity Contract
/// @author Prasad Kumkar - <prasad@chainid.me>
contract Registry is IRegistry, Attributes, Delegation, Staking, ERC721Enumerable {
    using Counters for Counters.Counter;
    Counters.Counter private idCount;

    // hash(address user, uint STAKE_VALUE) => identity
    mapping (bytes32 => bytes32) stake;

    // hash(tokenID) => owner
    // mapping(uint => address) public identity;

    // hash(rootID) => (hash(rootID, ID) => tokenID)
    // mapping(uint => mapping(uint => uint256)) public subIdentity;

    address public feeProvider;
    string private __baseURI;

    constructor(string memory baseURI, address _feeProvider) ERC721("ChainID", "ID") {
        __baseURI = baseURI;
        feeProvider = _feeProvider;
    }

    function _baseURI() internal view virtual override returns (string memory) {
        return __baseURI;
    }

    function registerIdentity(bytes32 _id) public payable {
        // require(identity[keccak256(_id)] == 0, "Identity already registered");
        require(msg.value >= IFeeProvider(feeProvider).getPrice(_id.length), "Insufficient fee");

        // identity[keccak256(_id)] = _mintID(msg.sender);
        identity[keccak256(_id)] = _mint(msg.sender, uint(_id));

        emit NewRegistration(_id, msg.sender);
    }

    // ========== VIEW FUNCTIONS ========== //

    function getIdentity(bytes32 _id) external view returns(address){
        return ownerOf(identites[_id]);
    }

    function getIdentitiesByOwner(address owner) external view returns(bytes32[] memory){
        for(uint i = 0; i < balanceOf(owner); i++){
            // if(tokenOfOwnerByIndex(owner, i))
        }
    }

    // ========== INTERNAL FUNCTIONS ========== //

    
}
