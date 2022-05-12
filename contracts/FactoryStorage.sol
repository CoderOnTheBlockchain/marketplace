// SPDX-License-Identifier: MIT
pragma solidity 0.8.13;

import "./Storage.sol";

contract Factory {

    event ERC721TokenCreated(address tokenAddress);
    
  function createSimpleStorageContract() public {
        Storage simpleStorage = new Storage();
        Storage.push(simpleStorage);
    }
	
    function deployNewsimpleNft(string memory name, string memory symbol)
        public
        returns (address)
    {
        simpleNft  t = new simpleNft (name, symbol);
        emit ERC721TokenCreated(address(t));

        return address(t);
    }	
}
