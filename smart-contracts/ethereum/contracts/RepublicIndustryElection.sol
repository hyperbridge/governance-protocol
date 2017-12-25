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
  mapping (address => bool) registeredNomineeAddresses;

  string industry;
  bool started;
  address natAddress;
  uint nomineeLimit;
  
  function RepublicIndustryElection(address _natAddress, string _industry) public {
    started = false;
    delegates[msg.sender] = true;
    natAddress = _natAddress;
    industry = _industry;
    nomineeLimit = 100;
  }

  // TODO: add onlyDelegate modifier
  function initRepublic(address _republic) public payable returns(bool res) {
    republic = Republic(_republic);
    delegateAddresses = republic.getDelegateAddresses();

    for (uint256 i; i < delegateAddresses.length; i++) {
      delegates[delegateAddresses[i]] = true;
    }

    return true;
  }

  function getDelegateAddresses() public view returns(address[11] res) {
    return republic.getDelegateAddresses();
  }

  function vote(address _nominee) public payable returns(bool res) {
    require(started);

    // Sender should not be allowed to vote more than once
    require(nominees[_nominee][msg.sender] == 0);
    require(registeredNomineeAddresses[_nominee]);

    NetworkAccessToken token = NetworkAccessToken(natAddress);
    uint256 balance = token.balanceOf(msg.sender);

    nominees[_nominee][msg.sender] = balance;
    nomineeVotes[_nominee] += balance;

    return true;
  }

  function setNomineeLimit(uint _limit) public payable returns(bool res) {
      nomineeLimit = _limit;

      return true;
  }

  function registerAsNominee() public payable returns(bool res) {
    require (registeredNominees.length < nomineeLimit);

    bool found = false;
    uint256 foundIndex = 0;

    for (uint256 i = 0; i < registeredNominees.length; i++) {
        if (registeredNominees[i] == msg.sender) {
            found = true;
            foundIndex = i;
        }
    }

    if (found) {
        return false;
    }

    registeredNominees.push(msg.sender);
    registeredNomineeAddresses[msg.sender] = true;

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

