// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

interface IERC20Receiver {
    function tokensReceived(address from, address to, uint256 amount, bytes calldata data) external returns (bool);
}
