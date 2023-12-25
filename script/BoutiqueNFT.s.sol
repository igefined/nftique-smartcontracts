// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import {BoutiqueNFT} from "../src/BoutiqueNFT.sol";

contract BoutiqueNFTDeploy is Script {
    function run() external {
        address to = 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266;
        uint deployerPrivateKey = vm.envUint("PRIVATE_KEY");

        vm.startBroadcast(deployerPrivateKey);

        BoutiqueNFT token = new BoutiqueNFT();
        token.safeMint(to);

        payable(to).transfer(1 ether);

        vm.stopBroadcast();
    }
}