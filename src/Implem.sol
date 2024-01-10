// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract Implem {
    error NotAllowed();

    /// @notice withdraw all the balance of the contract
    function withdraw() external {
        // no one is allowed to withdraw muahahah
        revert NotAllowed();

        // send all balance of the contract to the caller
        address(msg.sender).call{value: address(this).balance}("");
    }
}
