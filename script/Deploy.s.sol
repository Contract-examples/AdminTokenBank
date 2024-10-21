// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import "forge-std/Script.sol";
import "../src/AdminTokenBank.sol";

contract DeployAdminTokenBank is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("SEPOLIA_WALLET_PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        address tokenAddress = 0xFadcc47E79575f09b6F7ED3936A2A3Eeb86d6E7D;
        address adminAddress = 0x059dC4EEe9328A9f163a7e813B2f5B4A52ADD4dF;

        AdminTokenBank bank = new AdminTokenBank(adminAddress, tokenAddress);

        console.log("AdminTokenBank deployed at:", address(bank));

        vm.stopBroadcast();
    }
}
