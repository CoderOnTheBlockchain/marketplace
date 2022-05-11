// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.13;
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "./ERC1155Token.sol";

contract ERC1155Factory is ReentrancyGuard {

    uint public collectionCount = 0; 
    event ERC1155Created(address ownerAddress, address contractAddress);

    struct Collection {
        uint id;
        string name;
        string artistName;
        ERC1155Token tokenContract;
        string description;
        address owner;
    }

    mapping(address => Collection) collections;
    
    event CollectionCreated(
        uint id,
        string name,
        string artistName,
        ERC1155Token tokenContract,
        string description,
        address owner
    );

    function deployCollection(
        string memory _collectionName,
        string memory _artistName,
        string memory _description,
        string memory _uri,
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
        collections[addressContract].owner = msg.sender;
   
        emit ERC1155Created(msg.sender, address(tokenContract));
        // Trigger an event (Similar to return)
        emit CollectionCreated(collectionCount, _collectionName,_artistName,tokenContract, _description, _mediaHash,_coverHash, msg.sender);
        
        return address(tokenContract);
    }
    
       uint public itemCount; 

    struct Item {
        uint itemId;
        ERC1155Token nft;
        uint tokenId;
        uint price;
        address payable seller;
        bool sold;
    }

    // itemId -> Item
    mapping(uint => Item) public items;

    event Created(
        uint itemId,
        address  nft,
        uint tokenId,
        uint price,
        address  seller
    );
    
    event Bought(
        uint itemId,
        address  nft,
        uint tokenId,
        uint price,
        address  seller,
        address  buyer
    );


    // Make item to offer on the marketplace
    function makeItem(ERC1155Token _nft, uint _tokenId, uint _price) external nonReentrant {
        require(_price > 0, "Price must be greater than zero");
        // increment itemCount
        itemCount ++;
        // transfer nft
        _nft.transferFrom(msg.sender, address(this), _tokenId);
        // add new item to items mapping
        items[itemCount] = Item (
            itemCount,
            _nft,
            _tokenId,
            _price,
            payable(msg.sender),
            false
        );
        // emit Offered event
        emit Created(
            itemCount,
            address(_nft),
            _tokenId,
            _price,
            msg.sender
        );
    }

    function purchaseItem(uint _itemId) external payable nonReentrant {
        uint _totalPrice = getTotalPrice(_itemId);
        Item storage item = items[_itemId];
        require(_itemId > 0 && _itemId <= itemCount, "item doesn't exist");
        require(msg.value >= _totalPrice, "not enough ether to cover item price and market fee");
        require(!item.sold, "item already sold");
        // pay seller and feeAccount
        item.seller.transfer(item.price);
        feeAccount.transfer(_totalPrice - item.price);
        // update item to sold
        item.sold = true;
        // transfer nft to buyer
        item.nft.transferFrom(address(this), msg.sender, item.tokenId);
        // emit Bought event
        emit Bought(
            _itemId,
            address(item.nft),
            item.tokenId,
            item.price,
            item.seller,
            msg.sender
        );
    } 
    

    function getCollection(address _addr) external view returns(Collection memory) {
        return collections[_addr];
    }
}
