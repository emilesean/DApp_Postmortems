// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {IPancakeUniversalRouter} from "./IPancakeUniversalRouter.sol";
import {IUniswapUniversalRouter} from "./IUniswapUniversalRouter.sol";
import {IUniswapV2Factory} from "./IUniswapV2Factory.sol";
import {IUniswapV2Router} from "./IUniswapV2Router.sol";

import {IUniswapV3Factory} from "./IUniswapV3Factory.sol";
import "forge-std/interfaces/IERC20.sol";
/* 
Top Chain by TVL from Defillama
| No  | Chain     | Dex, Lending                         |
| --- | --------- | -------------------------------------|
| 1   | Ethereum  | UNIV3, UNIV2, AAVE3, AAVE2, MORPHO   |
| 2   | BSC       | UNIV3, UNIV2, PCAKE, AAVE3           |
| 3   | Arbitrum  | UNIV3, UNIV2, AAVE3                  |
| 4   | Base      | UNIV3, UNIV2, AAVE3, MORPHO          |
| 5   | Blast     | UNIV3                                |
| 6   | Avalanche | UNIV3, UNIV2, AAVE3, AAVE2           |
| 7   | Polygon   | UNIV3, UNIV2, AAVE3, AAVE2           |
| 8   | Optimism  | UNIV3, UNIV2, AAVE3                  |
| 9   | Gnosis    |                                      |
| 10  | Linea     | UNIV3, PCAKE                         |
| 11  | RootStock | UNIV3,                               |
| 12  | ZK syncEra| UNIV3                                |
| 13  | Celo      | UNIV3, UNIV2                         |
| 14  | Scroll    | UNIV3, AAVE3                         |
| 15  | FileCoin  | UNIV3                                |
| 16  | Boba      | UNIV3                                |
| 17  | Zora      | UNIV3                                |
| 18  | MoonBeam  | UNIV3                                |
*/

library Ethereum {

    IPancakeUniversalRouter public constant PANCAKE_UNIVERSAL_ROUTER =
        IPancakeUniversalRouter(payable(0x65b382653f7C31bC0Af67f188122035461ec9C76));
    IUniswapV2Factory public constant UNISWAP_V2_FACTORY = IUniswapV2Factory(0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f);
    IUniswapV2Router public constant UNISWAP_V2_ROUTER =
        IUniswapV2Router(payable(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D));
    IUniswapUniversalRouter public constant UNISWAP_UNIVERSAL_ROUTER =
        IUniswapUniversalRouter(payable(0x3fC91A3afd70395Cd496C647d5a6CC9D4B2b7FAD));
    IUniswapV3Factory public constant UNISWAP_V3_FACTORY = IUniswapV3Factory(0x1F98431c8aD98523631AE4a59f267346ea31F984);
    // Tokens
    IERC20 public constant WETH = IERC20(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2);
    IERC20 public constant USDT = IERC20(0xdAC17F958D2ee523a2206206994597C13D831ec7); // Weird
    IERC20 public constant BNB = IERC20(0xB8c77482e45F1F44dE1745F52C74426C631bDD52); // Weird

}

library BSC {

    IPancakeUniversalRouter public constant PANCAKE_UNIVERSAL_ROUTER = IPancakeUniversalRouter(payable());
    IUniswapV3Factory public constant UNISWAP_V3_FACTORY = IUniswapV3Factory(0xdB1d10011AD0Ff90774D0C6Bb92e5C5c8b4461F7);
    IUniswapUniversalRouter public constant IUNISWAP_UNIVERSAL_ROUTER =
        IUniswapUniversalRouter(payable(0x4Dae2f939ACf50408e13d58534Ff8c2776d45265));
    IUniswapV2Factory public constant UNISWAP_V2_FACTORY = IUniswapV2Factory(0x8909Dc15e40173Ff4699343b6eB8132c65e18eC6);
    IUniswapV2Router public constant UNISWAP_V2_ROUTER =
        IUniswapV2Router(payable(0x4752ba5DBc23f44D87826276BF6Fd6b1C372aD24));
    // Tokens
    IERC20 public constant ETH = IERC20(0x2170Ed0880ac9A755fd29B2688956BD959F933F8);
    IERC20 public constant BSCUSD = IERC20(0x55d398326f99059fF775485246999027B3197955);
    IERC20 public constant WBNB = IERC20(0xbb4CdB9CBd36B01bD1cBaEBF2De08d9173bc095c);
    IERC20 public constant USDC = IERC20(0x8AC76a51cc950d9822D68b83fE1Ad97B32Cd580d);

}

