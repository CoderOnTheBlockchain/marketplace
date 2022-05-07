var ERC1155Factory = artifacts.require("./ERC1155Factory.sol");

module.exports = function(deployer) {
  deployer.deploy(ERC1155Factory);
};
