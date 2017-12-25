pragma solidity ^0.4.2;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";

import "./ThrowProxy.sol";
import "../contracts/User.sol";
import "../contracts/RepublicIndustryElection.sol";

contract TestRepublicIndustryElection {

    function testVote() public payable {
        RepublicIndustryElection election = new RepublicIndustryElection(DeployedAddresses.NetworkAccessToken(), "AI & IoT");

        election.start();

        User nominee = new User();
        address nomineeAddress = address(nominee);

        nominee.registerAsNominee(election);

        bool res = election.vote(nomineeAddress);

        Assert.equal(res, true, "First vote should be counted");
    }

    // function testDoubleVote() public payable {
    //     RepublicIndustryElection election = new RepublicIndustryElection(DeployedAddresses.NetworkAccessToken(), "AI & IoT");

    //     election.start();

    //     address nominee = 0xf17f52151EbEF6C7334FAD080c5704D77216b732;
    //     election.vote(nominee);

    //     bool res = election.vote(nominee);

    //     Assert.equal(res, false, "Re-votes should not be counted");
    // }

    function testElectionNotStarted() public payable {
        RepublicIndustryElection election = new RepublicIndustryElection(DeployedAddresses.NetworkAccessToken(), "AI & IoT");

        // Election not started

        User nominee = new User();
        address nomineeAddress = address(nominee);

        nominee.registerAsNominee(election);

        ThrowProxy throwProxy = new ThrowProxy(address(election));

        RepublicIndustryElection(address(throwProxy)).vote(nomineeAddress);
        bool voteResult = throwProxy.execute.gas(200000)();

        Assert.equal(voteResult, false, "Vote should fail since election has not started");
    }

    function testElectionStarted() public payable {
        RepublicIndustryElection election = new RepublicIndustryElection(DeployedAddresses.NetworkAccessToken(), "AI & IoT");

        election.start();

        User nominee = new User();
        address nomineeAddress = address(nominee);

        nominee.registerAsNominee(election);

        bool voteResult = election.vote(nomineeAddress);

        Assert.equal(voteResult, true, "Vote should succeed since election has started");
    }
    
    // Nominees should be limited to 100
    function testNomineeLimit() public payable {
        RepublicIndustryElection election = new RepublicIndustryElection(DeployedAddresses.NetworkAccessToken(), "AI & IoT");

        uint limit = 10;

        election.start();
        election.setNomineeLimit(limit);

        for (uint i = 0; i < limit; i++) {
            User u = new User();
            u.registerAsNominee(election);
        }

        User user = new User();
        
        ThrowProxy throwProxy = new ThrowProxy(address(user));

        User(address(throwProxy)).registerAsNominee(election);
        bool res = throwProxy.execute.gas(200000)();

        Assert.equal(res, false, "Nominee limit should be enforced");
    }

}
