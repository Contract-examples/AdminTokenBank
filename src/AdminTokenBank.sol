// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Address.sol";

contract AdminTokenBank is Ownable {
    using SafeERC20 for IERC20;

    // admin
    address public admin;

    // token
    IERC20 public token;
    // balance
    uint256 public balances;

    // error
    error DepositTooLow();
    error InsufficientBalance();
    error TransferFailedForDeposit();
    error TransferFailedForWithdraw();
    error OnlyOwnerCanWithdraw();
    error WithdrawOnlyToAdminOrOwner();
    error InvalidAdminAddress();

    // event
    event Deposit(address indexed user, uint256 amount);
    event Withdraw(address indexed user, uint256 amount);
    event AdminChanged(address indexed oldAdmin, address indexed newAdmin);

    constructor(address _admin, address _token) Ownable(msg.sender) {
        token = IERC20(_token);
        admin = _admin;
    }

    function deposit(uint256 amount) public {
        // if amount is 0, revert
        if (amount == 0) {
            revert DepositTooLow();
        }

        // transfer token from user to contract (safe transfer)
        token.safeTransferFrom(_msgSender(), address(this), amount);

        // update balance
        balances += amount;

        // emit event
        emit Deposit(_msgSender(), amount);
    }

    function withdrawTo(uint256 amount, address to) external {
        // if msg.sender is not owner, revert
        if (_msgSender() != owner()) {
            revert OnlyOwnerCanWithdraw();
        }

        // if to is not admin or owner, revert
        if (to != admin && to != owner()) {
            revert WithdrawOnlyToAdminOrOwner();
        }

        // if amount is greater than balance, revert
        if (amount > balances) {
            revert InsufficientBalance();
        }

        // transfer token from contract to user (safe transfer)
        token.safeTransfer(to, amount);

        // update balance
        balances -= amount;

        // emit event
        emit Withdraw(to, amount);
    }

    function transferAdmin(address newAdmin) external onlyOwner {
        // if newAdmin is 0, revert
        if (newAdmin == address(0)) {
            revert InvalidAdminAddress();
        }

        // update admin
        address oldAdmin = admin;
        admin = newAdmin;

        // emit event
        emit AdminChanged(oldAdmin, newAdmin);
    }

    function renounceAdmin() external onlyOwner {
        // update admin
        address oldAdmin = admin;
        admin = address(0);

        // emit event
        emit AdminChanged(oldAdmin, address(0));
    }
}
