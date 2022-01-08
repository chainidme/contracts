// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

contract FeeProvider is Ownable{

    uint[] public prices;
    uint public LAST_INDEX;

    constructor(uint[] memory _prices, uint _lastIndex){
        require(_lastIndex <= _prices.length);
        prices = _prices;
        LAST_INDEX = _lastIndex;
    }

    function setPrice(uint index, uint newPrice) external onlyOwner {
        prices[index] = newPrice;
    }

    function getPrice(uint index) external view returns(uint) {
        if (index <= LAST_INDEX) return prices[index];
        else return prices[LAST_INDEX];
    }

    function getSubIdPrice(uint index) external view returns(uint) {
        if (index <= LAST_INDEX) return prices[index];
        else return prices[LAST_INDEX];
    }
}