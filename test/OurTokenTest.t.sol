// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test} from "forge-std/Test.sol";
import {DeployOurToken} from "../script/DeployOurToken.s.sol";
import {OurToken} from "../src/OurToken.sol";
import {console} from "forge-std/console.sol";

contract OurTokenTest is Test {
    OurToken public ourToken;
    DeployOurToken public deployer;

    address bob = makeAddr("Bob");
    address alice = makeAddr("Alice");

    uint256 public constant STARTING_BALANCE = 100 ether;

    function setUp() public {
        deployer = new DeployOurToken();
        ourToken = deployer.run();

        vm.prank(msg.sender);
        ourToken.transfer(bob, STARTING_BALANCE);
    }

    function testBobBalance() public view {
        assertEq(STARTING_BALANCE, ourToken.balanceOf(bob));
    }

    function testAllowancesWorks() public {
        // assertEq(0, ourToken.allowance(bob, alice));
        uint256 initialAllowance = 1000;

        // Bob approves Alice to spend tokens on her behalf
        vm.prank(bob);
        ourToken.approve(alice, initialAllowance);

        uint256 transferAmount = 500;

        vm.prank(alice);
        ourToken.transferFrom(bob, alice, transferAmount);

        assertEq(ourToken.balanceOf(alice), transferAmount);
        assertEq(ourToken.balanceOf(bob), STARTING_BALANCE - transferAmount);
    }

    function testTransfer() public {
        // Assign some tokens to Bob first
        uint256 transferAmount = 50 ether;

        // Bob transfers some tokens to Alice
        vm.prank(bob);
        ourToken.transfer(alice, transferAmount);

        // Verify balances
        assertEq(ourToken.balanceOf(bob), 50 ether);
        assertEq(ourToken.balanceOf(alice), transferAmount);
    }

    function testTransferInsufficientFunds() public {
        uint256 balance = ourToken.balanceOf(bob);

        // Try transferring more than balance
        vm.prank(bob);
        vm.expectRevert();
        ourToken.transfer(alice, balance + 1);
    }

    function testTransferFrom() public {
        uint256 allowanceAmount = 10 ether;

        // User1 approves User2 to spend tokens
        vm.prank(bob);
        ourToken.approve(alice, allowanceAmount);

        // User2 transfers tokens from User1 to themselves
        vm.prank(alice);
        ourToken.transferFrom(bob, alice, 7 ether);

        // Check balances and remaining allowance
        assertEq(ourToken.balanceOf(bob), 93 ether);
        assertEq(ourToken.balanceOf(alice), 7 ether);
        assertEq(ourToken.allowance(bob, alice), 3 ether);
    }
}
