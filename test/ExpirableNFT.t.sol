// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.11;

import "forge-std/Test.sol";
import "../src/ExpirableNFT.sol";

import "../src/ExpireNFT.sol";

contract ExpirableNFTTest is Test {
    ExpirableNFT public expirableNFT;

    address minter = vm.addr(0x1);

    function setUp() public {
        vm.startPrank(minter);
        expirableNFT = new ExpirableNFT();
    }

    function testMint() public {
        expirableNFT.mint(1);
        assertEq(expirableNFT.ownerOf(1), minter);
        console.log("ExpireTime: ", expirableNFT.expireTime(1));
    }

    function testMint2() public {
        vm.warp(200);
        expirableNFT.mint(2);
        assertEq(expirableNFT.ownerOf(2), minter);
        console.log("ExpireTime: ", expirableNFT.expireTime(2));
    }
}
