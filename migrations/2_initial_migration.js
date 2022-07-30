var ERC20Basic = artifacts.require("./ERC20Basic.sol");
var Election = artifacts.require("./Election.sol");
var ERC721Basic = artifacts.require("./ERC721Basic.sol");

// Deploy the ERC20Basic, ERC721Basic and Election contracts
module.exports = function(deployer) {
  deployer.deploy(ERC20Basic).then(function(){
    return deployer.deploy(ERC721Basic)
}).then(function(){
        // The election contract recieves the ERC20Basic and ERC721Basic addresses, in order to use their functions
        return deployer.deploy(Election, ERC20Basic.address, ERC721Basic.address)
});
};
