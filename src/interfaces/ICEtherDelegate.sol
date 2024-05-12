// SPDX-License-Identifier: UNLICENSED

pragma solidity >=0.7.0 <0.9.0;

interface ICEtherDelegate {

    function borrow(uint256 borrowAmount) external returns (uint256);

    function getCash() external view returns (uint256);

    function mint() external payable;

    function balanceOf(address account) external view returns (uint256);

    function transfer(address dst, uint256 amount) external returns (bool);

    function transferFrom(address src, address dst, uint256 amount) external returns (bool);

    function underlying() external view returns (address);

}
