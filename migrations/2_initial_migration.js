var ERC20Basic = artifacts.require("./ERC20Basic.sol");
var Election = artifacts.require("./Election.sol");
var ERC721Basic = artifacts.require("./ERC721Basic.sol");

// module.exports = function(deployer) {
//   //Deploy first contract
//   deployer.deploy(ERC20Basic);

//   //Get the first contract owner address
//   const accounts = await web3.eth.getAccounts();
//   const owner = accounts[0];

//   //Deploy second contract
//   deployer.deploy(Election, owner)

// };

// module.exports = async function(deployer) {
// 	// deploy MyERC20 and store return value
// 	let erc20 = await deployer.deploy(ERC20Basic);

//   	// deploy the Exchange and pass erc20
// 	deployer.deploy(Election, erc20);
// };

module.exports = function(deployer) {
  deployer.deploy(ERC20Basic).then(function(){
    return deployer.deploy(ERC721Basic)
}).then(function(){
        return deployer.deploy(Election, ERC20Basic.address, ERC721Basic.address)
});
};

// module.exports = function(deployer) {
// 	deployer.deploy(ERC20Basic);
// 	deployer.deploy(Election);
// };