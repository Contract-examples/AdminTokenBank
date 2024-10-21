// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import "forge-std/Script.sol";
import "../src/AdminTokenBank.sol";

contract DeployAdminTokenBank is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("SEPOLIA_WALLET_PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        address tokenAddress = 0xFadcc47E79575f09b6F7ED3936A2A3Eeb86d6E7D;
        address adminAddress = 0x260ef6029160BB9E89A50e0ead94DBf3F4725106;

        AdminTokenBank bank = new AdminTokenBank(adminAddress, tokenAddress);

        console.log("AdminTokenBank deployed at:", address(bank));

        vm.stopBroadcast();
    }
}
