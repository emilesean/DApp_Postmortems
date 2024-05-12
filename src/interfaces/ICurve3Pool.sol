// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;

interface ICurve3Pool {

    event Approval(address indexed _owner, address indexed _spender, uint256 _value);
    event SetName(string old_name, string old_symbol, string name, string symbol, address owner, uint256 time);
    event Transfer(address indexed _from, address indexed _to, uint256 _value);

    function allowance(address arg0, address arg1) external view returns (uint256);
    function approve(address _spender, uint256 _value) external returns (bool);
    function balanceOf(address arg0) external view returns (uint256);
    function burnFrom(address _to, uint256 _value) external returns (bool);
    function decimals() external view returns (uint256);
    function decreaseAllowance(address _spender, uint256 _subtracted_value) external returns (bool);
    function increaseAllowance(address _spender, uint256 _added_value) external returns (bool);
    function mint(address _to, uint256 _value) external returns (bool);
    function mint_relative(address _to, uint256 frac) external returns (uint256);
    function minter() external view returns (address);
    function name() external view returns (string memory);
    function set_minter(address _minter) external;
    function set_name(string memory _name, string memory _symbol) external;
    function symbol() external view returns (string memory);
    function totalSupply() external view returns (uint256);
    function transfer(address _to, uint256 _value) external returns (bool);
    function transferFrom(address _from, address _to, uint256 _value) external returns (bool);

}
