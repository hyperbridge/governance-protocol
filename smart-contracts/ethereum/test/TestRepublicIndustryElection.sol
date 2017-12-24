pragma solidity ^0.4.2;

import "./strings.sol";

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/RepublicIndustryElection.sol";

contract TestRepublicIndustryElection {
    using strings for *;

    function testVote() public payable {
        Republic republic = Republic(DeployedAddresses.Republic());
        RepublicIndustryElection election = RepublicIndustryElection(DeployedAddresses.RepublicIndustryElection());

        election.initRepublic(republic);

        address nominee = 0xf17f52151EbEF6C7334FAD080c5704D77216b732;

        bool res = election.vote(nominee);

        Assert.equal(res, true, "First vote should be counted");
    }

    function testDoubleVote() public payable {
        Republic republic = Republic(DeployedAddresses.Republic());
        RepublicIndustryElection election = RepublicIndustryElection(DeployedAddresses.RepublicIndustryElection());

        election.initRepublic(republic);

        address nominee = 0xf17f52151EbEF6C7334FAD080c5704D77216b732;
        election.vote(nominee);

        bool res = election.vote(nominee);

        Assert.equal(res, false, "Re-votes should not be counted");
    }

    function testElectionNotStarted() public payable {
        Republic republic = Republic(DeployedAddresses.Republic());
        RepublicIndustryElection election = RepublicIndustryElection(DeployedAddresses.RepublicIndustryElection());

        election.initRepublic(DeployedAddresses.Republic());

        // Election not started

        address nominee = 0xf17f52151EbEF6C7334FAD080c5704D77216b732;
        bool voteResult = election.vote(nominee);

        Assert.equal(voteResult, false, "Vote should fail since election has not started");
    }

    function testElectionStarted() public payable {
        Republic republic = Republic(DeployedAddresses.Republic());
        RepublicIndustryElection election = RepublicIndustryElection(DeployedAddresses.RepublicIndustryElection());

        election.initRepublic(DeployedAddresses.Republic());
        election.start();

        address nominee = 0xf17f52151EbEF6C7334FAD080c5704D77216b732;
        bool voteResult = election.vote(nominee);

        Assert.equal(voteResult, true, "Vote should succeed since election has started");
    }
    function parseAddr(string _a) internal returns (address){
     bytes memory tmp = bytes(_a);
     uint160 iaddr = 0;
     uint160 b1;
     uint160 b2;
     for (uint i=2; i<2+2*20; i+=2){
         iaddr *= 256;
         b1 = uint160(tmp[i]);
         b2 = uint160(tmp[i+1]);
         if ((b1 >= 97)&&(b1 <= 102)) b1 -= 87;
         else if ((b1 >= 48)&&(b1 <= 57)) b1 -= 48;
         if ((b2 >= 97)&&(b2 <= 102)) b2 -= 87;
         else if ((b2 >= 48)&&(b2 <= 57)) b2 -= 48;
         iaddr += (b1*16+b2);
     }
     return address(iaddr);
    }

    function uintToBytes(uint v) constant returns (bytes32 ret) {
        if (v == 0) {
            ret = '0';
        }
        else {
            while (v > 0) {
                ret = bytes32(uint(ret) / (2 ** 8));
                ret |= bytes32(((v % 10) + 48) * 2 ** (8 * 31));
                v /= 10;
            }
        }
        return ret;
    }
    function bytes32ToString(bytes32 x) constant returns (string) {
    bytes memory bytesString = new bytes(32);
    uint charCount = 0;
    for (uint j = 0; j < 32; j++) {
        byte char = byte(bytes32(uint(x) * 2 ** (8 * j)));
        if (char != 0) {
            bytesString[charCount] = char;
            charCount++;
        }
    }
    bytes memory bytesStringTrimmed = new bytes(charCount);
    for (j = 0; j < charCount; j++) {
        bytesStringTrimmed[j] = bytesString[j];
    }
    return string(bytesStringTrimmed);
}
    
    // Nominees should be limited to 100
    function testNomineeLimit() public payable {
        Republic republic = Republic(DeployedAddresses.Republic());
        RepublicIndustryElection election = RepublicIndustryElection(DeployedAddresses.RepublicIndustryElection());

string memory bytesString = new string(32);
string memory bytesString2 = new string(2);


        election.initRepublic(DeployedAddresses.Republic());

        for(uint256 i = 10; i < 99; i++) {
            bytesString = "0xf17f52151EbEF6C7334FAD080c5704D77216b7";
            bytesString2 = bytes32ToString(uintToBytes(i));
            bytesString = bytesString.toSlice().concat(bytesString2.toSlice());
            address nominee = parseAddr(bytesString);
            election.vote(nominee);
        }

        bool voteResult = election.vote(nominee);

        Assert.equal(voteResult, false, "Vote should fail when nominating more than 100");
    }

}
