pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import {IStrUpPool} from "./interfaces/IStrUpPool.sol";
import {IStrUpStaking} from "./interfaces/IStrUpStaking.sol";
import {StrUpPool} from "./StrUpPool.sol";
import {STR8Token} from "./STR8Token.sol";

contract StrUpStaking is Ownable, IStrUpStaking {

    StrUpPool public strUpPool;
    STR8Token public strUpToken;
    IERC20 public strUpLPToken;

    uint256 public rewardRate = 1 ;  // Rewards distributed per day less than 100
    uint256 public period = 1 days;  // Rewards distributed per day

    uint256 public bonusAmount1 = 50_000 * 1e18;   // Rewards distributed per year
    uint256 public bonusAmount2 = 125_000 * 1e18;   // Rewards distributed per year
    uint256 public bonusAmount3 = 250_000 * 1e18;   // Rewards distributed per year
    uint256 public bonusRate1 = 110;   // Rewards distributed per year   
    uint256 public bonusRate2 = 120;   // Rewards distributed per year
    uint256 public bonusRate3 = 150;   // Rewards distributed per year

    uint256 public strUpDecimals = 18;   // Rewards distributed per year

    mapping(address => uint256) public userStakeAmount;
    mapping(address => uint256) public userStakeAmountLP;
    mapping(address => uint256) public userRewards;

    mapping(address => uint256) private timeStamps;
    mapping(address => uint256) private timeStampsLP;
    mapping(address => uint256) private timeStampsInit;
    mapping(address => uint256) private timeStampsInitLP;

    constructor() Ownable(msg.sender) {
    }

    function setRewardRate(uint256 _rewardRate) external onlyOwner {
        rewardRate = _rewardRate;
    }

    function setBonusRate(uint256 _bonusRate1, uint256 _bonusRate2, uint256 _bonusRate3) external onlyOwner {
        bonusRate1 = _bonusRate1;
        bonusRate2 = _bonusRate2;
        bonusRate3 = _bonusRate3;
    }

    function setBonusAmount(uint256 _bonusAmount1, uint256 _bonusAmount2, uint256 _bonusAmount3) external onlyOwner {
        bonusAmount1 = _bonusAmount1 * 1e18;
        bonusAmount2 = _bonusAmount2 * 1e18;
        bonusAmount3 = _bonusAmount3 * 1e18;
    }

    function setStrUpToken(address _strUpToken) external onlyOwner {
        strUpToken = STR8Token(_strUpToken);
    }

    function setStrUpLPToken(address _strUpLPToken) external onlyOwner {
        strUpLPToken = IERC20(_strUpLPToken);
    }

    function setStrUpPool(address _strUpPool) external onlyOwner {
        strUpPool = StrUpPool(_strUpPool);
    }

    function stakeStrUp(uint256 amount) external {
        _updateReward(msg.sender);
        userStakeAmount[msg.sender] = userStakeAmount[msg.sender] + amount;
        strUpToken.transferFrom(msg.sender, address(this), amount);
        if (timeStampsInit[msg.sender] == 0) {
            timeStampsInit[msg.sender] = block.timestamp;
        }
    }

    function stakeStrUpLP(uint256 amount) external {
        _updateReward(msg.sender);
        userStakeAmountLP[msg.sender] = userStakeAmountLP[msg.sender] + amount;
        strUpLPToken.transferFrom(msg.sender, address(this), amount);
        if (timeStampsInitLP[msg.sender] == 0) {
            timeStampsInitLP[msg.sender] = block.timestamp;
        }
    }

    function withdrawStrUp(uint256 amount) external {
        _updateReward(msg.sender);
        userStakeAmount[msg.sender] = userStakeAmount[msg.sender] - amount;
        strUpToken.transfer(msg.sender, amount);

        if (userStakeAmount[msg.sender] == 0) {
            timeStampsInit[msg.sender] = 0;
        }
    }

    function withdrawStrUpLP(uint256 amount) external {
        _updateReward(msg.sender);
        userStakeAmountLP[msg.sender] = userStakeAmountLP[msg.sender] - amount;
        strUpLPToken.transferFrom(address(this), msg.sender, amount);
        
        if (userStakeAmountLP[msg.sender] == 0) {
            timeStampsInitLP[msg.sender] = 0;
        }
    }

    function claimReward() external {
        _updateReward(msg.sender);
        uint256 reward = userRewards[msg.sender];
        userRewards[msg.sender] = 0;        
        strUpPool.transferToken(msg.sender, reward);
    }

    function _updateReward(address staker) internal {
        uint256 timestamp = block.timestamp;
        uint256 reward = rewardRate * userStakeAmount[staker] * ((timestamp - timeStamps[staker]) / period);
        if ((userStakeAmount[staker] > bonusAmount1) && (userStakeAmount[staker] <= bonusAmount2)) {
            reward = reward * bonusRate1 / 100;
        }
        else if ((userStakeAmount[staker] > bonusAmount2) && (userStakeAmount[staker] <= bonusAmount3)) {
            reward = reward * bonusRate2 / 100;
        }
        else if (userStakeAmount[staker] > bonusAmount3){
            reward = reward * bonusRate3 / 100;
        }
        
        if (timeStampsInit[staker] > 0) {
            uint256 lockTime = timestamp - timeStampsInit[staker];
            if ((lockTime > 13 weeks ) && (lockTime <= 26 weeks )) {
                reward = reward * 5 / 4;
            }
            else if ((lockTime > 26 weeks ) && (lockTime <= 39 weeks )) {
                reward = reward * 3 / 2;
            }
            else if ((lockTime > 39 weeks ) && (lockTime <= 52 weeks )) {
                reward = reward * 7 / 4;
            }
            else if (lockTime > 52 weeks ) {
                reward = reward * 2;
            }
        }


        uint256 rewardLP = rewardRate * userStakeAmountLP[staker] * ((timestamp - timeStampsLP[staker]) / period);
        if ((userStakeAmountLP[staker] > bonusAmount1) && (userStakeAmountLP[staker] <= bonusAmount2)) {
            rewardLP = rewardLP * bonusRate1 / 100;
        }
        else if ((userStakeAmountLP[staker] > bonusAmount2) && (userStakeAmountLP[staker] <= bonusAmount3)) {
            rewardLP = rewardLP * bonusRate2 / 100;
        }
        else if (userStakeAmount[staker] > bonusAmount3){
            rewardLP = rewardLP * bonusRate3 / 100;
        }
        
        if (timeStampsInitLP[staker] > 0) {
            uint256 lockTime = timestamp - timeStampsInitLP[staker];
            if ((lockTime > 13 weeks ) && (lockTime <= 26 weeks )) {
                rewardLP = rewardLP * 5 / 4;
            }
            else if ((lockTime > 26 weeks ) && (lockTime <= 39 weeks )) {
                rewardLP = rewardLP * 3 / 2;
            }
            else if ((lockTime > 39 weeks ) && (lockTime <= 52 weeks )) {
                rewardLP = rewardLP * 7 / 4;
            }
            else if (lockTime > 52 weeks ) {
                rewardLP = rewardLP * 2;
            }
        }


        userRewards[staker] = userRewards[staker] + reward + rewardLP;
        timeStamps[msg.sender] = timestamp;
    }

    function totalStakedStrUp() public view returns (uint256) {
        return strUpToken.balanceOf(address(this));
    }

    function totalStakedStrUpLP() public view returns (uint256) {
        return strUpLPToken.balanceOf(address(this));
    }
}