// SPDX-License-Identifier: UNLICENSED

pragma solidity >=0.7.0 <0.9.0;

interface Pool {

    event FeesUpdated(uint256 _mintingFee, uint256 _redemptionFee);
    event MaxXftmSupplyUpdated(uint256 _value);
    event MinCollateralRatioUpdated(uint256 _minCollateralRatio);
    event Mint(address minter, uint256 amount, uint256 ftmIn, uint256 fantasmIn, uint256 fee);
    event NewCollateralRatioOptions(
        uint256 _ratioStepUp, uint256 _ratioStepDown, uint256 _priceBand, uint256 _refreshCooldown
    );
    event NewCollateralRatioSet(uint256 _cr);
    event OracleChanged(address indexed _oracle);
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
    event PoolUtilsChanged(address indexed _addr);
    event Recollateralized(address indexed _sender, uint256 _amount);
    event Redeem(address redeemer, uint256 amount, uint256 ftmOut, uint256 fantasmOut, uint256 fee);
    event SwapConfigUpdated(address indexed _router, uint256 _slippage, address[] _paths);
    event Toggled(bool _mintPaused, bool _redeemPaused);
    event UpdateCollateralRatioPaused(bool _collateralRatioPaused);
    event ZapMint(address minter, uint256 amount, uint256 ftmIn, uint256 fee);

    function MINTING_FEE_MAX() external view returns (uint256);

    function REDEMPTION_FEE_MAX() external view returns (uint256);

    function calcExcessFtmBalance() external view returns (uint256 _delta, bool _exceeded);

    function calcMint(uint256 _ftmIn, uint256 _fantasmIn)
        external
        view
        returns (uint256 _xftmOut, uint256 _minFtmIn, uint256 _minFantasmIn, uint256 _fee);

    function calcRedeem(uint256 _xftmIn)
        external
        view
        returns (uint256 _ftmOut, uint256 _fantasmOut, uint256 _ftmFee, uint256 _requiredFtmBalance);

    function calcZapMint(uint256 _ftmIn)
        external
        view
        returns (uint256 _xftmOut, uint256 _fantasmOut, uint256 _ftmFee, uint256 _ftmSwapIn);

    function collateralRatio() external view returns (uint256);

    function collateralRatioPaused() external view returns (bool);

    function collect() external;

    function configSwap(address _swapRouter, uint256 _swapSlippage, address[] memory _swapPaths) external;

    function fantasm() external view returns (address);

    function feeReserve() external view returns (address);

    function info()
        external
        view
        returns (
            uint256 _collateralRatio,
            uint256 _lastRefreshCrTimestamp,
            uint256 _mintingFee,
            uint256 _redemptionFee,
            bool _mintingPaused,
            bool _redemptionPaused,
            uint256 _collateralBalance,
            uint256 _maxXftmSupply
        );

    function lastRefreshCrTimestamp() external view returns (uint256);

    function maxXftmSupply() external view returns (uint256);

    function minCollateralRatio() external view returns (uint256);

    function mint(uint256 _fantasmIn, uint256 _minXftmOut) external payable;

    function mintPaused() external view returns (bool);

    function mintingFee() external view returns (uint256);

    function oracle() external view returns (address);

    function owner() external view returns (address);

    function priceBand() external view returns (uint256);

    function priceTarget() external view returns (uint256);

    function ratioStepDown() external view returns (uint256);

    function ratioStepUp() external view returns (uint256);

    function recollateralize(uint256 _amount) external;

    function recollateralizeETH() external payable;

    function redeem(uint256 _xftmIn, uint256 _minFantasmOut, uint256 _minFtmOut) external;

    function redeemPaused() external view returns (bool);

    function redemptionFee() external view returns (uint256);

    function reduceExcessFtm(uint256 _amount) external;

    function refreshCollateralRatio() external;

    function refreshCooldown() external view returns (uint256);

    function renounceOwnership() external;

    function setCollateralRatioOptions(
        uint256 _ratioStepUp,
        uint256 _ratioStepDown,
        uint256 _priceBand,
        uint256 _refreshCooldown
    ) external;

    function setFeeReserve(address _feeReserve) external;

    function setFees(uint256 _mintingFee, uint256 _redemptionFee) external;

    function setMaxXftmSupply(uint256 _newValue) external;

    function setMinCollateralRatio(uint256 _minCollateralRatio) external;

    function setOracle(address _oracle) external;

    function swapPaths(uint256) external view returns (address);

    function swapRouter() external view returns (address);

    function swapSlippage() external view returns (uint256);

    function toggle(bool _mintPaused, bool _redeemPaused) external;

    function toggleCollateralRatio(bool _collateralRatioPaused) external;

    function transferOwnership(address newOwner) external;

    function unclaimedFantasm() external view returns (uint256);

    function unclaimedFtm() external view returns (uint256);

    function unclaimedXftm() external view returns (uint256);

    function usableFtmBalance() external view returns (uint256);

    function userInfo(address)
        external
        view
        returns (uint256 xftmBalance, uint256 fantasmBalance, uint256 ftmBalance, uint256 lastAction);

    function xftm() external view returns (address);

    function zap(uint256 _minXftmOut) external payable;

    receive() external payable;

}
