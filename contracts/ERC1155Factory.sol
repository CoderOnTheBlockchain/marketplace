// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.13;

import "./ERC1155Token.sol";

contract ERC1155Factory {

    event ERC1155Created(address owner, address tokenContract);

    function deployCollection(string memory _uri) public returns (address) {
        ERC1155Token tokenContract = new ERC1155Token(_uri);
        
        emit ERC1155Created(msg.sender, address(tokenContract));
        
        return address(tokenContract);
    }
}
