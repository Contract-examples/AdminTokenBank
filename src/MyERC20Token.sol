// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./IERC20Receiver.sol";

contract MyERC20Token is ERC20, Ownable {
    // custom error
    error TokensReceivedFailed();

    constructor(string memory name, string memory symbol) ERC20(name, symbol) Ownable(msg.sender) {
        // mint 1000000 tokens to the owner
        _mint(msg.sender, 1_000_000 * 10 ** decimals());
    }

    // only owner can mint
    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }

    // this is a helper function to check if the recipient is a contract
    function _isContract(address account) internal view returns (bool) {
        // if the code size is greater than 0, then the account is a contract
        uint256 size;
        assembly {
            size := extcodesize(account)
        }
        return size > 0;
    }

    // transfer and call 'buyNFTCallback'
    function transferAndCall(address to, uint256 amount, bytes memory data) public returns (bool) {
        // first transfer the tokens to "to" from msg.sender
        bool success = transfer(to, amount);
        if (success && _isContract(to)) {
            // then call the callback function
            try IERC20Receiver(to).tokensReceived(msg.sender, to, amount, data) returns (bool result) {
                return result;
            } catch {
                revert TokensReceivedFailed();
            }
        }
        return success;
    }
}
