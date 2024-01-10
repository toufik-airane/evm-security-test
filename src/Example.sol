// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

/// @title A stupid contract than can be deployed to call the function of another contract
contract Example {
    function callProxy(address target) external {
        // calling the foo(address) function of the contract at address $target
        // with a random address as parameter
        target.call(
            abi.encodeWithSignature(
                "foo(address)",
                address(0x9b8c989FF27e948F55B53Bb19B3cC1947852E393)
            )
        );
    }
}
