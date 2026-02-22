// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../src/FundMe.sol";

contract FundMeTest is Test {
    FundMe fundme;

    function setUp() external {
        fundme = new FundMe();
    }

    function testMinimumDollarIsFive() public view {
        assertEq(fundme.MINIMUM_USD(), 5e18);
    }

    function testownerismessagesender() public view {
        console.log("Owner is: %s", fundme.i_owner());
        console.log("Sender is: %s", msg.sender);
        assertEq(fundme.i_owner(), address(this));
    }
}
