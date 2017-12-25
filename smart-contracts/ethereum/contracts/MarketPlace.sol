pragma solidity >=0.4.15;

contract MarketPlace {

  modifier onlyOperator() {
    require(operators[msg.sender]);
    _;
  }

  struct AppVersion {
    bytes32 version;
    string files;
    bytes16 status;
    string checksum;
    uint required_permissions;
  }
  

  struct App {
    uint id;
    address owner;
    string name;
    string category;
    mapping  (bytes32 => AppVersion)  versions;
    bytes32[] version_list;
  }
  
  mapping (uint => App) apps;
  uint[] app_ids;
  mapping (address => bool) operators;
  
  event AppSubmitted(uint id);
  event VersionSubmitted(uint app_id, bytes32 version);
  
  function MarketPlace() public {
    
  }


  function submitAppForReview(string _name, bytes32 _version, string _category, string _files, string _checksum, uint _required_permissions) public returns(bool res) {
    uint new_id = app_ids.length;
    app_ids.push(new_id);
    bytes32[] memory ver_list;
    apps[new_id] = App(new_id, msg.sender, _name, _category, ver_list);
    AppSubmitted(new_id);
    submitVersionForReview(new_id, _version, _files, _checksum, _required_permissions);

    return true;
  }

  function submitVersionForReview(uint _id, bytes32 _version, string _files, string _checksum, uint _required_permissions) public returns(bool res) {
    require(apps[_id].id == _id);
    require(apps[_id].versions[_version].version != _version);


    apps[_id].versions[_version] = AppVersion(_version, _files, "approved", _checksum, _required_permissions); // approved by default for now (just for testing)
    apps[_id].version_list.push(_version);
    VersionSubmitted(_id, _version);

    return true;
  }
  


  function vote() view public onlyOperator returns(bool res) {
    return true;
  }
  
  function getApp(uint _id, bytes32 _version) public view returns(address owner, string name, string category, string files, bytes16 status, string checksum) {
    require (apps[_id].id == _id && apps[_id].versions[_version].version == _version);

    return (apps[_id].owner, apps[_id].name, apps[_id].category, apps[_id].versions[_version].files, apps[_id].versions[_version].status, apps[_id].versions[_version].checksum);
  }
}