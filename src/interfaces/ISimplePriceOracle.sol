// SPDX-License-Identifier: UNLICENSED

pragma solidity >=0.7.0 <0.9.0;

interface ISimplePriceOracle {

    event PricePosted(
        address asset, uint256 previousPriceMantissa, uint256 requestedPriceMantissa, uint256 newPriceMantissa
    );

    function getUnderlyingPrice(address rToken) external view returns (uint256);

    function isPriceOracle() external view returns (bool);

    function oracleData(address) external view returns (address);

    function setOracleData(address rToken, address _oracle) external;

}
