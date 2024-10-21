// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import "forge-std/Test.sol";
import "../src/AdminTokenBank.sol";
import "../src/MyERC20Token.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

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
        token.mint(user, 1000 * 10 ** 18);
    }

    function testDepositAndWithdraw() public {
        // deposit by user
        vm.startPrank(user);
        token.approve(address(bank), 500 * 10 ** 18);
        bank.deposit(500 * 10 ** 18);
        vm.stopPrank();

        assertEq(bank.balances(), 500 * 10 ** 18);

        vm.startPrank(user);
        // set expect revert
        vm.expectRevert(AdminTokenBank.OnlyAdminOrOwnerCanWithdraw.selector);
        bank.withdrawTo(500 * 10 ** 18, user);
        vm.stopPrank();
    }
}
