// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import {PriceConverter} from "./PriceConverter.sol";

error FundMe__NotOwner();

contract FundMe {
    using PriceConverter for uint256;

    address public immutable i_owner;
    AggregatorV3Interface private s_priceFeed;

    uint256 public constant MINIMUM_USD = 5e18;

    address[] public s_funders;
    mapping(address => uint256) public s_addressToAmountFunded;

    constructor(address priceFeedAddress) {
        i_owner = msg.sender;
        s_priceFeed = AggregatorV3Interface(priceFeedAddress);
    }

    modifier onlyOwner() {
        // Custom error
        // 等同: require(msg.sender == i_owner, "Must be owner");
        if (msg.sender != i_owner) {
            revert FundMe__NotOwner();
        }

        _;
    }

    // Get fund from a user
    function fund() public payable {
        require(
            msg.value.getConversionRate(s_priceFeed) >= MINIMUM_USD,
            "Didn't send enough ETHs"
        );

        s_funders.push(msg.sender);
        s_addressToAmountFunded[msg.sender] += msg.value;
    }

    function withdraw() public onlyOwner {
        for (
            uint256 funderIndex = 0;
            funderIndex < s_funders.length;
            funderIndex++
        ) {
            address funder = s_funders[funderIndex];
            s_addressToAmountFunded[funder] = 0;
        }

        // Reset the funders array
        s_funders = new address[](0);

        // Send tokens, 有三種方法:

        /*
        // 1. transfer: payableAddress.transfer(amountInWei)
        payable(msg.sender).transfer(address(this).balance);
        // 說明:
        // - `msg.sender` 為呼叫合約者的 address, type 為 address
        // - `payable(msg.sender)` 使其 type 轉換為 payable, 確保可以接收 ETH
        // - `address(this)`: the address of the current contract
        // - `address.balance` 的單位為 wei
        */

        /*
        // 2. send:
        bool sendSuccess = payable(msg.sender).send(address(this).balance);
        require(sendSuccess, "Send failed");
        */

        // 3. call:
        // - A low-level instruction
        // - Can call every function without ABI
        (bool callSuccess, ) = payable(msg.sender).call{
            value: address(this).balance
        }("");
        require(callSuccess, "Call failed");
    }

    function getVersion() public view returns (uint256) {
        return s_priceFeed.version();
    }

    receive() external payable {
        fund();
    }

    fallback() external payable {
        fund();
    }
}
