// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;

interface IPancakeIUniversalRouter {

    error BalanceTooLow();
    error BuyPancakeNFTFailed();
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
    error InvalidPoolAddress();
    error InvalidPoolLength();
    error InvalidReserves();
    error InvalidSpender();
    error LengthMismatch();
    error SliceOutOfBounds();
    error StableInvalidPath();
    error StableTooLittleReceived();
    error StableTooMuchRequested();
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

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
    event Paused(address account);
    event RewardsSent(uint256 amount);
    event SetStableSwap(address indexed factory, address indexed info);
    event Unpaused(address account);

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
    function owner() external view returns (address);
    function pancakeV3SwapCallback(int256 amount0Delta, int256 amount1Delta, bytes memory data) external;
    function pause() external;
    function paused() external view returns (bool);
    function renounceOwnership() external;
    function setStableSwap(address _factory, address _info) external;
    function stableSwapFactory() external view returns (address);
    function stableSwapInfo() external view returns (address);
    function supportsInterface(bytes4 interfaceId) external pure returns (bool);
    function transferOwnership(address newOwner) external;
    function unpause() external;

}
