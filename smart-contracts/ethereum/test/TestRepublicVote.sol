pragma solidity ^0.4.2;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/RepublicVote.sol";

contract TestRepublicVote {

    function testInitialDelegates() public payable {
        Republic republic = Republic(DeployedAddresses.Republic());
        RepublicVote vote = RepublicVote(DeployedAddresses.RepublicVote());

        vote.initRepublic(DeployedAddresses.Republic());

        address expected = republic.getDelegateAddresses()[0];

        Assert.equal(vote.getDelegateAddresses()[0], expected, "Initial delegates should match Republic");
    }

}
