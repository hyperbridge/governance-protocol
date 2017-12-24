pragma solidity ^0.4.15;

import "./NetworkAccessToken.sol";
import "./Republic.sol";

/**
 * The Republic voting contract:
 * - Allows NAT token holders to vote for delegates
 */
contract RepublicVote {
  modifier onlyDelegate() {
    require(delegates[msg.sender]);
    _;
  }

  Republic republic;
  mapping (address => bool) delegates;
  address[11] delegateAddresses;
  mapping (address => mapping (address => uint)) nominees;
  mapping (address => uint) voters;
  
  function RepublicVote() public {
    delegates[msg.sender] = true;
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

  function registerVoter() public payable returns(bool res) {
    NetworkAccessToken token = NetworkAccessToken(msg.sender);
    voters[msg.sender] = token.balanceOf(msg.sender);
    return true;
  }

  function startVote(address nominee) public payable returns(bool res) {
    nominees[nominee][msg.sender] = voters[msg.sender];
    return true;
  }

  function tallyVote() onlyDelegate public view returns(bool res) {
    return true;
  }
}

