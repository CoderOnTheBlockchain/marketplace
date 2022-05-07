// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.13;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract ERC1155Token is ERC1155, Ownable {
    
    string public baseMetadataURI;

    constructor(string memory _uri) ERC1155(_uri) {
        baseMetadataURI = _uri;
    }

    function uri(uint256 _tokenId) public view virtual override returns (string memory) {
        return string(
            abi.encodePacked(baseMetadataURI, '/', Strings.toString(_tokenId), ".json")
        );       
    }   
}
