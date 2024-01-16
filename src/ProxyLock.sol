// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract ProxyLock {
    bool private _locked;

    address private _implementation;

    address private _admin;

    error ProxyIsLocked();

    error NotAdmin();

    error NotAContract();

    constructor() {
        _locked = true;
        _admin = msg.sender;
    }

    modifier unlocked() {
        if (_locked == true) {
            revert ProxyIsLocked();
        }
        _;
    }

    /// @notice set the implementation address of the proxy
    /// @param implem the address of the new implementation
    function setImplementation(address implem) external unlocked {
        // TODO: uncomment this
        // if (msg.sender != _admin) {
        //  revert NotAdmin();
        //}
        _implementation = implem;
    }

    /// @notice call the callYou() function of the contract passed as parameter
    /// @param you the address of the contract to call
    function callYou(address you) external {
        if (you.code.length != 0) {
            revert NotAContract();
        }
        _locked = false;
        // I am calling the callYou() function of the contract at address $you
        // what could go wrong??
        you.call(abi.encode("callYou()"));
        _locked = true;
    }

    /// @notice fallback function
    fallback() external payable {
        _locked = false;
        _fallback();
    }

    /// @notice fallback function
    receive() external payable {
        _locked = false;
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

            // Just added a _locked = true in this standard code
            sstore(_locked.slot, true)

            // Copy the returned data.
            returndatacopy(0, 0, returndatasize())

            switch result
            // delegatecall returns 0 on error.
            case 0 {
                revert(0, returndatasize())
            }
            default {
                return(0, returndatasize())
            }
        }
    }
}
