// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.13;

contract Proxy {
    mapping(address => bool) private _admins;

    address private _implementation;

    error NotAdmin();

    constructor(address _implem) {
        _implementation = _implem;
    }

    modifier onlyAdmin() {
        if (_admins[msg.sender] == false) {
            revert NotAdmin();
        }
        _;
    }

    /// @notice set the implementation address of the proxy
    /// @param implem the address of the new implementation
    function setImplementation(address implem) external onlyAdmin {
        _implementation = implem;
    }

    function addAdmin(address admin) external onlyAdmin {
        _admins[admin] = true;
    }

    /// @notice fallback function
    fallback() external payable {
        _fallback();
    }

    /// @notice fallback function
    receive() external payable {
        _fallback();
    }

    /// @notice delegate all calls to the implementation
    /// @dev This is copy - paste from standard
    function _fallback() internal {
        address _impl = _implementation;

        // Fallback to implementation
        assembly {
            // Copy msg.data. We take full control of memory in this inline assembly
            // block because it will not return to Solidity code. We overwrite the
            // Solidity scratch pad at memory position 0.
            calldatacopy(0, 0, calldatasize())

            // Call the implementation.
            // out and outsize are 0 because we don't know the size yet.
            let result := delegatecall(gas(), _impl, 0, calldatasize(), 0, 0)

            // Copy the returned data.
            returndatacopy(0, 0, returndatasize())

            switch result
            // delegatecall returns 0 on error.
            case 0 { revert(0, returndatasize()) }
            default { return(0, returndatasize()) }
        }
    }
}
