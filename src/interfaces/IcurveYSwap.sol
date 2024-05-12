// SPDX-License-Identifier: UNLICENSED

pragma solidity >=0.7.0 <0.9.0;

interface IcurveYSwap {

    function exchange(int128 i, int128 j, uint256 dx, uint256 min_dy) external;

    function exchange_underlying(int128 i, int128 j, uint256 dx, uint256 min_dy) external;

}
