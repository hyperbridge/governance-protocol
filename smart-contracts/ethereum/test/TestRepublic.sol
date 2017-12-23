pragma solidity ^0.4.2;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/Republic.sol";

contract TestRepublic {

    function testInitialDelegates() public payable {
        Republic token = Republic(DeployedAddresses.Republic());

        address expected = 0x627306090abaB3A6e1400e9345bC60c78a8BEf57;

        Assert.equal(token.getDelegates()[0], expected, "Initial delegates should all be 0x627306090abaB3A6e1400e9345bC60c78a8BEf57");
    }

}
