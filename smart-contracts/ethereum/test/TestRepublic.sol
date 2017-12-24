pragma solidity ^0.4.2;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/Republic.sol";

contract TestRepublic {
    function setupRepublic() public payable returns (Republic res) {
        Republic republic = Republic(DeployedAddresses.Republic());

        return republic;
    }

    function setupElection(Republic _republic) public payable returns (RepublicPrimaryElection res) {
        RepublicPrimaryElection election = _republic.startElection();

        election.initRepublic(_republic);

        return election;
    }

    function setupHighTurnoutElectionVotes(RepublicPrimaryElection _election) public payable {
        address nominee1 = 0xf17f52151EbEF6C7334FAD080c5704D77216b732;
        address nominee2 = 0xC5fdf4076b8F3A5357c5E395ab970B5B54098Fef;

        address person1 = 0x821aEa9a577a9b44299B9c15c88cf3087F3b5544;
        address person2 = 0x0d1d4e623D10F9FBA5Db95830F7d3839406C6AF2;

        _election.start();

        RepublicIndustryElection[11] memory industryElections = _election.getIndustryElections();

        RepublicIndustryElection industryElection1 = industryElections[0];
        RepublicIndustryElection industryElection2 = industryElections[1];

        // TODO: Simulated voting
        industryElection1.vote(nominee1);
        industryElection1.vote(nominee2);
        industryElection2.vote(nominee1);
        industryElection2.vote(nominee2);
    }

    function setupLowTurnoutElectionVotes(RepublicPrimaryElection _election) public payable {
        address nominee1 = 0xf17f52151EbEF6C7334FAD080c5704D77216b732;
        address nominee2 = 0xC5fdf4076b8F3A5357c5E395ab970B5B54098Fef;

        address person1 = 0x821aEa9a577a9b44299B9c15c88cf3087F3b5544;
        address person2 = 0x0d1d4e623D10F9FBA5Db95830F7d3839406C6AF2;

        _election.start();

        RepublicIndustryElection[11] memory industryElections = _election.getIndustryElections();

        RepublicIndustryElection industryElection1 = industryElections[0];
        RepublicIndustryElection industryElection2 = industryElections[1];

        industryElection1.vote(nominee1);
        industryElection2.vote(nominee2);
    }

    function testInitialDelegates() public payable {
        Republic republic = setupRepublic();

        address expected = 0x627306090abaB3A6e1400e9345bC60c78a8BEf57;

        Assert.equal(republic.getDelegateAddresses()[0], expected, "Initial delegates should all be 0x627306090abaB3A6e1400e9345bC60c78a8BEf57");
    }

    function testSuccessfulElection() public payable {
        Republic republic = setupRepublic();
        RepublicPrimaryElection election = setupElection(republic);

        address[11] memory originalDelegates = republic.getDelegateAddresses();

        setupHighTurnoutElectionVotes(election);

        republic.endElection();

        address[11] memory newDelegates = republic.getDelegateAddresses();

        bool change = false;

        for(var i = 0; i < 11; i++) {
            if (newDelegates[i] != originalDelegates[i]) {
                change = true;
            }
        }

        bool expected = true;

        Assert.equal(change, expected, "Delegates should have changed in the election");
    }

    // Election runs for 2 weeks
    // Election must be manually finalized by a majority vote of delegates within 1 week or automatically cancelled
    // If successful, current delegates are replaced with elected delegates
    // If unsuccessful, a re-election is held, up to a maximum of 2 cancellations
    // Cancellation will be ignored the third time and current delegates will be replaced with elected delegates
    function testCanceledElection() public payable {
        Republic republic = setupRepublic();
        RepublicPrimaryElection election = setupElection(republic);

        address[11] memory originalDelegates = republic.getDelegateAddresses();

        setupLowTurnoutElectionVotes(election);

        republic.endElection();

        address[11] memory newDelegates = republic.getDelegateAddresses();

        bool change = false;

        for(var i = 0; i < 11; i++) {
            if (newDelegates[i] != originalDelegates[i]) {
                change = true;
            }
        }

        bool expected = false;

        Assert.equal(change, expected, "Delegates should not have changed in the election, due to low turnout");
    }

    // For now, nominees should be able to win more than a single industry
    // In the future, it may fall back to the runner up
    function testAllowDoubleDelegatesElection() public payable {
        Republic republic = setupRepublic();
        RepublicPrimaryElection election = setupElection(republic);

        address[11] memory originalDelegates = republic.getDelegateAddresses();

        setupHighTurnoutElectionVotes(election);

        republic.endElection();

        address[11] memory newDelegates = republic.getDelegateAddresses();

        bool duplicateFound = false;

        for(var i = 0; i < 11; i++) {
            for(var j = 0; j < 11; j++) {
                if (i != j && newDelegates[i] == newDelegates[j]) {
                    duplicateFound = true;
                }
            }
        }

        bool expected = true;

        Assert.equal(duplicateFound, expected, "Delegate should be allowed as leader of multiple industries");
    }
}
