// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import "contracts/Bigbank.sol";

contract Admin {


    address internal owner;

    constructor() {
        owner = msg.sender; // 部署者是 Admin 合约的管理员
    }

    function getOwner()public view returns (address){
        return owner;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Admin: Not the owner");
        _;
    }

    function adminWithdraw(IBank bank)public onlyOwner {
        bank.withdraw();
    }

    receive() external payable {}

}






