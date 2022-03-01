// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {IFeeProvider} from "./interfaces/IFeeProvider.sol";

contract FeeProvider is Ownable, IFeeProvider {

    uint[] public prices; 
    uint public LAST_INDEX;

    // [0, 0, 0, 2, 1, 0.5, 0.1]

    constructor(uint[] memory _prices, uint _lastIndex){
        require(_lastIndex <= _prices.length);
        prices = _prices;
        LAST_INDEX = _lastIndex;
    }

    function setPrice(uint index, uint newPrice) external virtual override onlyOwner {
        prices[index] = newPrice;
        emit PriceUpdated(index, newPrice);
    }

    function getPrice(uint index) external view virtual override returns(uint) {
        if (index <= LAST_INDEX) return prices[index];
        else return prices[LAST_INDEX];
    }
}