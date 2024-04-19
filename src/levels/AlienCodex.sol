// SPDX-License-Identifier: MIT
pragma solidity ^0.5.0;

import "../helpers/Ownable-05.sol";

// You've uncovered an Alien contract. Claim ownership to complete the level.
//
// Things that might help
//  - Understanding how array storage works
//  - Understanding ABI specifications
//      - https://docs.soliditylang.org/en/v0.4.21/abi-spec.html
//  - Using a very underhanded approach
contract AlienCodex is Ownable {
    bool public contact;
    bytes32[] public codex;

    modifier contacted() {
        assert(contact);
        _;
    }

    function makeContact() public {
        contact = true;
    }

    function record(bytes32 _content) public contacted {
        codex.push(_content);
    }

    function retract() public contacted {
        codex.length--;
    }

    function revise(uint i, bytes32 _content) public contacted {
        codex[i] = _content;
    }
}
