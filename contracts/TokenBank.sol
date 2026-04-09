// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract TokenBank {

    constructor(uint total){
        balances[msg.sender] = total;
    }

    event Received(address, uint);

    mapping (address => uint) public  balances;

    function deposit(uint amount) external  {
        require(amount >0,"amount must >0");
        balances[msg.sender] = amount;
        emit Received(msg.sender,amount);
    }

    function withdraw(uint amount) external {
        require(amount >0,"amount must >0");
        require(amount <= balances[msg.sender],"amount must <= balances[msg.sender]");
        balances[msg.sender] -= amount;
    }

}


