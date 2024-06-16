// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

library PriceConverter {
    // To get 1 ETH = ? USD
    function getPrice() internal view returns (uint256) {
        // Sepolia ETH / USD address:
        // https://docs.chain.link/data-feeds/price-feeds/addresses
        AggregatorV3Interface priceFeed = AggregatorV3Interface(
            0x694AA1769357215DE4FAC081bf1f309aDC325306
        );

        (, int256 answer, , , ) = priceFeed.latestRoundData();

        // 回傳的 answer 小數位數為 8 digits
        // 我們將它乘上 1e10, 使其小數位數為 18 digits, 與 wei 對齊
        return uint256(answer) * 1e10;
    }

    // Input: ETH amount (wei)
    // Output: ETH amount (wei) in USD
    function getConversionRate(
        uint256 ethAmount
    ) internal view returns (uint256) {
        uint256 ethPrice = getPrice();
        uint256 ethAmountInUsd = (ethPrice * ethAmount) / 1e18;

        return ethAmountInUsd;
    }
}
