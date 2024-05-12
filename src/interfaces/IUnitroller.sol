// SPDX-License-Identifier: UNLICENSED

pragma solidity >=0.7.0 <0.9.0;

interface IUnitroller {

    function enterMarkets(address[] memory cTokens) external returns (uint256[] memory);

    function exitMarket(address cTokenAddress) external returns (uint256);

    function cTokensByUnderlying(address) external view returns (address);

    function getAccountLiquidity(address account) external view returns (uint256, uint256, uint256);

    function borrowCaps(address) external view returns (uint256);
    function getAllMarkets() external view returns (address[] memory);

}
