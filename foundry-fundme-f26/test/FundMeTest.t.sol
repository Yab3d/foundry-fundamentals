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
    uint256 constant GAS_PRICE = 1;

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
        console.log("Owner is: %s", fundme.getOwner());
        console.log("Sender is: %s", msg.sender);
        assertEq(fundme.getOwner(), msg.sender);
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

    function testAddsFunderToArrayOfFunders() public {
        vm.prank(USER);
        fundme.fund{value: SEND_VALUE}();
        address funder = fundme.getFunded(0);
        assertEq(funder, USER);
    }

    modifier funded() {
        vm.prank(USER);
        fundme.fund{value: SEND_VALUE}();
        _;
    }

    function testOnlyOwnerCanWithdraw() public funded {
        vm.prank(USER);
        vm.expectRevert();
        fundme.withdraw();
    }

    function testWithDrawWithASingleFunder() public funded {
        //Arrange

        uint256 startingownerbalance = fundme.getOwner().balance;
        uint256 startingFundmebalance = address(fundme).balance;

        //Act

        vm.prank(fundme.getOwner());
        fundme.withdraw();

        //assert
        uint256 endingownerbalance = fundme.getOwner().balance;
        uint256 endingfundmebalance = address(fundme).balance;
        assertEq(endingfundmebalance, 0);
        assertEq(
            startingFundmebalance + startingownerbalance,
            endingownerbalance
        );
    }

    function testWithdrawFromMultipleFunders() public funded {
        // Arrange
        uint160 numberOfFunders = 10;
        uint160 startingFunderIndex = 1;

        for (uint160 i = startingFunderIndex; i < numberOfFunders; i++) {
            // hoax does vm.prank + vm.deal
            hoax(address(i), SEND_VALUE);
            fundme.fund{value: SEND_VALUE}();
        }

        uint256 startingOwnerBalance = fundme.getOwner().balance;
        uint256 startingFundMeBalance = address(fundme).balance;

        // Act
        vm.startPrank(fundme.getOwner());
        fundme.withdraw();
        vm.stopPrank();

        // Assert
        assert(address(fundme).balance == 0);
        assert(
            startingFundMeBalance + startingOwnerBalance ==
                fundme.getOwner().balance
        );
    }

    function testGasWithdraw() public {
        // Fund the contract
        fundme.fund{value: 1 ether}();
        vm.startPrank(fundme.getOwner());
        fundme.withdraw();
    }
}
