const ERC1155Token = artifacts.require("./ERC1155Token.sol");
const { BN, expectRevert, expectEvent } = require('@openzeppelin/test-helpers');
const { expect } = require('chai');

contract("ERC1155Token", accounts => {
    const owner = accounts[0];
    let ERC1155TokenInstance;

    describe("Test ERC1155Token smart contract to marketplace project", function () {
    
        beforeEach(async () => {
            ERC1155TokenInstance = await ERC1155Token.new({from:owner});
            await ERC1155TokenInstance.inititialize('https://myuri', 10000, {from:owner});
        });
        
        it('Inititialize token data', async function () {
            let supplyMax = await ERC1155TokenInstance.getSupplyMax({from:owner});
            let tokenIdURI = await ERC1155TokenInstance.getTokenIdURI(120, {from:owner});
            let supplyTotal = await ERC1155TokenInstance.getSupplyTotal({from:owner});
            
            expect(new BN(supplyTotal)).to.be.bignumber.equal(new BN(0));
            expect(new BN(supplyMax)).to.be.bignumber.equal(new BN(10000));
            expect(tokenIdURI).to.be.equal('https://myuri/120.json');
        });

        
    });
});
