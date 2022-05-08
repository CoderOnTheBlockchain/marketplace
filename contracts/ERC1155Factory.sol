// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.13;

import "./ERC1155Token.sol";

contract ERC1155Factory {

    event ERC1155Created(address ownerAddress, address contractAddress);

    struct Collection {
        string name;
        string artistName;
        ERC1155Token tokenContract;
    }

    mapping(address => Collection) collections;

    function deployCollection(
        string memory _collectionName,
        string memory _artistName,
        string memory _uri,
        uint256 _supplyMax
        ) 
        public returns (address) {

        ERC1155Token tokenContract = new ERC1155Token();
        tokenContract.inititialize(_uri, _supplyMax);
        address addressContract = address(tokenContract);
        
        collections[addressContract].name = _collectionName;
        collections[addressContract].artistName = _artistName;
        collections[addressContract].tokenContract = tokenContract;
        
        emit ERC1155Created(msg.sender, address(tokenContract));
        
        return address(tokenContract);
    }

    function getCollection(address _addr) external view returns(Collection memory) {
        return collections[_addr];
    }
}
