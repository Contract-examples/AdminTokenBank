// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import "forge-std/Test.sol";
import "../src/TokenBank.sol";
import "../src/SimpleToken.sol";

contract TokenBankTest is Test {
    TokenBank public bank;
    SimpleToken public token;
    address public user1;
    address public user2;
    address public user3;

    function setUp() public {
        token = new SimpleToken(1_000_000 * 10 ** 18); // 1,000,000 tokens
        bank = new TokenBank(address(token));
        user1 = address(0x1);
        user2 = address(0x2);
        user3 = address(0x3);

        // transfer token to user1, user2, user3
        token.transfer(user1, 1000 * 10 ** 18);
        token.transfer(user2, 2000 * 10 ** 18);
        token.transfer(user3, 3000 * 10 ** 18);
    }

    function testDeposit() public {
        vm.startPrank(user1);
        token.approve(address(bank), 500 * 10 ** 18);
        bank.deposit(500 * 10 ** 18);
        vm.stopPrank();

        assertEq(bank.balances(user1), 500 * 10 ** 18);
    }

    function testWithdraw() public {
        vm.startPrank(user1);
        token.approve(address(bank), 500 * 10 ** 18);
        bank.deposit(500 * 10 ** 18);
        uint256 initialBalance = token.balanceOf(user1);
        bank.withdraw(250 * 10 ** 18);
        vm.stopPrank();

        assertEq(bank.balances(user1), 250 * 10 ** 18);
        assertEq(token.balanceOf(user1), initialBalance + 250 * 10 ** 18);
    }
}
