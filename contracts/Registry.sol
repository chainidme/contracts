// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import 'hardhat/console.sol';

import {ERC721, IERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";

import {Counters} from "@openzeppelin/contracts/utils/Counters.sol";

import {Attributes} from "./identity/Attributes.sol";
import {Delegation} from "./identity/Delegation.sol";
import {Staking} from "./identity/Staking.sol";
import {Base} from "./identity/Base.sol";

import {IFeeProvider} from "./utils/interfaces/IFeeProvider.sol";
import {IRegistry} from "./interfaces/IRegistry.sol";
import {IValidator} from "./utils/interfaces/IValidator.sol";

/// @title Identity Contract
/// @author Prasad Kumkar - <prasad@chainid.me>
contract Registry is IRegistry, Attributes, Delegation, Staking, ERC721 {
    using Counters for Counters.Counter;
    Counters.Counter private idCount;

    address private feeProvider;
    address private validator;
    string private baseURI;

    mapping(bytes32 => uint256) private subIdCount;
    mapping(bytes32 => mapping(uint256 => bytes32)) private subIdentities;

    constructor(string memory __baseURI, address _feeProvider, address _validator)
        ERC721("Chain Identity", "CHAINID")
    {
        baseURI = __baseURI;
        feeProvider = _feeProvider;
        validator = _validator;
    }

    function _baseURI() internal view virtual override returns (string memory) {
        return baseURI;
    }

    function registerIdentity(bytes memory _id) external payable virtual override {

        bytes32 tokenId = keccak256(_id);
        require(!_exists(uint256(tokenId)), "Identity already registered");
        require(
            msg.value >= IFeeProvider(feeProvider).getPrice(_id.length),
            "Registry: Insufficient fee"
        );

        require(IValidator(validator).validateIdentity(_id));

        _mint(msg.sender, uint256(tokenId));

        emit NewRegistration(tokenId, msg.sender);
    }

    // subcompany.company.parentcompany
    // ["subcompany", "company", "parentcompany"]
    // check ownerOf("parentcompany")
    function registerSubIdentity(bytes[] memory _ids, address _to)
        external
    {
        require(ownerOf(uint(keccak256(_ids[_ids.length]))) == msg.sender);

        bytes memory id = "";
        for(uint i =0 ; i<_ids.length; i++){
            if(i>0) bytes.concat(".");
            bytes.concat(_ids[i]);
        }

        _mint(_to, uint(keccak256(id)));
    }

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

    function getIdentity(bytes memory _id)
        external
        view
        virtual
        override
        returns (address)
    {
        return ownerOf(uint256(keccak256(_id)));
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

      function getPrice(bytes memory _id)
        external
        view
        virtual
        override
        returns (uint256)
    {
        return IFeeProvider(feeProvider).getPrice(_id.length);
    }
}
