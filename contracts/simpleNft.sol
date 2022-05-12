// SPDX-License-Identifier: MIT
pragma solidity 0.8.13;
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract simpleNft is ERC721{
 uint private _tokenId;
  string baseUri;
 constructor(string memory _symbol, string memory _name, string memory _baseUri)ERC721(_symbol, _name){
   baseUri = _baseUri;
 }

 function mint()public returns(uint){
   _tokenId +=1 ; 
   _mint(msg.sender, _tokenId);
   return _tokenId;
 }

 function tokenURI(uint _tId)override public view returns(string memory){
   return string(abi.encodePacked(baseUri, "/", Strings.toString(_tId),".json"));
 }

 function setBaseUri(string memory _baseUri)external {
   baseUri = _baseUri;
 }

 function getBaseUri()external view returns(string memory){
   return baseUri;
 }
}
