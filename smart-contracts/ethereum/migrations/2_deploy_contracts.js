var ConvertLib = artifacts.require("./ConvertLib.sol");
var NetworkAccessToken = artifacts.require("./NetworkAccessToken.sol");

module.exports = function (deployer) {
    deployer.deploy(ConvertLib);
    deployer.link(ConvertLib, NetworkAccessToken);
    deployer.deploy(NetworkAccessToken);
};
