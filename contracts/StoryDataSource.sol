// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "@chainlink/contracts/src/v0.8/ChainlinkClient.sol";
import "@chainlink/contracts/src/v0.8/ConfirmedOwner.sol";
import "./interfaces/IOffChainDataSource.sol";
import { Strings } from '@openzeppelin/contracts/utils/Strings.sol';
import "./interfaces/IStoryOracleCallback.sol";
import "./libraries/StoryOracleClient.sol";
import "./libraries/StoryOracleHelper.sol";

contract StoryDataSource  is IOffChainDataSource, IStoryOracleCallback, StoryOracleClient {
    using StoryOracleHelper for StoryOracleHelper.Request;
    using Strings for uint256;

    mapping(address=>string) public userData;
    mapping(bytes32=>address) public requests;

    event RequestData(bytes32 indexed requestId, string data);

    constructor()  {}

    function getData(address user) public view override returns(string memory data) {
        return userData[user];
    }

    function load(address user, string memory url, string memory path) public override {
        bytes32 requestId = requestUserData(url, path);
        requests[requestId] = user;
    }

    function requestUserData(string memory url, string memory path) public returns (bytes32 requestId) {
        StoryOracleHelper.Request memory req = buildOracleRequest(
            this, url, path);

        return sendOracleRequest(req);
    }

    function fulfill(
        bytes32 _requestId,
        string memory _data
    ) public override recordOracleFulfillment(_requestId) {
        emit RequestData(_requestId, _data);
        userData[requests[_requestId]] = _data;
    }
}
