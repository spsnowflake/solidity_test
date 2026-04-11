// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


interface IERC20 {
    function balanceOf(address _owner) external  view returns (uint256 balance);
    function transfer(address _to, uint256 _value) external returns (bool success);
    function transferFrom(address _from, address _to, uint256 _value) external returns (bool success);
    function approve(address _spender, uint256 _value) external returns (bool success);
    function allowance(address _owner, address _spender) external view returns (uint256 remaining);

}

contract TokenBank {
    // 一开始就固定币种
    IERC20 public immutable erc20_address;
    constructor(IERC20 erc20_token){
        erc20_address = erc20_token;
    }

    event Deposit(address, uint);
    event Withdraw(address, uint);
    mapping (address => uint) public  balances;

// 用户存钱
    function deposit(uint amount) external  {
        require(amount >0,"amount must >0");
        bool result = erc20_address.transferFrom(msg.sender,address(this),amount);
        require(result,"transferFrom is false");
        balances[msg.sender] += amount;
       
    
        emit Deposit(msg.sender,amount);
    }

// 用户取钱
    function withdraw(uint amount) external {
        require(amount >0,"amount must >0");
        require(amount <= balances[msg.sender],"amount must <= balances[msg.sender]");
        // 先扣除此合约的余额，再执行转账
        balances[msg.sender] -= amount;
        bool result = erc20_address.transfer(msg.sender,amount);
        require(result,"transfer is false");
        emit Withdraw(msg.sender,amount);

    }

}