library Arbitrum {

    IPancakeUniversalRouter public constant PANCAKE_UNIVERSAL_ROUTER =
        IPancakeUniversalRouter(payable(0xFE6508f0015C778Bdcc1fB5465bA5ebE224C9912));
    IUniswapV3Factory public constant UNISWAP_V3_FACTORY = IUniswapV3Factory(0x1F98431c8aD98523631AE4a59f267346ea31F984);
    IUniswapUniversalRouter public constant UNISWAP_UNIVERSAL_ROUTER =
        IUniswapUniversalRouter(payable(0x5E325eDA8064b456f4781070C0738d849c824258));
    IUniswapV2Router public constant UNISWAP_V2_ROUTER =
        IUniswapV2Router(payable(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D));
    IUniswapV2Factory public constant UNISWAP_V2_FACTORY = IUniswapV2Factory(0xf1D7CC64Fb4452F05c498126312eBE29f30Fbcf9);
    // Tokens

}

library Base {

    IPancakeUniversalRouter public constant PANCAKE_UNIVERSAL_ROUTER =
        IPancakeUniversalRouter(payable(0xFE6508f0015C778Bdcc1fB5465bA5ebE224C9912));
    IUniswapV3Factory public constant UNISWAP_V3_FACTORY = IUniswapV3Factory(0x33128a8fC17869897dcE68Ed026d694621f6FDfD);

    IUniswapUniversalRouter public constant UNISWAP_UNIVERSAL_ROUTER =
        IUniswapUniversalRouter(payable(0x3fC91A3afd70395Cd496C647d5a6CC9D4B2b7FAD));
    IUniswapV2Factory public constant UNISWAP_V2_FACTORY = IUniswapV2Factory(0x8909Dc15e40173Ff4699343b6eB8132c65e18eC6);
    IUniswapV2Router public constant UNISWAP_V2_ROUTER =
        IUniswapV2Router(payable(0x4752ba5DBc23f44D87826276BF6Fd6b1C372aD24));

}

library Blast {

    IUniswapV3Factory public constant UNISWAP_V3_FACTORY = IUniswapV3Factory(0x792edAdE80af5fC680d96a2eD80A44247D2Cf6Fd);
    IUniswapV2Factory public constant UNISWAP_V2_FACTORY = IUniswapV2Factory(0x5C346464d33F90bABaf70dB6388507CC889C1070);
    IUniswapV2Router public constant UNISWAP_V2_ROUTER =
        IUniswapV2Router(payable(0xBB66Eb1c5e875933D44DAe661dbD80e5D9B03035));

}

library Avalanche {

    IUniswapV3Factory public constant UNISWAP_V3_FACTORY = IUniswapV3Factory(0x740b1c1de25031C31FF4fC9A62f554A55cdC1baD);
    IUniswapUniversalRouter public constant UNISWAP_UNIVERSAL_ROUTER =
        IUniswapUniversalRouter(payable(0x4Dae2f939ACf50408e13d58534Ff8c2776d45265));
    IUniswapV2Factory public constant UNISWAP_V2_FACTORY = IUniswapV2Factory(0x9e5A52f57b3038F1B8EeE45F28b3C1967e22799C);
    IUniswapV2Router public constant UNISWAP_V2_ROUTER =
        IUniswapV2Router(payable(0x4752ba5DBc23f44D87826276BF6Fd6b1C372aD24));
    IERC20 public constant NATIVE_ASSET = IERC20(address(0x0));
    // Tokens
    IERC20 public constant USDTe = IERC20(0xc7198437980c041c805A1EDcbA50c1Ce5db95118);
    IERC20 public constant USDt = IERC20(0x9702230A8Ea53601f5cD2dc00fDBc13d4dF4A8c7);
    IERC20 public constant USDCe = IERC20(0xA7D7079b0FEaD91F3e65f86E8915Cb59c1a4C664);
    IERC20 public constant USDC = IERC20(0xB97EF9Ef8734C71904D8002F8b6Bc66Dd9c48a6E);

}

