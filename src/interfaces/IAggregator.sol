// SPDX-License-Identifier: UNLICENSED

pragma solidity >=0.7.0 <0.9.0;

interface IAggregator {

    function latestAnswer() external view returns (int256 answer);

}
