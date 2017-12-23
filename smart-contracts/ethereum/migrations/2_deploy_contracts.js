var NetworkAccessToken = artifacts.require("./NetworkAccessToken.sol");

module.exports = function (deployer) {
    deployer.deploy(NetworkAccessToken);
};
