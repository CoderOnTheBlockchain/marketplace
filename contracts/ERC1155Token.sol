// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.13;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract ERC1155Token is ERC1155, Ownable {

    uint256 private supplyMax;
    uint256 private supplyTotal;
    string private baseMetadataURI;

    constructor() ERC1155("") {}

    function setSupplyMax(uint256 _supplyMax) external onlyOwner {
        supplyMax = _supplyMax;
    }

    function uri(uint256 _tokenId) public view virtual override returns (string memory) {
        return string(
            abi.encodePacked(baseMetadataURI, '/', Strings.toString(_tokenId), ".json")
        );       
    }

    function mint(address _userAddress, uint256 _amount) public payable {
        require(_userAddress != address(0), "ERC1155: mint to the zero address");
        require(supplyMax <= _amount + supplyTotal, string(
            abi.encodePacked('Not enough supply, rest ', supplyMax - supplyTotal)
        ));

        _mint(_userAddress, supplyTotal, _amount, "{name: \'COIN Project\'}");
    }
}
