var ERC1155Token = artifacts.require("./ERC1155Token.sol");
var ERC1155Factory = artifacts.require("./ERC1155Factory.sol");


module.exports = function(deployer) {
  deployer.deploy(ERC1155Token);
  deployer.deploy(ERC1155Factory);
};
