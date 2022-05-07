var ERC155Token = artifacts.require("ERC155Token");

module.exports = function(deployer){
  deployer.deploy(ERC155Token);
}
