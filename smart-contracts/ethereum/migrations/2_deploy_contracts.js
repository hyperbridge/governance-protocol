var NetworkAccessToken = artifacts.require("./NetworkAccessToken.sol");
var Republic = artifacts.require("./Republic.sol");
var RepublicPrimaryElection = artifacts.require("./RepublicPrimaryElection.sol");
var RepublicIndustryElection = artifacts.require("./RepublicIndustryElection.sol");

module.exports = function (deployer) {
    deployer.deploy(NetworkAccessToken);
    deployer.deploy(Republic);
    deployer.deploy(RepublicPrimaryElection);
    deployer.deploy(RepublicIndustryElection);
};
