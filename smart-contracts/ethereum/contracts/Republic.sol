pragma solidity ^0.4.15;

import "./RepublicPrimaryElection.sol";

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

  address natAddress;

  mapping (address => bool) delegates;
  address[11] delegateAddresses;
  uint256 currentDelegateIndex;

  mapping (address => bool) elections;
  address[] electionAddresses;
  uint256 currentElectionIndex;

  function Republic(address _natAddress) public {
    addDelegate(msg.sender);
    natAddress = _natAddress;
  }

  function addDelegate(address _delegate) public payable returns(bool res) {
    delegates[_delegate] = true;
    delegateAddresses[currentDelegateIndex] = _delegate;
    currentDelegateIndex++;
    
    return true;
  }

  function getDelegateAddresses() public view returns(address[11] res) {
    return delegateAddresses;
  }

  function startElection() onlyDelegate public view returns(RepublicPrimaryElection res) {
    RepublicPrimaryElection election = new RepublicPrimaryElection(natAddress);

    electionAddresses.push(election);
    currentElectionIndex = electionAddresses.length - 1;
    elections[election] = true;

    election.start();
    
    return election;
  }

  function endElection() onlyDelegate public view returns(bool res) {
    RepublicPrimaryElection currentElection = RepublicPrimaryElection(electionAddresses[currentElectionIndex]);

    uint256 electionResult = currentElection.tallyVotes();

    if (electionResult == 1) {
        // Successful election

    } else {
        // Log unsuccessful election reason

    }

    return true;
  }
}
