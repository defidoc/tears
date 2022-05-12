// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";


contract Tears is ERC20Burnable, Ownable {

    bool public tradingEnabled = false;

    uint256 maxSupply = 10_000_000 * 10**decimals();

    mapping(address => bool) public lp;
    constructor() ERC20("Tears of Luna", "TEARS") {
        _mint(owner(), maxSupply);
    }

    function enableTrading() external onlyOwner {
        tradingEnabled = true;
    }

    function setLP(address lpPair, bool state) external onlyOwner {
        lp[lpPair] = state;
    }

    function _transfer(address from, address to, uint256 amount) internal override {
        if (!tradingEnabled) {
            require(!lp[from] && !lp[to], "Traing disabled");
        }
        super._transfer(from, to, amount);
    }
    
}