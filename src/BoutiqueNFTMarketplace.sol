// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {BoutiqueNFT} from "./BoutiqueNFT.sol";

event NFTAdded(uint indexed tokenId, uint price, address seller);

contract BoutiqueNFTMarketplace {
    BoutiqueNFT nft;
    address owner;

    mapping(uint tokenId => uint price) public items;
    mapping(uint tokenId => address owner) public owners;

    uint public constant FEE = 1;

    constructor(address _token){
        owner = msg.sender;
        nft = BoutiqueNFT(_token);
    }

    function add(uint _tokenId, uint _price) external {
        address currentOwner = nft.ownerOf(_tokenId);

        require(currentOwner == msg.sender);

        require(
            nft.isApprovedForAll(currentOwner, address(this)) ||
            nft.getApproved(_tokenId) == address(this), "invalid approval"
        );

        require(_price > 0);

        items[_tokenId] = _price;
        owners[_tokenId] = currentOwner;
        
        emit NFTAdded(_tokenId, _price, currentOwner);
    }

    function buy(uint _tokenId) external payable {
        require(nft.ownerOf(_tokenId) != address(0));
        require(items[_tokenId] > 0);

        address currentOwner = owners[_tokenId];

        uint price = items[_tokenId];

        require(msg.value == price);
        nft.safeTransferFrom(currentOwner, msg.sender, _tokenId);

        delete items[_tokenId];
        delete owners[_tokenId];

        (bool ok,) = currentOwner.call{value: (price - (price * FEE)/100)}("");
        require(ok);
    }

    function withdrawal(address payable _to) external {
        require(msg.sender == owner, "not an owner");

       _to.transfer(address(this).balance);
    }
}