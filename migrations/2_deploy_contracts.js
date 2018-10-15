var TestToken = artifacts.require("./TestToken.sol");
var fetchPrice = artifacts.require("./fetchPrice.sol");
var TestTokenSale = artifacts.require("./TestTokenSale.sol");

module.exports = function(deployer) {

  return deployer
  .then(() => {
    return deployer.deploy(TestToken, 10000);
  })
  .then(() => {
    return deployer.deploy(fetchPrice);
  })
  .then(() => {
    return deployer.deploy(TestTokenSale, TestToken.address);
  });
    
};
