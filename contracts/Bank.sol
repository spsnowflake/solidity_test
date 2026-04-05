// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

contract Bank{
    // 事件，打印本次转账 地址和存款金额
    event Received(address, uint);
    mapping (address=>uint)public savePrice;
    address public owner ;
    address[3] public top3User = [address(0),address(0),address(0)];

// 合约的存款
    // uint counter;

    constructor(){
        owner = msg.sender;
    }

    function getTop3User()public view returns (address[3] memory){
        return top3User;
    }


// 只有管理员可以通过这个方法提取资金
    function withdraw()public {
        require(msg.sender == owner);
        (bool success, ) = payable(owner).call{value:address(this).balance}("");
        require(success, "Withdraw failed");
    }

    function saveMoney()payable public  {
        savePrice[msg.sender] += msg.value;
        for (uint8 i = 0;i<3;i++){
            if (savePrice[msg.sender]>savePrice[top3User[i]]){
                top3User[i] = msg.sender;
                break;
            }
        }
            
    }

    receive() external payable { 
        emit Received(msg.sender, msg.value);
    }

}





