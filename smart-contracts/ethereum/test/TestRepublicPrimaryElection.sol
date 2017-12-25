pragma solidity ^0.4.2;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/User.sol";
import "../contracts/RepublicPrimaryElection.sol";
import "../contracts/RepublicIndustryElection.sol";

contract TestRepublicPrimaryElection {

    function testInitialDelegates() public payable {
        Republic republic = Republic(DeployedAddresses.Republic());
        RepublicPrimaryElection election = republic.startElection();

        election.initRepublic(republic);

        address expected = republic.getDelegateAddresses()[0];

        Assert.equal(election.getDelegateAddresses()[0], expected, "Initial delegates should match Republic");
    }

    // Election should have a minimum of 50% voter turnout
    function testTallyWithSuccessfulVoterTurnout() public payable {
        Republic republic = Republic(DeployedAddresses.Republic());
        RepublicPrimaryElection election = republic.startElection();

        election.initRepublic(republic);
        election.start();

        RepublicIndustryElection[11] memory industryElections = election.getIndustryElections();

        address nominee1 = 0xf17f52151EbEF6C7334FAD080c5704D77216b732;
        industryElections[0].vote(nominee1);

        address nominee2 = 0xf17f52151EbEF6C7334FAD080c5704D77216b732;
        industryElections[0].vote(nominee2);

        uint256 res = election.tallyVotes();

        Assert.equal(res, 12, "Election should succeed with high voter turnout");
    }

    // Election should have a minimum of 50% voter turnout
    function testTallyWithLowVoterTurnout() public payable {
        Republic republic = Republic(DeployedAddresses.Republic());
        RepublicPrimaryElection primaryElection = republic.startElection();

        primaryElection.initRepublic(republic);
        primaryElection.start();

        RepublicIndustryElection[11] memory industryElections = primaryElection.getIndustryElections();

        address nominee1 = 0xf17f52151EbEF6C7334FAD080c5704D77216b732;
        industryElections[0].vote(nominee1);

        uint256 res = primaryElection.tallyVotes();

        Assert.equal(res, 12, "Election should fail with low voter turnout");
    }

    // Nominees should be limited to 100
    function testNomineeLimit() public payable {
        Republic republic = Republic(DeployedAddresses.Republic());
        RepublicPrimaryElection primaryElection = republic.startElection();

        primaryElection.initRepublic(republic);
        primaryElection.start();

        RepublicIndustryElection[11] memory industryElections = primaryElection.getIndustryElections();
        RepublicIndustryElection industryElection = industryElections[0];

        address nominee = 0xf17f52151EbEF6C7334FAD080c5704D77216b732;

        for (uint256 i = 10; i < 99; i++) {
            User user = new User();
            user.setRepublic(republic);
            user.vote(industryElection, nominee);
        }

        bool voteResult = industryElection.vote(nominee);

        Assert.equal(voteResult, false, "Vote should fail when nominating more than 100");
    }

}
