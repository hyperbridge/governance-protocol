pragma solidity >=0.4.19;




/**
 * The userProfile contract:
 * - Verify users
 * - access list of the installed apps
 * - data refs
 */


contract UserProfile {

  struct appDetails {
    uint id; // redundant but usefull to include
    uint version;
    bool enabled;
    uint permissions; // bitmap for effeciency ;)
  }

  struct Key {
    string public_key; // it can be any blockchain address 
    string private_key;
    string name;
    string chain_symbol; // will leave this for the extension to use it as a reference
  }


  struct Profile {
    address addr;
    string data; // json string includes all the profile data we want to store (encrypted by the user)

    mapping (uint => appDetails) apps;  // app_address  => app_version_id
    
    mapping (string => Key) keys; // the string is the public_key (theoritically this might be replicated but technically it's very very unlikely)
  }

  mapping (address => Profile) users;
  

  function UserProfile () {
    
  }

  function register (string data) returns(bool res) {
    require (users[msg.sender].addr == msg.sender);


    users[msg.sender] = Profile({addr: msg.sender, data: data});
    return true;
  }
  

  function getDefaultPermissions () returns(uint res) {
    return 256;
  }
  

  function installApp (uint id, uint version) returns(bool res) {
    return true;
  }

  function removeApp () returns(bool res) {
    return true;
  }

  function disableApp () returns(bool res) {
    return true;
  }

  function changePermissions (address addr, uint perm) returns(bool res) {
    return true;
  }
  
}
