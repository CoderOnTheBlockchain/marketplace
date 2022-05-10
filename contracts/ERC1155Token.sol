// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.13;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract ERC1155Token is ERC1155, Ownable {

    uint256 private supplyMax;
    uint256 private supplyTotal;
    
    constructor(string memory _uri) ERC1155(_uri) {
        _setURI(_uri);
    }

    function setSupplyMax(uint256 _supplyMax) external onlyOwner {
        supplyMax = _supplyMax;
    }

    function getSupplyMax() public view returns(uint256) {
        return supplyMax;
    }

    function getTokenIdURI(uint256 id) public view virtual returns (string memory) {
        return string(
            abi.encodePacked(uri(0), '/', Strings.toString(id), ".json")
        );
    }

    function getSupplyTotal() public view returns(uint256) {
        return supplyTotal;
    }

    function mint(uint256 _amount) public payable {
        require(msg.sender != address(0), "ERC1155: mint to the zero address");
        require(supplyMax <= _amount + supplyTotal, string(
            abi.encodePacked('Not enough supply, rest ', supplyMax - supplyTotal)
        ));

        _mint(msg.sender, supplyTotal, _amount, "{name: \'COIN Project\'}");
        supplyTotal++;
    }
}
