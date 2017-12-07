var ConvertLib = artifacts.require("./ConvertLib.sol");
var NAT = artifacts.require("./NAT.sol");

module.exports = function(deployer) {
    deployer.deploy(ConvertLib);
    deployer.link(ConvertLib, NAT);
    deployer.deploy(NAT);
};
