// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "forge-std/console.sol";
import {Test} from "forge-std/Test.sol";
import {Strings} from "@openzeppelin/contracts/utils/Strings.sol";
import {IERC721Receiver} from "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";

import {BoutiqueNFT} from "../src/BoutiqueNFT.sol";

contract BoutiqueNFTTest is Test, IERC721Receiver {
    using Strings for uint256;

    BoutiqueNFT token;

    address self;
    address bob = makeAddr("bob");
    address alice = makeAddr("alice");

    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);

    function setUp() public {
        token = new BoutiqueNFT();
        self = address(this);
    }

    function testName() external {
        assertEq(token.name(), "BoutiqueNFT");
    }

    function testSafeMint() external {
        uint tokenId = 1;

        vm.expectEmit(true, true, true, false, address(token));
        emit Transfer(address(0), self, tokenId);

        token.safeMint(self);
        assertEq(token.balanceOf(self), 1);
        assertEq(token.tokenURI(tokenId), fullUriId(tokenId));
    }

    function testSafeTransferFrom() external {
        uint tokenId = 1;

        token.safeMint(self);
        token.approve(bob, tokenId);
        
        vm.prank(bob);
        token.transferFrom(self, alice, tokenId);
        assertEq(token.balanceOf(self), 0);
        assertEq(token.ownerOf(tokenId), alice);
    }

    function testBurn() external {
        uint tokenId = 1;

        token.safeMint(self);
        assertEq(token.balanceOf(self), 1);

        token.burn(tokenId);
        assertEq(token.balanceOf(self), 0);
    }

    function fullUriId(uint256 tokenId) private pure returns (string memory){
        return string.concat("https://nftique.s3.amazonaws.com", tokenId.toString(), ".jpg");
    }

    function onERC721Received(address, address, uint256, bytes calldata) external pure returns (bytes4) {
            return IERC721Receiver.onERC721Received.selector;
    }
}
