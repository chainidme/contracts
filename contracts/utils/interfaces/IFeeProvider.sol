// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IFeeProvider {

    function setPrice(uint index, uint newPrice) external;

    function getPrice(uint index) external view returns(uint);
}