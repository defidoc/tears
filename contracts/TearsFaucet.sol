// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;


import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";


contract TearsFaucet is Ownable, ReentrancyGuard {

    ERC20 tears;
    address public immutable ust;
    address public immutable luna;

    mapping(address => uint256) redeemed;

    uint256 public immutable maxRedeem;

    constructor(ERC20 tears_, address _ust, address _luna) {
        tears = tears_;
        ust = _ust;
        luna = _luna;
        maxRedeem = tears.totalSupply() / 10000;
    }

    function redeem(address token, uint256 amount) external nonReentrant {
        require(token == ust || token == luna, "Wrong token");


        uint256 output = getOutput(amount);
        require(redeemed[msg.sender] + output <= maxRedeem, "Over max redeem");

        redeemed[msg.sender] += output;

        IERC20(token).transferFrom(msg.sender, address(this), amount);
        tears.transfer(msg.sender, output);

    }

    function getOutput(uint256 amount) public view returns(uint256) {
        return amount > maxRedeem ? maxRedeem : amount ;
    }

    function withdraw() external onlyOwner {
        IERC20(ust).transfer(owner(), IERC20(ust).balanceOf(address(this)));
        IERC20(ust).transfer(owner(), IERC20(luna).balanceOf(address(this)));
    }



    
}