// SPDX-License-Identifier: UNLICENSED

pragma solidity >=0.7.0 <0.9.0;

interface IDODOCallee {

    // function DVMSellShareCall(
    //     address sender,
    //     uint256 burnShareAmount,
    //     uint256 baseAmount,
    //     uint256 quoteAmount,
    //     bytes calldata data
    // ) external;

    // function DVMFlashLoanCall(
    //     address sender,
    //     uint256 baseAmount,
    //     uint256 quoteAmount,
    //     bytes calldata data
    // ) external;

    function DPPFlashLoanCall(address sender, uint256 baseAmount, uint256 quoteAmount, bytes calldata data) external;

    //   function DSPFlashLoanCall(
    //       address sender,
    //       uint256 baseAmount,
    //       uint256 quoteAmount,
    //       bytes calldata data
    //   ) external;

    //   function CPCancelCall(
    //       address sender,
    //       uint256 amount,
    //       bytes calldata data
    //   ) external;

    // function CPClaimBidCall(
    //       address sender,
    //       uint256 baseAmount,
    //       uint256 quoteAmount,
    //       bytes calldata data
    //   ) external;

    //   function NFTRedeemCall(
    //       address payable assetTo,
    //       uint256 quoteAmount,
    //       bytes calldata
    //   ) external;

}
