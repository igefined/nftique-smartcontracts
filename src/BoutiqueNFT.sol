// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {ERC721Burnable} from "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";

contract BoutiqueNFT is ERC721, ERC721Burnable {
    uint private _nextTokenId = 1;

    constructor() ERC721("BoutiqueNFT", "BFT"){}

    function safeMint(address to) public {
        uint tokenId = _nextTokenId++;

        _safeMint(to, tokenId);
    }

    function tokenURI(uint256 tokenId) public view override returns (string memory){
        string memory fullURI = super.tokenURI(tokenId);

        return string.concat(fullURI, ".jpg");
    }

    function _baseURI() internal pure override returns (string memory){
        return "https://nftique.s3.amazonaws.com";
    }
}