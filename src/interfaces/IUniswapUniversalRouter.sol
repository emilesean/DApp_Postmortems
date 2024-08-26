// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;

interface IUniswapUniversalRouter {

    error BalanceTooLow();
    error BuyPunkFailed();
    error ContractLocked();
    error ETHNotAccepted();
    error ExecutionFailed(uint256 commandIndex, bytes message);
    error FromAddressIsNotOwner();
    error InsufficientETH();
    error InsufficientToken();
    error InvalidBips();
    error InvalidCommandType(uint256 commandType);
    error InvalidOwnerERC1155();
    error InvalidOwnerERC721();
    error InvalidPath();
    error InvalidReserves();
    error InvalidSpender();
    error LengthMismatch();
    error SliceOutOfBounds();
    error TransactionDeadlinePassed();
    error UnableToClaim();
    error UnsafeCast();
    error V2InvalidPath();
    error V2TooLittleReceived();
    error V2TooMuchRequested();
    error V3InvalidAmountOut();
    error V3InvalidCaller();
    error V3InvalidSwap();
    error V3TooLittleReceived();
    error V3TooMuchRequested();

    event RewardsSent(uint256 amount);

    receive() external payable;

    function collectRewards(bytes memory looksRareClaim) external;
    function execute(bytes memory commands, bytes[] memory inputs) external payable;
    function execute(bytes memory commands, bytes[] memory inputs, uint256 deadline) external payable;
    function onERC1155BatchReceived(address, address, uint256[] memory, uint256[] memory, bytes memory)
        external
        pure
        returns (bytes4);
    function onERC1155Received(address, address, uint256, uint256, bytes memory) external pure returns (bytes4);
    function onERC721Received(address, address, uint256, bytes memory) external pure returns (bytes4);
    function supportsInterface(bytes4 interfaceId) external pure returns (bool);
    function uniswapV3SwapCallback(int256 amount0Delta, int256 amount1Delta, bytes memory data) external;

}
