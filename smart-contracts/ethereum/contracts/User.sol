pragma solidity ^0.4.15;

import "./Republic.sol";
import "./RepublicPrimaryElection.sol";

contract User {

  address owner;
  Republic republic;
  
  function User() public {
      owner = msg.sender;
  }

  function setRepublic(Republic _republic) public payable returns (bool res) {
    require(msg.sender == owner);

    republic = _republic;

    return true;
  }

  function vote(RepublicIndustryElection _election, address _nominee) public payable returns (bool res) {
    require(msg.sender == owner);
    _election.vote(_nominee);
  }

  function registerAsNominee(RepublicIndustryElection _election) public payable returns (bool res) {
    _election.registerAsNominee();
  }
}