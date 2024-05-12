// SPDX-License-Identifier: UNLICENSED

pragma solidity >=0.7.0 <0.9.0;

interface CErc20Interface {

    function mint(uint256 mintAmount) external returns (uint256);

    function balanceOf(address account) external view returns (uint256);

    function borrow(uint256 borrowAmount) external returns (uint256);

}
