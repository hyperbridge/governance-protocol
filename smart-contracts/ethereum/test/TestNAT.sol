pragma solidity ^0.4.2;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/NAT.sol";

contract TestNAT {

    function testInitialBalanceUsingDeployedContract() {
        NAT token = NAT(DeployedAddresses.NAT());

        uint expected = 10000;

        Assert.equal(token.getBalance(tx.origin), expected, "Owner should have 10000 MetaCoin initially");
    }

    function testInitialBalanceWithNewNAT() {
        NAT token = new NAT();

        uint expected = 10000;

        Assert.equal(token.getBalance(tx.origin), expected, "Owner should have 10000 MetaCoin initially");
    }

}
