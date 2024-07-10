pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

interface IStrUpPool {
    function setStrUpToken(address _strUpToken) external;

    function transferToken(address to, uint256 amount) external;

    function deposit(uint256 amount) external;
}