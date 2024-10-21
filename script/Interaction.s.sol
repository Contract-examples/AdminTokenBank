// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import "forge-std/Script.sol";
import "forge-std/console2.sol";
import "../src/AdminTokenBank.sol";
import "../src/MyERC20Token.sol";

contract InteractionScript is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("SEPOLIA_WALLET_PRIVATE_KEY");

        address bankAddress = 0x0F5011654af81E582bf7358C16515F18a0CbbBC9;

        address newAdminAddress = address(0x260ef6029160BB9E89A50e0ead94DBf3F4725106);

        address tokenAddress = 0xFadcc47E79575f09b6F7ED3936A2A3Eeb86d6E7D;
        MyERC20Token token = MyERC20Token(tokenAddress);

        vm.startBroadcast(deployerPrivateKey);

        AdminTokenBank bank = AdminTokenBank(bankAddress);

        // bank.transferAdmin(newAdminAddress);

        // console.log("Admin role transferred to:", newAdminAddress);

        // // deposit
        // token.approve(address(bank), 10 * 10 ** 18);
        // bank.deposit(10 * 10 ** 18);
        // vm.stopPrank();

        // console2.log("bank balance:", bank.balances());

        // // withdraw
        // bank.withdrawTo(10 * 10 ** 18, newAdminAddress);
        // console2.log("bank balance:", bank.balances());

        vm.stopBroadcast();
    }
}
