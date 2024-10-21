// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import "forge-std/Script.sol";
import "../src/AdminTokenBank.sol";

contract InteractionScript is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("SEPOLIA_WALLET_PRIVATE_KEY");

        address bankAddress = 0x0F5011654af81E582bf7358C16515F18a0CbbBC9;

        address newAdminAddress = address(0x260ef6029160BB9E89A50e0ead94DBf3F4725106);

        vm.startBroadcast(deployerPrivateKey);

        AdminTokenBank bank = AdminTokenBank(bankAddress);

        bank.transferAdmin(newAdminAddress);

        console.log("Admin role transferred to:", newAdminAddress);

        vm.stopBroadcast();
    }
}