library Polygon {

    IUniswapV3Factory public constant UNISWAP_V3_FACTORY = IUniswapV3Factory(0x1F98431c8aD98523631AE4a59f267346ea31F984);
    IUniswapUniversalRouter public constant UNISWAP_UNIVERSAL_ROUTER =
        IUniswapUniversalRouter(payable(0xec7BE89e9d109e7e3Fec59c222CF297125FEFda2));
    IUniswapV2Factory public constant UNISWAP_V2_FACTORY = IUniswapV2Factory(0x9e5A52f57b3038F1B8EeE45F28b3C1967e22799C);
    IUniswapV2Router public constant UNISWAP_V2_ROUTER =
        IUniswapV2Router(payable(0xedf6066a2b290C185783862C7F4776A2C8077AD1));

    // Tokens
    IERC20 public constant USDT = IERC20(0xc2132D05D31c914a87C6611C10748AEb04B58e8F);
    IERC20 public constant BNB = IERC20(0x3BA4c387f786bFEE076A58914F5Bd38d668B42c3);
    IERC20 public constant USDC = IERC20(0x2791Bca1f2de4661ED88A30C99A7a9449Aa84174);

}

library Optimism {

    IUniswapV3Factory public constant UNISWAP_V3_FACTORY = IUniswapV3Factory(0x1F98431c8aD98523631AE4a59f267346ea31F984);
    IUniswapUniversalRouter public constant UNISWAP_UNIVERSAL_ROUTER =
        IUniswapUniversalRouter(payable(0xCb1355ff08Ab38bBCE60111F1bb2B784bE25D7e8));
    IUniswapV2Factory public constant UNISWAP_V2_FACTORY = IUniswapV2Factory(0x0c3c1c532F1e39EdF36BE9Fe0bE1410313E074Bf);
    IUniswapV2Router public constant UNISWAP_V2_ROUTER =
        IUniswapV2Router(payable(0x4A7b5Da61326A6379179b40d00F57E5bbDC962c2));
    // Tokens
    IERC20 public constant USDT = IERC20(0x94b008aA00579c1307B0EF2c499aD98a8ce58e58);
    IERC20 public constant USDC = IERC20(0x7F5c764cBc14f9669B88837ca1490cCa17c31607);
    IERC20 public constant DAI = IERC20(0xDA10009cBd5D07dd0CeCc66161FC93D7c9000da1);

}

library Gnosis {

    // Tokens
    IERC20 public constant USDT = IERC20(0x4ECaBa5870353805a9F068101A40E0f32ed605C6);
    IERC20 public constant USDC = IERC20(0xDDAfbb505ad214D7b80b1f830fcCc89B60fb7A83);
    IERC20 public constant MATIC = IERC20(0x7122d7661c4564b7C6Cd4878B06766489a6028A2);
    IERC20 public constant UNI = IERC20(0x4537e328Bf7e4eFA29D05CAeA260D7fE26af9D74);
    IERC20 public constant LINK = IERC20(0xE2e73A1c69ecF83F464EFCE6A5be353a37cA09b2);

}

library Linea {

    IPancakeUniversalRouter public constant PANCAKE_UNIVERSAL_ROUTER =
        IPancakeUniversalRouter(payable(0xFE6508f0015C778Bdcc1fB5465bA5ebE224C9912));
    IERC20 public constant USDC = IERC20(0x176211869cA2b568f2A7D4EE941E073a821EE1ff);
    IERC20 public constant USDT = IERC20(0xA219439258ca9da29E9Cc4cE5596924745e12B93);

}

library RootStock {
// Tokens
}

library ZKSyncEra {
// Tokens
}

library Celo {

    IUniswapV3Factory public constant UNISWAP_V3_FACTORY = IUniswapV3Factory(0xAfE208a311B21f13EF87E33A90049fC17A7acDEc);
    IUniswapUniversalRouter public constant UNISWAP_UNIVERSAL_ROUTER =
        IUniswapUniversalRouter(payable(0x643770E279d5D0733F21d6DC03A8efbABf3255B4));
    // Tokens

}

library Scroll {
// Tokens
}

library FileCoin {
// Tokens
}

library BobaCoin {
// Tokens
}

library MoonBeam {
// Tokens
}

library Zora {
// Tokens
}
