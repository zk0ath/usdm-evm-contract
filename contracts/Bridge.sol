// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract Bridge {
    address public owner;
    IERC20 public usdcToken;

    struct BridgeTransfer {
        address sender;
        uint256 amount;
        bool completed;
    }

    mapping(uint256 => BridgeTransfer) public transfers;
    mapping(address => uint256) public balances;
    mapping(uint256 => bool) public processedTransactions;

    uint256 public nextTransferId;

    event Deposit(address indexed sender, uint256 amount, uint256 transferId);
    event TransferCompleted(uint256 transferId);
    event ReleaseTokens(
        address indexed recipient,
        uint256 amount,
        uint256 transactionId
    );

    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }

    constructor(address _usdcTokenAddress) {
        owner = msg.sender;
        usdcToken = IERC20(_usdcTokenAddress);
    }

    function deposit(uint256 amount) public {
        require(
            usdcToken.transferFrom(msg.sender, address(this), amount),
            "Transfer failed"
        );
        transfers[nextTransferId] = BridgeTransfer(msg.sender, amount, false);
        emit Deposit(msg.sender, amount, nextTransferId);
        nextTransferId++;
    }

    function completeTransfer(uint256 transferId) public onlyOwner {
        BridgeTransfer storage transfer = transfers[transferId];
        require(!transfer.completed, "Transfer already completed");
        transfer.completed = true;
        emit TransferCompleted(transferId);
    }

    function releaseTokens(
        address recipient,
        uint256 amount,
        uint256 transactionId
    ) public onlyOwner {
        require(
            !processedTransactions[transactionId],
            "Transaction already processed"
        );
        processedTransactions[transactionId] = true;
        require(usdcToken.transfer(recipient, amount), "Transfer failed");
        emit ReleaseTokens(recipient, amount, transactionId);
    }
}
