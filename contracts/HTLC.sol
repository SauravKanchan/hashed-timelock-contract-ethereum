// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

// @title Hashed Time Lock Contract
// @description Used for Atomic swaps, i.e exchanging funds across different blockchain
contract HTLC {

    event HTLCNew(
        bytes32 indexed contractId,
        address indexed sender,
        address indexed receiver,
        address tokenContract,
        uint256 amount,
        bytes32 hashlock,
        uint256 timelock
    );

    event HTLCWithdraw(bytes32 indexed contractId);
    event HTLCRefund(bytes32 indexed contractId);

    struct LockContract {
        address sender;
        address receiver;
        address tokenContract;
        uint256 amount;
        bytes32 hashlock;
        // locked UNTIL this time. Unit depends on consensus algorithm.
        // PoA, PoA and IBFT all use seconds. But Quorum Raft uses nano-seconds
        uint256 timelock;
        bool withdrawn;
        bool refunded;
        bytes32 password;
    }

    modifier tokensTransferable(
        address _token,
        address _sender,
        uint256 _amount
    ) {
        require(_amount > 0, "token amount must be > 0");
        require(ERC20(_token).allowance(_sender, address(this)) >= _amount, "token allowance must be >= amount");
        _;
    }

    modifier futureTimelock(uint256 _time) {
        // only requirement is the timelock time is after the last blocktime (block.timestamp).
        // probably want something a bit further in the future then this.
        // but this is still a useful sanity check:
        require(_time > block.timestamp, "timelock time must be in the future");
        _;
    }

    mapping(bytes32 => LockContract) public contracts;

    function newContract(
        address _receiver,
        bytes32 _hashlock,
        uint256 _timelock,
        address _tokenContract,
        uint256 _amount
    )
        external
        tokensTransferable(_tokenContract, msg.sender, _amount)
        futureTimelock(_timelock)
        returns (bytes32 contractId)
    {
        contractId = sha256(abi.encodePacked(msg.sender, _receiver, _tokenContract, _amount, _hashlock, _timelock));

        // Reject if a contract already exists with the same parameters. The
        // sender must change one of these parameters (ideally providing a
        // different _hashlock).
        if (haveContract(contractId)) revert("Contract already exists");

        // This contract becomes the temporary owner of the tokens
        if (!ERC20(_tokenContract).transferFrom(msg.sender, address(this), _amount))
            revert("transferFrom sender to this failed");

        contracts[contractId] = LockContract(
            msg.sender,
            _receiver,
            _tokenContract,
            _amount,
            _hashlock,
            _timelock,
            false,
            false,
            0x0
        );

        emit HTLCNew(contractId, msg.sender, _receiver, _tokenContract, _amount, _hashlock, _timelock);
    }

    /**
     * @dev Is there a contract with id _contractId.
     * @param _contractId Id into contracts mapping.
     */
    function haveContract(bytes32 _contractId) internal view returns (bool exists) {
        exists = (contracts[_contractId].sender != address(0));
    }
}
