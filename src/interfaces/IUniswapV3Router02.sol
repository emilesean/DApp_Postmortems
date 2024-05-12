// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;

interface IUniswapV3Router02 {

    type ApprovalType is uint8;

    struct ExactInputParams {
        bytes path;
        address recipient;
        uint256 amountIn;
        uint256 amountOutMinimum;
    }

    struct ExactInputSingleParams {
        address tokenIn;
        address tokenOut;
        uint24 fee;
        address recipient;
        uint256 amountIn;
        uint256 amountOutMinimum;
        uint160 sqrtPriceLimitX96;
    }

    struct ExactOutputParams {
        bytes path;
        address recipient;
        uint256 amountOut;
        uint256 amountInMaximum;
    }

    struct ExactOutputSingleParams {
        address tokenIn;
        address tokenOut;
        uint24 fee;
        address recipient;
        uint256 amountOut;
        uint256 amountInMaximum;
        uint160 sqrtPriceLimitX96;
    }

    struct IncreaseLiquidityParams {
        address token0;
        address token1;
        uint256 tokenId;
        uint256 amount0Min;
        uint256 amount1Min;
    }

    struct MintParams {
        address token0;
        address token1;
        uint24 fee;
        int24 tickLower;
        int24 tickUpper;
        uint256 amount0Min;
        uint256 amount1Min;
        address recipient;
    }

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
    event SetStableSwap(address indexed factory, address indexed info);

    receive() external payable;

    function WETH9() external view returns (address);
    function approveMax(address token) external payable;
    function approveMaxMinusOne(address token) external payable;
    function approveZeroThenMax(address token) external payable;
    function approveZeroThenMaxMinusOne(address token) external payable;
    function callPositionManager(bytes memory data) external payable returns (bytes memory result);
    function checkOracleSlippage(
        bytes[] memory paths,
        uint128[] memory amounts,
        uint24 maximumTickDivergence,
        uint32 secondsAgo
    ) external view;
    function checkOracleSlippage(bytes memory path, uint24 maximumTickDivergence, uint32 secondsAgo) external view;
    function deployer() external view returns (address);
    function exactInput(ExactInputParams memory params) external payable returns (uint256 amountOut);
    function exactInputSingle(ExactInputSingleParams memory params) external payable returns (uint256 amountOut);
    function exactInputStableSwap(
        address[] memory path,
        uint256[] memory flag,
        uint256 amountIn,
        uint256 amountOutMin,
        address to
    ) external payable returns (uint256 amountOut);
    function exactOutput(ExactOutputParams memory params) external payable returns (uint256 amountIn);
    function exactOutputSingle(ExactOutputSingleParams memory params) external payable returns (uint256 amountIn);
    function exactOutputStableSwap(
        address[] memory path,
        uint256[] memory flag,
        uint256 amountOut,
        uint256 amountInMax,
        address to
    ) external payable returns (uint256 amountIn);
    function factory() external view returns (address);
    function factoryV2() external view returns (address);
    function getApprovalType(address token, uint256 amount) external returns (ApprovalType);
    function increaseLiquidity(IncreaseLiquidityParams memory params) external payable returns (bytes memory result);
    function mint(MintParams memory params) external payable returns (bytes memory result);
    function multicall(bytes32 previousBlockhash, bytes[] memory data) external payable returns (bytes[] memory);
    function multicall(uint256 deadline, bytes[] memory data) external payable returns (bytes[] memory);
    function multicall(bytes[] memory data) external payable returns (bytes[] memory results);
    function owner() external view returns (address);
    function pancakeV3SwapCallback(int256 amount0Delta, int256 amount1Delta, bytes memory _data) external;
    function positionManager() external view returns (address);
    function pull(address token, uint256 value) external payable;
    function refundETH() external payable;
    function renounceOwnership() external;
    function selfPermit(address token, uint256 value, uint256 deadline, uint8 v, bytes32 r, bytes32 s)
        external
        payable;
    function selfPermitAllowed(address token, uint256 nonce, uint256 expiry, uint8 v, bytes32 r, bytes32 s)
        external
        payable;
    function selfPermitAllowedIfNecessary(address token, uint256 nonce, uint256 expiry, uint8 v, bytes32 r, bytes32 s)
        external
        payable;
    function selfPermitIfNecessary(address token, uint256 value, uint256 deadline, uint8 v, bytes32 r, bytes32 s)
        external
        payable;
    function setStableSwap(address _factory, address _info) external;
    function stableSwapFactory() external view returns (address);
    function stableSwapInfo() external view returns (address);
    function swapExactTokensForTokens(uint256 amountIn, uint256 amountOutMin, address[] memory path, address to)
        external
        payable
        returns (uint256 amountOut);
    function swapTokensForExactTokens(uint256 amountOut, uint256 amountInMax, address[] memory path, address to)
        external
        payable
        returns (uint256 amountIn);
    function sweepToken(address token, uint256 amountMinimum, address recipient) external payable;
    function sweepToken(address token, uint256 amountMinimum) external payable;
    function sweepTokenWithFee(address token, uint256 amountMinimum, uint256 feeBips, address feeRecipient)
        external
        payable;
    function sweepTokenWithFee(
        address token,
        uint256 amountMinimum,
        address recipient,
        uint256 feeBips,
        address feeRecipient
    ) external payable;
    function transferOwnership(address newOwner) external;
    function unwrapWETH9(uint256 amountMinimum, address recipient) external payable;
    function unwrapWETH9WithFee(uint256 amountMinimum, address recipient, uint256 feeBips, address feeRecipient)
        external
        payable;
    function unwrapWETH9WithFee(uint256 amountMinimum, uint256 feeBips, address feeRecipient) external payable;
    function wrapETH(uint256 value) external payable;

}
