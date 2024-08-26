// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

/**
 * Key Information
 *  Project Name:
 *  Date: 2024-05-12
 *  Total Lost : ~8K US$
 *  Vulenerability: Broken access control:
 *  Description: There's a callback function for uniswap v3 exchange in victim contract, and it didn't check msg.sender. So hacker could call this function directly, transferred funds of users who approved to victim contract.
 *  Attack Tx : https://app.blocksec.com/explorer/tx/optimism/0x448660a00e5b79d417c173ec0b194916b64a310674c143d9f67ef9c113615fde
 *  Post-mortem : https://www.google.com/
 *  Source : https://www.google.com/
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

    function setUp() public {
        vm.createSelectFork("optimism", 119_943_500);
        vm.label(address(USDC), "USDC");
        vm.label(address(USDT), "USDT");
        //address alice = makeAddr("alice");
    }

    function testExploit() public {
        //vm.startPrank(alice);
        //vm.stopPrank();
    }

}
