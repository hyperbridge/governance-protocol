pragma solidity ^0.4.2;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/NetworkAccessToken.sol";

contract TestNetworkAccessToken {

    function testInitialBalanceUsingDeployedContract() public payable {
        NetworkAccessToken token = NetworkAccessToken(DeployedAddresses.NetworkAccessToken());

        uint expected = 1000000000 * 10**uint256(token.decimals());

        Assert.equal(token.balanceOf(tx.origin), expected, "Owner should have 1000000000 NAT initially");
    }

    function testInitialBalanceWithNewToken() public payable {
        NetworkAccessToken token = new NetworkAccessToken();

        uint expected = 1000000000 * 10**uint256(token.decimals());

        Assert.equal(token.balanceOf(msg.sender), expected, "Owner should have 1000000000 NAT initially");
    }

}
