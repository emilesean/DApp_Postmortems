// SPDX-License-Identifier: UNLICENSED

pragma solidity >=0.7.0 <0.9.0;

interface IMasterChef {

    event Deposit(address indexed user, uint256 indexed pid, uint256 amount);
    event EmergencyWithdraw(address indexed user, uint256 indexed pid, uint256 amount);
    event Withdraw(address indexed user, uint256 indexed pid, uint256 amount);
    event WithdrawChange(address indexed user, address indexed token, uint256 change);

    function BONUS_MULTIPLIER() external view returns (uint256);

    function WETH() external view returns (address);

    function _become(address proxy) external;

    function _totalClaimed(address, uint256) external view returns (uint256);

    function _whitelist(address) external view returns (address);

    function add(uint256 _allocPoint, address _lpToken, uint256 _pooltype, address _ticket, bool _withUpdate)
        external;

    function admin() external view returns (address);

    function bonusEndBlock() external view returns (uint256);

    function check_vip_limit(uint256 ticket_level, uint256 ticket_count, uint256 amount)
        external
        view
        returns (uint256 allowed, uint256 overflow);

    function claimFeeRate() external view returns (uint256);

    function deposit(uint256 _pid, uint256 _amount) external;

    function depositByAddLiquidity(uint256 _pid, address[2] memory _tokens, uint256[2] memory _amounts) external;

    function depositByAddLiquidityETH(uint256 _pid, address _token, uint256 _amount) external payable;

    function depositSingle(uint256 _pid, address _token, uint256 _amount, address[][2] memory paths, uint256 _minTokens)
        external
        payable;

    function depositSingleTo(
        address _user,
        uint256 _pid,
        address _token,
        uint256 _amount,
        address[][2] memory paths,
        uint256 _minTokens
    ) external payable;

    function depositTo(uint256 _pid, uint256 _amount, address _user) external;

    function deposit_all_tickets(address ticket) external;

    function dev(address _devaddr) external;

    function devaddr() external view returns (address);

    function emergencyWithdraw(uint256 _pid) external;

    function farmPercent(uint256) external view returns (uint8);

    function feeDistributor() external view returns (address);

    function getMultiplier(uint256 _from, uint256 _to) external view returns (uint256);

    function implementation() external view returns (address);

    function initialize(
        address _t42,
        address _treasury,
        address _feeDistributor,
        address _devaddr,
        uint256 _bonusEndBlock,
        address _WETH,
        address _paraRouter
    ) external;

    function massUpdatePools() external;

    function migrate(uint256 _pid) external;

    function migrator() external view returns (address);

    function onERC721Received(address, address, uint256, bytes memory) external returns (bytes4);

    function paraRouter() external view returns (address);

    function pendingAdmin() external view returns (address);

    function pendingImplementation() external view returns (address);

    function pendingT42(uint256 _pid, address _user) external view returns (uint256 pending, uint256 fee);

    function poolInfo(uint256)
        external
        view
        returns (
            address lpToken,
            uint256 allocPoint,
            uint256 lastRewardBlock,
            uint256 accT42PerShare,
            address ticket,
            uint256 pooltype
        );

    function poolLength() external view returns (uint256);

    function poolsTotalDeposit(uint256) external view returns (uint256);

    function set(uint256 _pid, uint256 _allocPoint, bool _withUpdate) external;

    function setClaimFeeRate(uint256 newRate) external;

    function setFarmPercents(uint8[] memory percents) external;

    function setFeeDistributor(address _newAddress) external;

    function setMigrator(address _migrator) external;

    function setRouter(address _router) external;

    function setT42(address _t42) external;

    function setTreasury(address _treasury) external;

    function setWhitelist(address _whtie, address accpeter) external;

    function setWithdrawFeeRate(uint256 newRate) external;

    function startBlock() external view returns (uint256);

    function t42() external view returns (address);

    function t42PerBlock(uint8 index) external view returns (uint256);

    function ticket_staked_array(address who, address ticket) external view returns (uint256[] memory);

    function ticket_staked_count(address who, address ticket) external view returns (uint256);

    function ticket_stakes(address, address, uint256) external view returns (uint256);

    function totalAllocPoint() external view returns (uint256);

    function totalClaimed(address _user, uint256 pooltype, uint256 index) external view returns (uint256);

    function treasury() external view returns (address);

    function updatePool(uint256 _pid) external;

    function userChange(address, address) external view returns (uint256);

    function userInfo(uint256, address) external view returns (uint256 amount, uint256 rewardDebt);

    function withdraw(uint256 _pid, uint256 _amount) external;

    function withdrawAndRemoveLiquidity(uint256 _pid, uint256 _amount, bool isBNB) external;

    function withdrawChange(address[] memory tokens) external;

    function withdrawFeeRate() external view returns (uint256);

    function withdrawSingle(address tokenOut, uint256 _pid, uint256 _amount, address[][2] memory paths) external;

    function withdraw_tickets(uint256 _pid, uint256 tokenId) external;

}
