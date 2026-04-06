// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import "contracts/Bigbank.sol";

contract Admin {


    address internal owner;

    function adminWithdraw(IBank bank)public {
        bank.withdraw();
    }

}






