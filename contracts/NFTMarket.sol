// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "contracts/IERC20Interface.sol";
import "contracts/IERC721Interface.sol";

contract NFTMarket{

    IERC20 public erc20Token;
    IERC721 public erc721Token;

    event List(uint tokenId,address sellPeople,uint amount);
    event BuyNFT(address buyer,uint tokenID,uint amount);

// tokenID 对应的  价格
    mapping (uint =>uint)public tokenPrice;

     constructor(IERC20 erc20,IERC721 erc721){
         erc20Token = erc20;
         erc721Token = erc721;
     }

    // 上架 NFT
     function list(uint tokenId,uint amount) external  returns (bool){
        require(tokenId!=0 && amount >0,"tokenId must !=0, amount must >0");
        require(erc721Token.ownerOf(tokenId)==msg.sender,"you are not owner");
        tokenPrice[tokenId] = amount;
        emit List(tokenId,msg.sender, amount);
        return true;
     }

//   买家购买NFT
     function buyNFT(uint tokenID, uint amount) external returns (bool){
        require(tokenID!=0 && amount >0,"tokenId must !=0, amount must >0");
        address NFTOwnerOf = erc721Token.ownerOf(tokenID);
        // 通过ERC20购买，先转账
        bool result = erc20Token.transferFrom(msg.sender, NFTOwnerOf, amount);
        if (!result){
            revert("transferFrom error");
        }
        //  ERC721进行交易转让 NFT
        erc721Token. safeTransferFrom(NFTOwnerOf, msg.sender, tokenID);
        // 交易后删除
        delete tokenPrice[tokenID];
        emit BuyNFT(msg.sender,tokenID,amount);

        return true;
     }

// 安全检查
// 1.检验是不是ERC20
// 2.检测 目标NFT是否上架
// 3.检测转账的金额是否大于等于NFT价格
// 成交逻辑
// 1.把钱给卖家
// 2.有多余的钱退回给买家
// 3.NFT 转让

     function tokensReceived(address from,uint amount,bytes calldata data) external returns (bool){
        require(msg.sender == address(erc20Token), "only erc20Token can call this function");
        // 将 bytes 还原成 uint256 的 tokenId
        uint256 tokenId = abi.decode(data, (uint256));
        require(tokenPrice[tokenId]!=0,"Market: token not for sale");
        require(amount>=tokenPrice[tokenId]," Market: insufficient amount");
        // 卖家
        address seller = erc721Token.ownerOf(tokenId); 
        // 把 NFT的钱转给卖家
        erc20Token.transfer(seller,tokenPrice[tokenId]);
        // 多余的钱退给买家
        if (amount>tokenPrice[tokenId]){
            erc20Token.transfer(from,amount-tokenPrice[tokenId]);
        }
        // NFT 转让
        erc721Token.safeTransferFrom(seller,from,tokenId);
        // 删除 NFT 价格
        delete tokenPrice[tokenId];
        emit BuyNFT(from,tokenId,amount);
        return true;
     }
}




