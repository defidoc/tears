// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;


import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

import "hardhat/console.sol";


contract TearsFaucet is Ownable, ReentrancyGuard {

    ERC20 tears;
    address public constant ust = 0x23396cF899Ca06c4472205fC903bDB4de249D6fC;
    address public constant luna = 0x156ab3346823B651294766e23e6Cf87254d68962;

    uint256 rate = 100 ether;
    constructor(ERC20 tears_) {
        tears = tears_;
    }

    function redeem(address token, uint256 amount) external nonReentrant {
        require(token == ust || token == luna, "Wrong token");

        uint256 toDistribute = tears.totalSupply() * rate / IERC20(token).totalSupply();
        console.log(toDistribute);

        IERC20(token).transferFrom(msg.sender, address(this), amount);
        tears.transfer(msg.sender, toDistribute);

    }

    function withdraw() external onlyOwner {
        IERC20(ust).transfer(owner(), IERC20(ust).balanceOf(address(this)));
        IERC20(ust).transfer(owner(), IERC20(luna).balanceOf(address(this)));
    }



    
}