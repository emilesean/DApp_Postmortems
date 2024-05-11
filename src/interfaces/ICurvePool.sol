// SPDX-License-Identifier: UNLICENSED

pragma solidity >=0.7.0 <0.9.0;

interface ICurvePool {
    event AddLiquidity(
        address indexed provider,
        uint256[4] token_amounts,
        uint256[4] fees,
        uint256 invariant,
        uint256 token_supply
    );
    event CommitNewAdmin(uint256 indexed deadline, address indexed admin);
    event CommitNewParameters(
        uint256 indexed deadline,
        uint256 A,
        uint256 fee,
        uint256 admin_fee
    );
    event NewAdmin(address indexed admin);
    event NewParameters(uint256 A, uint256 fee, uint256 admin_fee);
    event RemoveLiquidity(
        address indexed provider,
        uint256[4] token_amounts,
        uint256[4] fees,
        uint256 token_supply
    );
    event RemoveLiquidityImbalance(
        address indexed provider,
        uint256[4] token_amounts,
        uint256[4] fees,
        uint256 invariant,
        uint256 token_supply
    );
    event TokenExchange(
        address indexed buyer,
        int128 sold_id,
        uint256 tokens_sold,
        int128 bought_id,
        uint256 tokens_bought
    );
    event TokenExchangeUnderlying(
        address indexed buyer,
        int128 sold_id,
        uint256 tokens_sold,
        int128 bought_id,
        uint256 tokens_bought
    );

    function A() external view returns (uint256 out);
    function add_liquidity(
        uint256[4] memory amounts,
        uint256 min_mint_amount
    ) external;
    function admin_actions_deadline() external view returns (uint256 out);
    function admin_fee() external view returns (uint256 out);
    function apply_new_parameters() external;
    function apply_transfer_ownership() external;
    function balances(int128 arg0) external view returns (uint256 out);
    function calc_token_amount(
        uint256[4] memory amounts,
        bool deposit
    ) external view returns (uint256 out);
    function coins(int128 arg0) external view returns (address out);
    function commit_new_parameters(
        uint256 amplification,
        uint256 new_fee,
        uint256 new_admin_fee
    ) external;
    function commit_transfer_ownership(address _owner) external;
    function exchange(int128 i, int128 j, uint256 dx, uint256 min_dy) external;
    function exchange_underlying(
        int128 i,
        int128 j,
        uint256 dx,
        uint256 min_dy
    ) external;
    function fee() external view returns (uint256 out);
    function future_A() external view returns (uint256 out);
    function future_admin_fee() external view returns (uint256 out);
    function future_fee() external view returns (uint256 out);
    function future_owner() external view returns (address out);
    function get_dx(
        int128 i,
        int128 j,
        uint256 dy
    ) external view returns (uint256 out);
    function get_dx_underlying(
        int128 i,
        int128 j,
        uint256 dy
    ) external view returns (uint256 out);
    function get_dy(
        int128 i,
        int128 j,
        uint256 dx
    ) external view returns (uint256 out);
    function get_dy_underlying(
        int128 i,
        int128 j,
        uint256 dx
    ) external view returns (uint256 out);
    function get_virtual_price() external view returns (uint256 out);
    function kill_me() external;
    function owner() external view returns (address out);
    function remove_liquidity(
        uint256 _amount,
        uint256[4] memory min_amounts
    ) external;
    function remove_liquidity_imbalance(
        uint256[4] memory amounts,
        uint256 max_burn_amount
    ) external;
    function revert_new_parameters() external;
    function revert_transfer_ownership() external;
    function transfer_ownership_deadline() external view returns (uint256 out);
    function underlying_coins(int128 arg0) external view returns (address out);
    function unkill_me() external;
    function withdraw_admin_fees() external;
}
