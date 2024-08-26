// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

/**
 * Key Information
 *  Project Name:Sonne Finance
 *  Date:
 *  Total Lost : 20M USD$
 *  Vulenerability:
 *  Description:
 *  Attack Tx : https://optimistic.etherscan.io/tx/0x9312ae377d7ebdf3c7c3a86f80514878deb5df51aad38b6191d55db53e42b7f0
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
