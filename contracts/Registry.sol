// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {ERC721, IERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";

import {Counters} from "@openzeppelin/contracts/utils/Counters.sol";

import {Attributes} from "./identity/Attributes.sol";
import {Delegation} from "./identity/Delegation.sol";
import {Staking} from "./identity/Staking.sol";
import {Base} from "./identity/Base.sol";

import {IFeeProvider} from "./utils/interfaces/IFeeProvider.sol";
import {IRegistry} from "./interfaces/IRegistry.sol";
import {IdentityValidator} from "./utils/validators/IdentityValidator.sol";

/// @title Identity Contract
/// @author Prasad Kumkar - <prasad@chainid.me>
contract Registry is IRegistry, Attributes, Delegation, Staking, ERC721, IdentityValidator {
    using Counters for Counters.Counter;
    Counters.Counter private idCount;

    address private feeProvider;
    string private baseURI;

    mapping(bytes32 => uint256) private subIdCount;
    mapping(bytes32 => mapping(uint256 => bytes32)) private subIdentities;

    constructor(string memory __baseURI, address _feeProvider)
        ERC721("Chain Identity", "CHAINID")
    {
        baseURI = __baseURI;
        feeProvider = _feeProvider;
    }

    function _baseURI() internal view virtual override returns (string memory) {
        return baseURI;
    }

    function registerIdentity(bytes32 _id) public payable virtual override {
        require(!_exists(uint256(_id)), "Identity already registered");
        require(
            msg.value >= IFeeProvider(feeProvider).getPrice(_id.length),
            "Registry: Insufficient fee"
        );

        require(validate(_id));

        _mint(msg.sender, uint256(_id));

        emit NewRegistration(_id, msg.sender);
    }

    // function registerSubIdentity(bytes32 _id, bytes32 _subId)
    //     external
    //     onlyIdentityOwner(_id)
    // {
    //     require(!subIdentityExists(_id, _subId));
    //     subIdCount[_id] += 1;

    //     subIdentities[_id][subIdCount] = _subId;
    // }

    // function subIdentityExists(bytes32 _id, bytes32 _subId) public returns(bool){
    //     return getSubIdentity(_id, _subId) > 0;
    // }

    // function getSubIdentity(bytes32 _id, bytes32 _subId) public returns(uint){
    //     for(uint i = 0; i < subIdCount[_id]; i++){
    //         if(subIdentities[_id][i] == _subId){
    //             return i;
    //         }
    //     }
    //     return 0;
    // }

    // ========== VIEW FUNCTIONS ========== //

    function getIdentity(bytes32 _id)
        external
        view
        virtual
        override
        returns (address)
    {
        return ownerOf(uint256(_id));
    }

    function ownerOf(uint256 tokenId)
        public
        view
        virtual
        override(ERC721, IERC721, Base)
        returns (address)
    {
        return super.ownerOf(tokenId);
    }
}
