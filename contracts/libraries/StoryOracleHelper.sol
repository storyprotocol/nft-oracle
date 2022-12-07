// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;


library StoryOracleHelper {
    struct Request {
        bytes32 id;
        address callbackAddress;
        uint256 nonce;
        string url;
        string path;
    }

    function initialize(
        Request memory self,
        address callbackAddr,
        string memory url,
        string memory path
    ) internal pure returns (StoryOracleHelper.Request memory) {
        self.callbackAddress = callbackAddr;
        self.url = url;
        self.path = path;
        return self;
    }
}
