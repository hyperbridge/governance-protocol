pragma solidity ^0.4.15;

import "./RepublicVote.sol";

/**
 * The Republic contract:
 * - Stores all the information about the Hyperbridge Republic
 */
contract Republic {
  modifier onlyDelegate() {
    require(delegates[msg.sender]);
    _;
  }

  struct Delegate {
    uint version;
    string name;
    string description;
    string url;
  }

  mapping (address => bool) delegates;
  address[11] delegateAddresses;
  uint256 currentDelegateIndex;
  
  function Republic() public {
    addDelegate(msg.sender);
  }

  function addDelegate(address delegate) public payable returns(bool res) {
      delegates[delegate] = true;
      delegateAddresses[currentDelegateIndex] = delegate;
      currentDelegateIndex++;
      return true;
  }

  function getDelegateAddresses() public view returns(address[11] res) {
    return delegateAddresses;
  }

  function createVote() onlyDelegate public view returns(bool res) { // TODO: string name, uint version, string files, string checksum
    return true;
  }

  function endVote() onlyDelegate public view returns(bool res) { // TODO: uint id, bool vote
    return true;
  }
}
