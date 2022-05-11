// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "./AuctionOrSale.sol";

contract SellingFactory{
    address[] allSales;
    address[] allAuctions;

    event NewSale(address indexed _contract, address _seller);
    event NewAuction(address indexed _contract, address _seller);

    event Debug(address _addr);
    //set _auctionTime to 0 for a sale
    function newSaleOrAuction(address _nft, uint _nftId, uint _price, uint32 _auctionTime)external{
        if(_auctionTime == 0){
            AuctionOrSale _contract = new AuctionOrSale(_nft, _nftId, _price, 0, payable(msg.sender));
            allSales.push(address(_contract));
            emit NewSale(address(_contract), msg.sender);
        }
        else{
            AuctionOrSale _contract = new AuctionOrSale(_nft, _nftId, _price, _auctionTime, payable(msg.sender));
            allAuctions.push(address(_contract));
            emit NewAuction(address(_contract), msg.sender);
        }
    }
}