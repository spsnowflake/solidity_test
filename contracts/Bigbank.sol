// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import "contracts/Bank.sol";

interface IBank {
    function getTop3User() view external  returns (address[3] memory);

    function withdraw()external ;

    // function saveMoney()payable external ;
    receive() external payable;
}

contract Bigbank is Bank{

    modifier limitSavePrice(){
        require(msg.value >0.001 ether,"Bank: Min deposit 0.001 ETH");
        _;
    }

    function saveMoney() public payable override limitSavePrice{
        super.saveMoney();
    }

    modifier onlyOwner(){
        require(owner == msg.sender, "not owner!");
        _;
    }

    function changeAdmin(address newAdmin) public onlyOwner{
        owner = newAdmin;
    }

}




