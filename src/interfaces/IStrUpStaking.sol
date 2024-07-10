pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

interface IStrUpStaking {
    function setRewardRate(uint256 _rewardRate) external;

    function setBonusRate(uint256 _bonusRate1, uint256 _bonusRate2, uint256 _bonusRate3) external;

    function setBonusAmount(uint256 _bonusAmount1, uint256 _bonusAmount2, uint256 _bonusAmount3) external;

    function setStrUpToken(address _strUpToken) external;

    function setStrUpLPToken(address _strUpLPToken) external;

    function setStrUpPool(address _strUpPool) external;

    function stakeStrUp(uint256 amount) external;

    function stakeStrUpLP(uint256 amount) external;

    function withdrawStrUp(uint256 amount) external;

    function withdrawStrUpLP(uint256 amount) external;

    function claimReward() external;

    function totalStakedStrUp() external view returns (uint256);

    function totalStakedStrUpLP() external view returns (uint256);
}