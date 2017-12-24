var NetworkAccessToken = artifacts.require("./NetworkAccessToken.sol");
var Republic = artifacts.require("./Republic.sol");
var RepublicVote = artifacts.require("./RepublicVote.sol");

module.exports = function (deployer) {
    deployer.deploy(NetworkAccessToken);
    deployer.deploy(Republic);
    deployer.deploy(RepublicVote);
};
