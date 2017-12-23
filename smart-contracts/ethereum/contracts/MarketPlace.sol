pragma solidity ^0.4.15;

/**
 * The MarketPlace contract:
 * - stores all the information about hyperbridge apps
 */
contract Marketplace {
  modifier onlyOperator() {
    require(operators[msg.sender]);
    _;
  }

  struct appVersion {
    uint version;
    string files;
    string category;
    string status;
    string checksum;
    uint required_permissions;
  }

  struct App {
    uint id;
    address owner;
    string name;
    appVersion[] versions;
  }
  
  mapping (uint => App) apps;
  mapping (address => bool) operators;
  
  function Marketplace() public {
    
  }

  function submitAppForReview() public pure returns(bool res) { // TODO: string name, uint version, string files, string checksum
    return true;
  }

  function vote() onlyOperator public view returns(bool res) { // TODO: uint id, bool vote
    return true;
  }
}
