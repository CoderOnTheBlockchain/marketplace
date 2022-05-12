// SPDX-License-Identifier: MIT
pragma solidity 0.8.13;

import "./Storage.sol";

contract Factory {
  function createSimpleStorageContract() public {
        Storage simpleStorage = new Storage();
        Storage.push(simpleStorage);
    }
	
	
}