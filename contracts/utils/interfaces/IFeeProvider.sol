// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IFeeProvider {

    event PriceUpdated(uint index, uint newPrice);

    function setPrice(uint index, uint newPrice) external;

    function getPrice(uint index) external view returns(uint);

    function getSubIdPrice(uint index) external view returns(uint);
}