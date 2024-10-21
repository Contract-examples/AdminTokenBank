// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/utils/Address.sol";

contract TokenBank {
    using SafeERC20 for IERC20;

    // token
    IERC20 public token;

    // user => balance
    mapping(address => uint256) public balances;

    // error
    error DepositTooLow();
    error InsufficientBalance();
    error TransferFailedForDeposit();
    error TransferFailedForWithdraw();

    // event
    event Deposit(address indexed user, uint256 amount);
    event Withdraw(address indexed user, uint256 amount);

    constructor(address _token) {
        token = IERC20(_token);
    }

    function deposit(uint256 amount) public {
        // if amount is 0, revert
        if (amount == 0) {
            revert DepositTooLow();
        }

        // transfer token from user to contract (safe transfer)
        token.safeTransferFrom(msg.sender, address(this), amount);

        // update balance
        balances[msg.sender] += amount;

        // emit event
        emit Deposit(msg.sender, amount);
    }

    function withdraw(uint256 amount) external {
        // if amount > balance, revert
        if (amount > balances[msg.sender]) {
            revert InsufficientBalance();
        }

        // transfer token from contract to user (safe transfer)
        token.safeTransfer(msg.sender, amount);

        // update balance
        balances[msg.sender] -= amount;

        // emit event
        emit Withdraw(msg.sender, amount);
    }

    // Query contract balance
    function getBalance() public view returns (uint256) {
        return token.balanceOf(address(this));
    }

    // Query specific depositor's deposit amount
    function getDepositAmount(address depositor) public view returns (uint256) {
        return balances[depositor];
    }
}
