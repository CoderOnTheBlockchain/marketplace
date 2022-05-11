// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.13;

import "./ERC1155Token.sol";

contract ERC1155Factory {

    uint public collectionCount = 0; 
    event ERC1155Created(address ownerAddress, address contractAddress);

    struct Collection {
        uint id;
        string name;
        string artistName;
        ERC1155Token tokenContract;
        string description;
        string mediaHash;
        string coverHash;
        address owner;
    }

    mapping(address => Collection) collections;
    
    event CollectionCreated(
        uint id,
        string name,
        string artistName,
        ERC1155Token tokenContract,
        string description,
        string mediaHash,
        string coverHash,
        address owner
    );

    function deployCollection(
        string memory _collectionName,
        string memory _artistName,
        string memory _description,
        string memory _uri,
        string memory _mediaHash,
        string memory _coverHash,
        uint256 _supplyMax
        ) 
        public returns (address) {
 
        require(bytes(_collectionName).length > 0);

        // Update counter
        collectionCount ++;

        ERC1155Token tokenContract = new ERC1155Token(_uri);
        tokenContract.setSupplyMax(_supplyMax);
        address addressContract = address(tokenContract);
        
        collections[addressContract].name = _collectionName;
        collections[addressContract].artistName = _artistName;
        collections[addressContract].tokenContract = tokenContract;
        
        collections[addressContract].description = _description;
        collections[addressContract].mediaHash = _mediaHash;
        collections[addressContract].coverHash = _coverHash;
        collections[addressContract].owner = msg.sender;
   
        emit ERC1155Created(msg.sender, address(tokenContract));
        // Trigger an event (Similar to return)
        emit CollectionCreated(collectionCount, _collectionName,_artistName,tokenContract, _description, _mediaHash,_coverHash, msg.sender);
        
        return address(tokenContract);
    }

    function getCollection(address _addr) external view returns(Collection memory) {
        return collections[_addr];
    }
}
