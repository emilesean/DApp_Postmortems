// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

/**
 * Key Information
 *  Project Name:
 *  Date:
 *  Total Lost : ~999M US$
 *  Vulenerability:
 *  Attack Tx : 0x123456789
 *  Post-mortem : https://www.google.com/
 *  Source : https://www.google.com/
 *  https://etherscan.io/address/0x841ddf093f5188989fa1524e7b893de64b421f47
 *  https://etherscan.io/tx/0x242a0fb4fde9de0dc2fd42e8db743cbc197ffa2bf6a036ba0bba303df296408b
 *  https://etherscan.io/tx/0xca1bbf3b320662c89232006f1ec6624b56242850f07e0f1dadbe4f69ba0d6ac3
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
        vm.createSelectFork("mainnet", 15_460_093);
        vm.label(address(USDC), "USDC");
        vm.label(address(USDT), "USDT");
        //address alice = makeAddr("alice");
    }

    function testExploit() public {
        //vm.startPrank(alice);
        //vm.stopPrank();
    }

}
