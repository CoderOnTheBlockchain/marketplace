// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

interface IERC721 {
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
    event Start();
    event Sell(address indexed sender, uint amount);
    event Bought(address indexed buyer, uint amount);
    event Bid(address indexed sender, uint amount);
    event Withdraw(address indexed bidder, uint amount);
    event End(address winner, uint amount);

    event Debug(address _addr);

    IERC721 public nft;
    uint public nftId;

    address payable public seller;
    uint public endAt;
    bool public started;
    bool public auctionStarted;
    bool public ended;
    uint32 public auctionTime;
    address public highestBidder;
    uint public highestBid;
    mapping(address => uint) public bids;

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

    function start() external {
        require(!auctionStarted, "started");
        //have to approve contract first
        nft.transferFrom(seller, address(this), nftId);
        auctionStarted = true;
        endAt = block.timestamp + uint(auctionTime);
        emit Start();
    }

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

    function withdrawAuction() external {
        uint bal = bids[msg.sender];
        bids[msg.sender] = 0;
        payable(msg.sender).transfer(bal);

        emit Withdraw(msg.sender, bal);
    }

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

    function sell()external{
        require(!started, "create another sale please");
        //have to approve first
        nft.transferFrom(seller, address(this), nftId);
        started = true;
        emit Sell(seller, highestBid);
    }

    function buy()external payable{
        require(started, "not started");
        bool sent = payable(address(this)).send(highestBid);
        require(sent, "failure to send eth");
        nft.transferFrom(address(this), msg.sender, nftId);
        started = false;
        emit Bought(msg.sender, highestBid);
    }

    function withdraw()external payable{
        payable(msg.sender).transfer(highestBid);
        emit Withdraw(msg.sender, highestBid);
    } 

    function getBalance()external view returns(uint){
        return address(this).balance;
    }

    receive()external payable{}
}