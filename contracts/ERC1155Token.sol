// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.13;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract ERC1155Token is ERC1155, Ownable {

    uint256 supplyMax;
    uint256 supplyTotal;
    string public baseMetadataURI;

    constructor(string memory _uri, uint256 memory _maxSupply) ERC1155(_uri) {
        baseMetadataURI = _uri;
        maxSupply = _maxSupply;
    }

    function uri(uint256 _tokenId) public view virtual override returns (string memory) {
        return string(
            abi.encodePacked(baseMetadataURI, '/', Strings.toString(_tokenId), ".json")
        );       
    }

    function mint(address _userAddress, uint256 _amount) public payable {
        require(account != address(0), "ERC1155: mint to the zero address");
        require(supplyMax <= _amount + supplyTotal, string(
            abi.encodePacked('Not enough supply, rest ', supplyMax - supplyTotal)
        ));

        _mint(_userAddress, supplyTotal, _amount, "{name: \'COIN Project\'}");
    }
}
