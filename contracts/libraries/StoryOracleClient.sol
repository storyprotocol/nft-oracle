// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "./StoryOracleHelper.sol";
import "../interfaces/IStoryOracleCallback.sol";


abstract contract StoryOracleClient {
    using StoryOracleHelper for StoryOracleHelper.Request;

    uint256 private requestCount = 1;
    mapping(bytes32 => StoryOracleHelper.Request) private pendingRequests;

    event StoryOracleFulfilled(bytes32 indexed requestId);
    event StoryOracleCancelled(bytes32 indexed requestId);

    event StoryOracleRequest(
        bytes32 indexed requestId, // unique id of the oracle request, story oracle backend would call back with id.
        address requester,  // address of smart contract which sending the oracle request
        address callbackAddr,  // address of smart contract which implemented the callback function
        string indexed url,  // url of the json file
        string indexed path  // path the locate content within the json file
    );

    function buildOracleRequest(
        IStoryOracleCallback oracleCallback,
        string memory url,
        string memory path
    ) internal pure returns (StoryOracleHelper.Request memory) {
        StoryOracleHelper.Request memory req;
        return req.initialize(address(oracleCallback), url, path);
    }

    function cancelOracleRequest(bytes32 requestId) external {
        delete pendingRequests[requestId];
        emit StoryOracleCancelled(requestId);
    }

    function sendOracleRequest(StoryOracleHelper.Request memory req) internal returns (bytes32 requestId) {
        uint256 nonce = requestCount;
        requestCount = nonce + 1;
        requestId = keccak256(abi.encodePacked(this, nonce));
        req.id = requestId;
        pendingRequests[requestId] = req;
        emit StoryOracleRequest(req.id, address(this), req.callbackAddress, req.url, req.path);
    }

    function getNextRequestCount() public view returns (uint256) {
        return requestCount;
    }

    modifier recordOracleFulfillment(bytes32 requestId) {
        require(pendingRequests[requestId].id != 0, "the requestId does not exist");
        delete pendingRequests[requestId];
        emit StoryOracleFulfilled(requestId);
        _;
    }

}
