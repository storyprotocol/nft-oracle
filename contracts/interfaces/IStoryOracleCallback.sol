// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

interface IStoryOracleCallback {
    function fulfill(bytes32 _requestId, string memory _data) external;
}