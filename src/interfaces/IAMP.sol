// SPDX-License-Identifier: UNLICENSED

pragma solidity >=0.7.0 <0.9.0;

interface IAMP {

    event Approval(address indexed owner, address indexed spender, uint256 value);
    event ApprovalByPartition(bytes32 indexed partition, address indexed owner, address indexed spender, uint256 value);
    event AuthorizedOperator(address indexed operator, address indexed tokenHolder);
    event AuthorizedOperatorByPartition(
        bytes32 indexed partition, address indexed operator, address indexed tokenHolder
    );
    event ChangedPartition(bytes32 indexed fromPartition, bytes32 indexed toPartition, uint256 value);
    event CollateralManagerRegistered(address collateralManager);
    event Minted(address indexed operator, address indexed to, uint256 value, bytes data);
    event OwnerUpdate(address indexed oldValue, address indexed newValue);
    event OwnershipTransferAuthorization(address indexed authorizedAddress);
    event PartitionStrategySet(bytes4 flag, string name, address indexed implementation);
    event RevokedOperator(address indexed operator, address indexed tokenHolder);
    event RevokedOperatorByPartition(bytes32 indexed partition, address indexed operator, address indexed tokenHolder);
    event Swap(address indexed operator, address indexed from, uint256 value);
    event Transfer(address indexed from, address indexed to, uint256 value);
    event TransferByPartition(
        bytes32 indexed fromPartition,
        address operator,
        address indexed from,
        address indexed to,
        uint256 value,
        bytes data,
        bytes operatorData
    );

    function allowance(address _owner, address _spender) external view returns (uint256);

    function allowanceByPartition(bytes32 _partition, address _owner, address _spender)
        external
        view
        returns (uint256);

    function approve(address _spender, uint256 _value) external returns (bool);

    function approveByPartition(bytes32 _partition, address _spender, uint256 _value) external returns (bool);

    function assumeOwnership() external;

    function authorizeOperator(address _operator) external;

    function authorizeOperatorByPartition(bytes32 _partition, address _operator) external;

    function authorizeOwnershipTransfer(address _authorizedAddress) external;

    function authorizedNewOwner() external view returns (address);

    function balanceOf(address _tokenHolder) external view returns (uint256);

    function balanceOfByPartition(bytes32 _partition, address _tokenHolder) external view returns (uint256);

    function canImplementInterfaceForAddress(bytes32 _interfaceHash, address) external view returns (bytes32);

    function collateralManagers(uint256) external view returns (address);

    function decimals() external pure returns (uint8);

    function decreaseAllowance(address _spender, uint256 _subtractedValue) external returns (bool);

    function decreaseAllowanceByPartition(bytes32 _partition, address _spender, uint256 _subtractedValue)
        external
        returns (bool);

    function defaultPartition() external view returns (bytes32);

    function granularity() external pure returns (uint256);

    function increaseAllowance(address _spender, uint256 _addedValue) external returns (bool);

    function increaseAllowanceByPartition(bytes32 _partition, address _spender, uint256 _addedValue)
        external
        returns (bool);

    function isCollateralManager(address _collateralManager) external view returns (bool);

    function isOperator(address _operator, address _tokenHolder) external view returns (bool);

    function isOperatorForCollateralManager(bytes32 _partition, address _operator, address _collateralManager)
        external
        view
        returns (bool);

    function isOperatorForPartition(bytes32 _partition, address _operator, address _tokenHolder)
        external
        view
        returns (bool);

    function isPartitionStrategy(bytes4 _prefix) external view returns (bool);

    function name() external view returns (string memory);

    function owner() external view returns (address);

    function partitionStrategies(uint256) external view returns (bytes4);

    function partitionsOf(address _tokenHolder) external view returns (bytes32[] memory);

    function registerCollateralManager() external;

    function revokeOperator(address _operator) external;

    function revokeOperatorByPartition(bytes32 _partition, address _operator) external;

    function setPartitionStrategy(bytes4 _prefix, address _implementation) external;

    function swap(address _from) external;

    function swapToken() external view returns (address);

    function swapTokenGraveyard() external view returns (address);

    function symbol() external view returns (string memory);

    function totalPartitions() external view returns (bytes32[] memory);

    function totalSupply() external view returns (uint256);

    function totalSupplyByPartition(bytes32) external view returns (uint256);

    function transfer(address _to, uint256 _value) external returns (bool);

    function transferByPartition(
        bytes32 _partition,
        address _from,
        address _to,
        uint256 _value,
        bytes memory _data,
        bytes memory _operatorData
    ) external returns (bytes32);

    function transferFrom(address _from, address _to, uint256 _value) external returns (bool);

}
