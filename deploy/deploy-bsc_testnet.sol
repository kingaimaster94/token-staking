// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console2} from "forge-std/Script.sol";
import {STR8Token} from "../../src/STR8Token.sol";
import {StrUpPool} from "../../src/StrUpPool.sol";
import {StrUpStaking} from "../../src/StrUpStaking.sol";
import "solady/src/utils/ERC1967Factory.sol";
import {IERC20} from "@openzeppelin/contracts/interfaces/IERC20.sol";
import {IERC20Metadata} from "@openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol";
import {TimelockController} from "@openzeppelin/contracts/governance/TimelockController.sol";
import "forge-std/console.sol";

contract StrUpstaking is Script {
    // Addresses
    address internal constant DEPLOYER =
        0x1e890c32D69C2a83bffDf1f2E90DF0a0b9f3B1fa; // deploys all the contracts and does initial setup

    function setUp() public {
    }

    function run() public {
        vm.startBroadcast();
        address proxyAdmin = DEPLOYER;

        // ERC1967Factory factory = new ERC1967Factory();
        STR8Token token = new STR8Token();
        StrUpPool strUpPool = new StrUpPool();
        StrUpStaking strUpStaking = new StrUpStaking();


        // StrUpPool strUpPool = StrUpPool(
        //     factory.deploy(address(strUpPoolImpl), proxyAdmin)
        // );

        strUpPool.setStrUpToken(address(token));       

        // StrUpStaking strUpStaking = StrUpStaking(
        //     factory.deploy(address(strUpStakingImpl), proxyAdmin)
        // ); 

        strUpStaking.setStrUpToken(address(token));
        strUpStaking.setStrUpPool(address(strUpPool));
        
        vm.stopBroadcast();
        console.log("str8Token:", address(token));
        console.log("strUpPool:", address(strUpPool));
        console.log("strUpStaking:", address(strUpStaking));
    }
}
