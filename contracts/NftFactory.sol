// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.13;

import "./Storage.sol";
import "./simpleNft.sol";
contract Factory {
    event ERC721Created(address tokenAddress, address owner);

    Storage storageContract;

    constructor(address _storageAddress){
        storageContract = Storage(_storageAddress);
    }
    
    function deployNewNft(
        string memory _name,
         string memory _symbol,
          string memory _baseUri
          )
        public
        returns (address)
    {
        simpleNft  nft = new simpleNft(_name, _symbol, _baseUri);
        emit ERC721Created(address(nft), msg.sender);
        storageContract.addCollection(_name, _symbol, nft, msg.sender, _baseUri);
        return address(nft);
    }	
}
