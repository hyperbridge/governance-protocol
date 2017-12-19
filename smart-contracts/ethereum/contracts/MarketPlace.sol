pragma solidity >=0.4.19;


/**
 * The MarketPlace contract:
 * - stores all the information about hyperbridge apps
 */


contract MarketPlace {

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
	
	
	function MarketPlace() {
		
	}


	function submitAppForReview(string name, uint version, string files, string checksum) returns(bool res) { 
		return true;
	}


	function vote(uint id, bool vote) onlyOperator returns(bool res) {
		return true;
	}

}
