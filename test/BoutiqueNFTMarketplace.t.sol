// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "forge-std/console.sol";
import {Test} from "forge-std/Test.sol";

import {BoutiqueNFT} from "../src/BoutiqueNFT.sol";
import {BoutiqueNFTMarketplace} from "../src/BoutiqueNFTMarketplace.sol";

contract BoutiqueNFTMarketplaceTest is Test {
    BoutiqueNFT nft;
    BoutiqueNFTMarketplace shop;

    address bob = makeAddr("bob");
    address alice = makeAddr("alice");

    function setUp() public {
        nft = new BoutiqueNFT();
        shop = new BoutiqueNFTMarketplace(address(nft));

        nft.safeMint(alice);
    }

    function testWithdrawal() external {
        shop.withdrawal(payable(bob));
        assertEq(address(shop).balance, 0);
    }
}
