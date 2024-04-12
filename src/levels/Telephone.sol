// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// Claim ownership of the contract below to complete this level.
//
// Things that might help
//  - See the "?" page above, section "Beyond the console"
contract Telephone {
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    function changeOwner(address _owner) public {
        if (tx.origin != msg.sender) {
            owner = _owner;
        }
    }
}
