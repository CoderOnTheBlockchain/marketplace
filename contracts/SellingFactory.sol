// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;
///@author Adam

import "./AuctionOrSale.sol";

contract SellingFactory{
    ///@dev il faudrait créer une fonction qui nettoie les tableaux et qui se lance à chaque création de auctionOrSale
    address[] allSales; //stockage des collections en vente directe
    address[] allAuctions;//stockage des collections aux encheres


    event NewSale(address indexed _contract, address _seller);
    event NewAuction(address indexed _contract, address _seller);

    event Debug(address _addr);
    /**
    *@dev impossible de faire 2 contrats à cause du problème d'interface
    *@notice crée un nouveau contrat de vente ou d'auction pour un nft
    *@param _nft est l'addresse de la collection du nft
    *@param _nftId est l'id du nft
    *@param _price est le prix de vente dans le cas d'une sale, et le prix de départ pour une auction
    *@param _auctionTime est le temps que doit durer l'enchere. Si il est à zero la fonction crée une vente, sinon une auction 
    */
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
