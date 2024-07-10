pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import {IStrUpPool} from "./interfaces/IStrUpPool.sol";
import {STR8Token} from "./STR8Token.sol";

contract StrUpPool is ERC20, Ownable, IStrUpPool {

    STR8Token public strUpToken;

    constructor() ERC20("Str8upPool", "STRP") Ownable(msg.sender) {
    }

    function setStrUpToken(address _strUpToken) external onlyOwner {
        strUpToken = STR8Token(_strUpToken);
    }

    function transferToken(address to, uint256 amount) public {
        require(strUpToken.balanceOf(address(this)) >= amount, "token amount is not sufficient.");
        strUpToken.transferFrom(address(this), to, amount);
    }

    function deposit(uint256 amount) external {
        strUpToken.transferFrom(msg.sender, address(this), amount);
    }
}