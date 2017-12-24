contract UserProfile {

  struct App {
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

  modifier onlyOwner() {
    require(msg.sender == owner);
    _;
  }
  

  modifier userOnly() { 
    require (users[msg.sender].addr != msg.sender); 
    _; 
  }

  modifier hasApp(uint _id) {
    require(users[msg.sender].apps[_id].id != _id); 
    _; 
  }

  struct Profile {
    address addr;
    string data; // json string includes all the profile data we want to store (encrypted by the user)

    mapping (uint => App) apps;  // app_address  => app_version_id
    
    mapping (string => Key) keys; // the string is the public_key (theoritically this might be replicated but technically it's very very unlikely)
  }

  mapping (address => Profile) users;
  
  address market_place;

  address owner;


  function UserProfile() public {
    owner = msg.sender;
  }


  function register (string data) public returns(bool res) {
    require (users[msg.sender].addr != msg.sender);

    users[msg.sender] = Profile({addr: msg.sender, data: data});
    return true;
  }

  function getDefaultPermissions () public pure returns(uint res) {
    return 256;
  }

  function installApp (uint _id, uint _version) public userOnly returns(bool res) {
    require(users[msg.sender].apps[_id].version != _version);

    MarketPlace market = MarketPlace(market_place);
    var (owner_addr, name, category, files, status, checksum) = market.getApp(_id, _version); // will raise unused vars warning. ignore for now

    if (status == "approved") {
        users[msg.sender].apps[_id] = App(_id, _version, true, getDefaultPermissions());
        return true;
    }

    return false;
  }

//   function removeApp () userOnly hasApp returns(bool res)  {
//     return true;
//   }

//   function disableApp () userOnly hasApp returns(bool res)  {
//     return true;
//   }

//   function changePermissions (address addr, uint perm) userOnly hasApp returns(bool res) {
//     return true;
//   }

    function setMarketPlace(address addr) public onlyOwner {
        market_place = addr;
    }
}