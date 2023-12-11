// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IERC20 {
    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool);

    function balanceOf(address account) external view returns (uint256);
}

contract ReceiveUSDC {
    IERC20 public usdcToken;

    mapping(address => uint256) balances;

    event Received(address sender, uint256 amount);

    constructor(address _usdcAddress) {
        usdcToken = IERC20(_usdcAddress);
    }

    function receiveUSDC(uint256 amount) external {
        require(
            usdcToken.transferFrom(msg.sender, address(this), amount),
            "Transfer failed"
        );
        balances[msg.sender] += amount;
        emit Received(msg.sender, amount);
    }

    function getBalance() public view returns (uint256) {
        return usdcToken.balanceOf(address(this));
    }

    function getBalanceOnContract() public view returns (uint256) {
        return balances[msg.sender];
    }
}
