// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.13;

// Store anything inside the KV Database and get paid !
contract Database {
    mapping(uint256 => bytes32) internal _db;

    event Funded(address indexed from, uint256 value);

    function write(uint256 key, bytes32 value) external {
        _db[key] = value;
        (bool success,) = msg.sender.call{value: 0.0001 ether}("");
        require(success, "Failed to send Ether");
    }

    function read(uint256 key) external view returns (bytes32) {
        return _db[key];
    }

    function fund() external payable {
        emit Funded(msg.sender, msg.value);
    }
}
