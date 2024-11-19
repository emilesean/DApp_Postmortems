// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

/**
 * @title: Proof of Concept for Uniswapv4 Security breach
 * @author: @emilesean_es
 * @custom: Project Name: [Uniswapv4](https://x.com/Uniswap)
 * @custom: Description: ...
 * @custom: Date: Oct-29-2024 06:29:11 AM UTC
 * @custom: Value lost:  ~1M USD$
 * @custom: Vulnerability category: Arithmetic & Calculation Errors
 * @custom: Attack Variant: Rounding Error
 * @custom: [Attack Tx1:](https://etherscan.io/tx/0hx176bd09366ceb30c54dh1c0bb79065498dfcb3cc8d4967d2c7602247ec3c3bc44)
 */
import "forge-std/Test.sol";

import {IUSDC} from "src/interfaces/IUSDC.sol";
import {IUSDT} from "src/interfaces/IUSDT.sol";

contract PocTemplate is Test {

    IUSDC constant USDC = IUSDC(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48);
    IUSDT constant USDT = IUSDT(0xdAC17F958D2ee523a2206206994597C13D831ec7);
    address public alice;
    address public bob;

    function setUp() public {
        vm.createSelectFork("mainnet", 15_460_093);
        vm.label(address(USDC), "USDC");
        vm.label(address(USDT), "USDT");
        alice = makeAddr("alice");
        bob = makeAddr("bob");
    }

    function testExploit() public view {
        //vm.startPrank(alice);
        //vm.stopPrank();
        USDC.balanceOf(address(alice));
    }

}
