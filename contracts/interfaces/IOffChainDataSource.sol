// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

interface IOffChainDataSource {
    function getData(address user) external view returns (string memory data);
    function load(address user, string memory url, string memory path) external;
}
