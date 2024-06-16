// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {SimpleStorage} from "./SimpleStorage.sol";

contract StorageFactory {
    SimpleStorage[] public listOfSimpleStorageContracts;

    function createSimpleStorageContract() public {
        SimpleStorage simpleStorageContract = new SimpleStorage();
        listOfSimpleStorageContracts.push(simpleStorageContract);
    }

    function storageFactoryStore(
        uint256 _simpleStorageIndex,
        uint256 _simpleStorageNumber
    ) public {
        listOfSimpleStorageContracts[_simpleStorageIndex].store(
            _simpleStorageNumber
        );
    }

    function storageFactoryGet(uint256 _simpleStorageIndex)
        public
        view
        returns (uint256)
    {
        return listOfSimpleStorageContracts[_simpleStorageIndex].retrieve();
    }
}
