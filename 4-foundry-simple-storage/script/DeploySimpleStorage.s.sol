// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script} from "forge-std/Script.sol";
import {SimpleStorage} from "../src/SimpleStorage.sol";

contract DeploySimpleStorage is Script {
    // The main function which is going to be called
    function run() external returns (SimpleStorage) {
        // vm:
        // - Defined in `forge-std`
        // - Can only be used within Foundry
        // - Related to something called Foundry cheat codes (?)
        // - `vm.startBroadcast()` means that everything after this line should be sent to the RPC
        //   when using the command with `--broadcast` parameter
        vm.startBroadcast();

        SimpleStorage simpleStorage = new SimpleStorage();

        vm.stopBroadcast();

        return simpleStorage;
    }
}
