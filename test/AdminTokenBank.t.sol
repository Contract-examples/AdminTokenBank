// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import "forge-std/Test.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "../src/AdminTokenBank.sol";
import "../src/MyERC20Token.sol";

contract AdminTokenBankTest is Test {
    AdminTokenBank public bank;
    MyERC20Token public token;
    address public owner;
    address public admin;
    address public user;

    function setUp() public {
        token = new MyERC20Token("MyNFTToken", "MTK");
        owner = address(this);
        admin = address(0x3389);
        user = address(0x1);
        bank = new AdminTokenBank(admin, address(token));

        // give user 1000 tokens
        token.mint(user, 10_000 * 10 ** 18);
    }

    function testDepositAndWithdrawAndTransferAdmin() public {
        // deposit by user
        vm.startPrank(user);
        token.approve(address(bank), 500 * 10 ** 18);
        bank.deposit(500 * 10 ** 18);
        vm.stopPrank();

        assertEq(bank.balances(), 500 * 10 ** 18);

        // withdraw by user
        vm.startPrank(user);
        // set expect revert
        vm.expectRevert(AdminTokenBank.OnlyOwnerCanWithdraw.selector);
        bank.withdrawTo(500 * 10 ** 18, user);
        vm.stopPrank();

        // withdraw by admin to admin
        vm.startPrank(admin);
        // set expect revert
        vm.expectRevert(AdminTokenBank.OnlyOwnerCanWithdraw.selector);
        bank.withdrawTo(500 * 10 ** 18, admin);
        vm.stopPrank();

        // withdraw by owner to admin
        vm.startPrank(owner);
        bank.withdrawTo(500 * 10 ** 18, admin);
        vm.stopPrank();

        assertEq(bank.balances(), 0);

        // deposit by user
        vm.startPrank(user);
        token.approve(address(bank), 500 * 10 ** 18);
        bank.deposit(500 * 10 ** 18);
        vm.stopPrank();

        // transfer admin to user
        vm.startPrank(owner);
        bank.transferAdmin(user);
        vm.stopPrank();

        // withdraw by owner to user
        vm.startPrank(owner);
        bank.withdrawTo(500 * 10 ** 18, user);
        vm.stopPrank();

        assertEq(bank.balances(), 0);
    }
}
