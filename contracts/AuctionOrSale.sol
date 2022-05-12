// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;
///@author Adam

interface IERC721{
    function safeTransferFrom(
        address from,
        address to,
        uint tokenId
    ) external;

    function transferFrom(
        address,
        address,
        uint
    ) external;
}

contract AuctionOrSale {
    event Start(address seller, uint amount);
    event Sell(address indexed sender, uint amount);
    event Bought(address indexed buyer, uint amount);
    event Bid(address indexed sender, uint amount);
    event Withdraw(address indexed bidder, uint amount);
    event End(address winner, uint amount);

    event Debug(address _addr);

    IERC721 public nft;
    uint public nftId;

    address payable public seller;//both
    uint public endAt;//auction
    bool public started;//sale
    bool public auctionStarted;//auction
    bool public ended;//auction
    uint32 public auctionTime;//auction
    address public highestBidder;//auction
    uint public highestBid;//both
    mapping(address => uint) public bids;//auction

    ///@param _auctionTime si il est à zero c'est un contrat de vente, sinon auction
    ///@param _nft est l'addresse de la collection nft
    ///@param _price va venir set highestBit
    constructor(
        address _nft,
        uint _nftId,
        uint _price,
        uint32 _auctionTime, //in seconds
        address _seller
    ) {
        nft = IERC721(_nft);
        nftId = _nftId;
        auctionTime = _auctionTime;
        seller = payable(_seller);
        highestBid = _price;
    }
    /**
    *@notice Commence l'auction et transfere le nft sur le contrat, il faut approuver avant
    */
    function start() external {
        require(!auctionStarted, "started");
        //have to approve contract first
        nft.transferFrom(seller, address(this), nftId);
        auctionStarted = true;
        endAt = block.timestamp + uint(auctionTime);
        emit Start(seller, highestBid);
    }

    /**
    *@notice encherir
    */
    function bid() external payable {
        require(auctionStarted, "not started");
        require(block.timestamp < endAt, "ended");
        require(msg.value > highestBid, "value < highest");

        if (highestBidder != address(0)) {
            bids[highestBidder] += highestBid;
        }

        highestBidder = msg.sender;
        highestBid = msg.value;

        emit Bid(msg.sender, msg.value);
    }

    /**
    *@notice permet de retirer les fonds encheris
    */
    function withdrawAuction() external {
        uint bal = bids[msg.sender];
        bids[msg.sender] = 0;
        payable(msg.sender).transfer(bal);

        emit Withdraw(msg.sender, bal);
    }

    /**
    *@notice met fin à l'auction si le temps est écoulé, transfere le nft au gagnant de la vente
    *@dev c'est cette fonction que j'arrive pas à tester 
    */
    function end() external {
        require(auctionStarted, "not started");
        require(block.timestamp >= endAt, "not ended");
        require(!ended, "ended");

        ended = true;
        if (highestBidder != address(0)) {
            nft.safeTransferFrom(address(this), highestBidder, nftId);
            seller.transfer(highestBid);
        } else {
            nft.safeTransferFrom(address(this), seller, nftId);
        }

        emit End(highestBidder, highestBid);
    }


    //::::::::::::::::::Sale::::::::::::::::://

    /**
    *@notice commence la vente, transfere le nft au contrat, necessite d'être approuvé avant
    */
    function sell()external{
        require(!started, "create another sale please");
        //have to approve first
        nft.transferFrom(seller, address(this), nftId);
        started = true;
        emit Sell(seller, highestBid);
    }

    /**
    *@notice permet d'acheter le nft
    */
    function buy()external payable{
        require(started, "not started");
        require(msg.value >= highestBid);
        bool sent = payable(address(this)).send(highestBid);
        require(sent, "failure to send eth");
        nft.transferFrom(address(this), msg.sender, nftId);
        started = false;
        emit Bought(msg.sender, highestBid);
    }

    /**
    *@notice permet de retirer les fonds pour le vendeur
    */
    function withdraw()external payable{
        bool tmp;
        require(tmp == false, 'reentrancy detected');
        tmp = false;
        payable(msg.sender).transfer(highestBid);
        emit Withdraw(msg.sender, highestBid);
    } 

    /**
    *@dev renvoie la balance du contrat
    */
    function getBalance()external view returns(uint){
        return address(this).balance;
    }

    /**
    *@dev renvoie la balance du contrat
    */
    function getCurrentTimeStamp()external view returns(uint){
        return block.timestamp;
    }

    receive()external payable{}
}
