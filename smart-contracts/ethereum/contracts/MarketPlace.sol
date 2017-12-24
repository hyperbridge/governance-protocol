pragma solidity >=0.4.19;

contract MarketPlace {

  modifier onlyOperator() {
    require(operators[msg.sender]);
    _;
  }

  struct AppVersion {
    uint version;
    string files;
    string status;
    string checksum;
    uint required_permissions;
  }
  

  struct App {
    uint id;
    address owner;
    string name;
    string category;
    mapping  (uint => AppVersion)  versions;
  }
  
  mapping (uint => App) apps;
  uint[] app_ids;
  mapping (address => bool) operators;
  
  
  function MarketPlace() public {
    
  }


  function submitAppForReview(string _name, uint _version, string _category, string _files, string _checksum, uint _required_permissions) public returns(bool res) {
    uint new_id = app_ids.length;
    app_ids.push(new_id);
    apps[new_id] = App(new_id, msg.sender, _name, _category);
    submitVersionForReview(new_id, _version, _files, _checksum, _required_permissions);

    return true;
  }

  function submitVersionForReview(uint _id, uint _version, string _files, string _checksum, uint _required_permissions) public returns(bool res) {
    require(apps[_id].id == _id);
    require(apps[_id].versions[_version].version != _version);

    apps[_id].versions[_version] = AppVersion(_version, _files, "pending", _checksum, _required_permissions);
    return true;
  }
  


  function vote() view public onlyOperator returns(bool res) {
    return true;
  }
  
  function getApp(uint _id, uint _version) public view returns(address owner, string name, string category, string files, string status, string checksum) {
    require (apps[_id].id == _id && apps[_id].versions[_version].version == _version);

    return (apps[_id].owner, apps[_id].name, apps[_id].category, apps[_id].versions[_version].files, apps[_id].versions[_version].status, apps[_id].versions[_version].checksum);
  }

}