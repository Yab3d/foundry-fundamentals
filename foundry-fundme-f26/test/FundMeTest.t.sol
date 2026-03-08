// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../src/FundMe.sol";
import {DeployFundMe} from "../script/DeployFundMe.s.sol";

contract FundMeTest is Test {
    FundMe fundme;
    address USER = makeAddr("user");
    uint256 constant SEND_VALUE = 0.1 ether;
    uint256 constant STARTING_BALANCE = 10 ether;

    function setUp() external {
        // fundme = new FundMe(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        DeployFundMe deployfundme = new DeployFundMe();
        fundme = deployfundme.run();
        vm.deal(USER, STARTING_BALANCE);
    }

    function testMinimumDollarIsFive() public view {
        assertEq(fundme.MINIMUM_USD(), 5e18);
    }

    function testownerismessagesender() public view {
        console.log("Owner is: %s", fundme.i_owner());
        console.log("Sender is: %s", msg.sender);
        assertEq(fundme.i_owner(), msg.sender);
    }

    function testpricefeedisaccurate() public view {
        uint256 version = fundme.getVersion();
        assertEq(version, 4);
    }

    function testfundfailswithoutenougheth() public {
        vm.expectRevert();
        fundme.fund();
    }

    function testfundupdatesfundDataStructure() public {
        vm.prank(USER); // THE NEXT TX WILL SEND BY THE USER

        fundme.fund{value: SEND_VALUE}();
        uint256 amountFunded = fundme.getAddressToAmountFunded(USER);
        assertEq(amountFunded, SEND_VALUE);
    }
}
