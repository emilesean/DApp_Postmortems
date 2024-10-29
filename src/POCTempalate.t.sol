// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

/**
 * Key Information
 *  Project Name:
 *  Date:
 *  Total Lost : ~M USD$
 *  Vulenerability Category:
 *  Vulenerability:
 *  TLDR Description:
 *  Attack Tx1 :
 */

/**
 * Interfaces
 */
import "forge-std/Test.sol";

import {IUSDC} from "src/interfaces/IUSDC.sol";
import {IUSDT} from "src/interfaces/IUSDT.sol";

contract ContractTest is Test {

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
