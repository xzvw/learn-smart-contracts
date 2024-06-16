// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script} from "forge-std/Script.sol";
import {HelperConfig} from "../script/HelperConfig.s.sol";
import {FundMe} from "../src/FundMe.sol";

contract DeployFundMe is Script {
    function run() external returns (FundMe) {
        // Before `startBroadcast()`: not a real transaction (will be in the simulated environment)
        HelperConfig helperConfig = new HelperConfig();
        address ethUsdPriceFeed = helperConfig.activeNetworkConfig();

        vm.startBroadcast();
        // After `startBroadcast()`: a real transaction

        // Sepolia ETH / USD address:
        // https://docs.chain.link/data-feeds/price-feeds/addresses
        FundMe fundMe = new FundMe(ethUsdPriceFeed);

        vm.stopBroadcast();

        return fundMe;
    }
}
