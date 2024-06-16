// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {PriceConverter} from "./PriceConverter.sol";

error NotOwner();

contract FundMe {
    using PriceConverter for uint256;

    address public immutable i_owner;

    uint256 public constant MINIMUM_USD = 5e18;

    address[] public funders;
    mapping(address => uint256) public addressToAmountFunded;

    constructor() {
        i_owner = msg.sender;
    }

    modifier onlyOwner() {
        // Custom error
        // 等同: require(msg.sender == i_owner, "Must be owner");
        if (msg.sender != i_owner) {
            revert NotOwner();
        }

        _;
    }

    // Get fund from a user
    function fund() public payable {
        require(
            msg.value.getConversionRate() >= MINIMUM_USD,
            "Didn't send enough ETHs"
        );

        funders.push(msg.sender);
        addressToAmountFunded[msg.sender] += msg.value;
    }

    function withdraw() public onlyOwner {
        for (
            uint256 funderIndex = 0;
            funderIndex < funders.length;
            funderIndex++
        ) {
            address funder = funders[funderIndex];
            addressToAmountFunded[funder] = 0;
        }

        // Reset the funders array
        funders = new address[](0);

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

    receive() external payable {
        fund();
    }

    fallback() external payable {
        fund();
    }
}
