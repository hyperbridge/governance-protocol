pragma solidity ^0.4.15;

import "./RepublicVote.sol";

/**
 * The Republic contract:
 * - Stores all the information about the Hyperbridge Republic
 */
contract Republic {
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

  struct Delegate {
    uint version;
    string name;
    string description;
    string url;
  }

  address[11] delegates;
  
  function Republic() public {
    for(uint i = 0; i < delegates.length; ++i) {
        delegates[i] = msg.sender;
    }
  }

  function getDelegates() public view returns(address[11] res) {
    return delegates;
  }

  function createVote() onlyDelegate public view returns(bool res) { // TODO: string name, uint version, string files, string checksum
    return true;
  }

  function endVote() onlyDelegate public view returns(bool res) { // TODO: uint id, bool vote
    return true;
  }
}
