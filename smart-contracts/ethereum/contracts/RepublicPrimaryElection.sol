pragma solidity ^0.4.15;

import "./NetworkAccessToken.sol";
import "./Republic.sol";
import "./RepublicIndustryElection.sol";

/**
 * The Republic primary election contract:
 * - Allows NAT token holders to vote in the industry elections
 * - The winners the top 11 industries are given a seat as a delegate
 * - Delegates gain administrative power over the Hyperbridge ecosystem
 *   as well as having higher voting power than the average token holder
 */
contract RepublicPrimaryElection {
  modifier onlyDelegate() {
    require(delegates[msg.sender]);
    _;
  }

  Republic republic;
  address natAddress;

  mapping (address => bool) delegates;
  address[11] delegateAddresses;

  mapping (address => bool) industryElection;
  RepublicIndustryElection[11] industryElections;

  string[11] industries = [
    "Logistics & Supply Chain",
    "Education & Training",
    "Environmental & Transportation",
    "Agriculture & Food",
    "Medical & Healthcare",
    "AI & IoT",
    "Software & Web Technology",
    "Legal & Accounting",
    "Social & Media",
    "HR & Workforce",
    "Health & Wellness"
  ];
  
  function RepublicPrimaryElection(address _natAddress) public {
    delegates[msg.sender] = true;
    natAddress = _natAddress;

    for (uint256 i; i < industries.length; i++) {
      industryElections[i] = new RepublicIndustryElection(natAddress, industries[i]);
    }
  }

  // TODO: add onlyDelegate modifier
  function initRepublic(Republic _republic) public payable returns(bool res) {
    republic = _republic;
    delegateAddresses = republic.getDelegateAddresses();

    for (uint256 i; i < delegateAddresses.length; i++) {
      delegates[delegateAddresses[i]] = true;
    }

    return true;
  }

  function getDelegateAddresses() public view returns(address[11] res) {
    return republic.getDelegateAddresses();
  }

  function start() public payable returns(bool res) {
    for (uint256 i; i < industryElections.length; i++) {
      industryElections[i].start();
    }

    return true;
  }

  function tallyVotes() public payable returns(uint256 res) {

    return 1;
  }

  function end() onlyDelegate public view returns(address[] res) {
    address[] memory industryWinnerAddresses = new address[](11);

    // End the industry elections
    // Choose the top 11 industry winners as the delegates
    for (uint256 i; i < industryElections.length; i++) {
      address winner1 = industryElections[i].end();

      industryWinnerAddresses[i] = winner1;
    }

    for (uint256 j; j < industryElections.length; j++) {
      address winner2 = industryElections[j].end();

      industryWinnerAddresses[j] = winner2;
    }

    return industryWinnerAddresses;
  }

  function getIndustryElections() public view returns(RepublicIndustryElection[11] res) {
    return industryElections;
  }
}

