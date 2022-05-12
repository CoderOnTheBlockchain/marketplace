// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.13;
///@author Adam

import "./simpleNft.sol";
contract Storage{
    event NewCollectionStored();
    ///@custom:collections pas besoin de getter du coup je l'ai mise en public
    Collection[] public collections;
    struct Collection {
        uint id;
        string name;
        string artistName;
        simpleNft tokenContract;
        string description;
        address owner;
    }

    /**
    *@notice add a collection to the storage
    *@param _contractAddress est l'addresse de la collection qu'on veut ajouter
    *@dev le premier require est pour quand même s'assurer qu'on se fasse pas dos
    //même si Cyril nous a dit que ça poserait pas de soucis, (un peu fait à l'arrache ça serait bien qu'on le modifie)
    */
    function addCollection(
        uint _id,
        string memory _name,
        string memory _artistName,
        simpleNft _contractAddress,
        string memory _description,
        address _owner
    )external{
        require(collections.length <= 3 gwei, "dos risk, contact admin");
        simpleNft token = simpleNft(_contractAddress);
        Collection memory tmp = Collection(_id,_name,_artistName,token,_description,_owner);
        collections.push(tmp);
    }

    /**
    *@return tableau de toutes les collections dont @param:_addr possede des nfts
    */
    function getCollectionsOf(address _addr)external view returns(Collection [] memory){
        uint i;
        Collection [] memory tmp;
        for (uint256 index = 0; index < collections.length; index++) {
            if(collections[index].tokenContract.balanceOf(_addr) > 0){
                tmp[i] = collections[index];
                i ++;
            }
        }
        return tmp;
    }
}

