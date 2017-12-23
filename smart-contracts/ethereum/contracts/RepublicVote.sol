pragma solidity ^0.4.15;

import "./NetworkAccessToken.sol";
import "./Republic.sol";

/**
 * The Republic voting contract:
 * - Allows NAT token holders to vote for delegates
 */
contract RepublicVote {
  modifier onlyDelegate() {
    bool exists = false;

    for(uint i = 0; i < delegates.length; ++i) {
        if (delegates[i] == msg.sender) {
            exists = true;
        }
    }

    require(exists);
    _;
  }

  Republic republic;
  address[11] public delegates;
  mapping (address => mapping (address => uint)) public nominees;
  mapping (address => uint) public voters;
  
  function RepublicVote() public {
    for(uint i = 0; i < delegates.length; ++i) {
        delegates[i] = msg.sender;
    }
  }

  // TODO: add onlyDelegate modifier
  function initRepublic(address _republic) public payable returns(bool res) {
    republic = Republic(_republic);
    delegates = republic.getDelegates();
    return true;
  }

  function getDelegates() public view returns(address[11] res) {
    return delegates;
  }

  function register() public payable returns(bool res) {
    NetworkAccessToken token = NetworkAccessToken(msg.sender);
    voters[msg.sender] = token.balanceOf(msg.sender);
    return true;
  }

  function vote(address nominee) public payable returns(bool res) {
    nominees[nominee][msg.sender] = voters[msg.sender];
    return true;
  }

  function tally() onlyDelegate public view returns(bool res) {
    return true;
  }
}

