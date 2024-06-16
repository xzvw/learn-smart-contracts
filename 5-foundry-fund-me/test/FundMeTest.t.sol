// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Test, console} from "forge-std/Test.sol";
import {DeployFundMe} from "../script/DeployFundMe.s.sol";
import {FundMe} from "../src/FundMe.sol";

contract FundMeTest is Test {
    FundMe fundMe;

    // 首先會呼叫 setUp
    function setUp() external {
        DeployFundMe deployFundMe = new DeployFundMe();
        fundMe = deployFundMe.run();
    }

    function testOwnerIsMsgSender() public view {
        // Not quite understand why `msg.sender` here 😿
        assertEq(fundMe.i_owner(), msg.sender);
    }

    function testMinimumUsdIsFive() public view {
        assertEq(fundMe.MINIMUM_USD(), 5e18);
    }

    function testPriceFeedVersionIsAccureate() public view {
        uint256 version = fundMe.getVersion();
        assertEq(version, 4);
    }
}
