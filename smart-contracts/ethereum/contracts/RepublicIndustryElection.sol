pragma solidity ^0.4.15;

import "./NetworkAccessToken.sol";
import "./Republic.sol";

/**
 * The Republic Industry election contract:
 * - Allows NAT token holders to vote for delegates
 */
contract RepublicIndustryElection {
  modifier onlyDelegate() {
    require(delegates[msg.sender]);
    _;
  }

  Republic republic;

  mapping (address => bool) delegates;
  address[11] delegateAddresses;

  mapping (address => mapping (address => uint)) nominees;
  mapping (address => uint) nomineeVotes;
  
  mapping (address => uint) registeredVoters;

  address[] registeredNominees;

  string industry;
  bool started;
  
  function RepublicIndustryElection(string _industry) public {
    started = false;
    delegates[msg.sender] = true;
    industry = _industry;
  }

  // TODO: add onlyDelegate modifier
  function initRepublic(address _republic) public payable returns(bool res) {
    republic = Republic(_republic);
    delegateAddresses = republic.getDelegateAddresses();

    for(uint256 i; i < delegateAddresses.length; i++) {
      delegates[delegateAddresses[i]] = true;
    }

    return true;
  }

  function getDelegateAddresses() public view returns(address[11] res) {
    return republic.getDelegateAddresses();
  }

  function vote(address _nominee) public payable returns(bool res) {
    require(!started);

    // Sender should not be allowed to vote more than once
    require(nominees[_nominee][msg.sender] == 0);

    NetworkAccessToken token = NetworkAccessToken(msg.sender);

    nominees[_nominee][msg.sender] = token.balanceOf(msg.sender);
    
    nomineeVotes[_nominee] += token.balanceOf(msg.sender);

    return true;
  }

  function registerNominee() public payable returns(bool res) {
    bool found = false;
    uint256 foundIndex = 0;

    for(uint256 i = 0; i < registeredNominees.length; i++) {
        if (registeredNominees[i] == msg.sender) {
            found = true;
            foundIndex = i;
        }
    }

    if (found) {
        return false;
    }

    registeredNominees.push(msg.sender);

    return true;
  }

  function start() onlyDelegate public payable returns(bool res) {
    started = true;

    return true;
  }

  function end() onlyDelegate public view returns(address res) {
    
    return registeredNominees[0];
  }
}

