// SPDX-License-Identifier: MIT

pragma solidity 0.8.19;

import {DeployFundMe} from "../../script/DeployFundMe.s.sol";
import {FundFundMe, WithdrawFundMe} from "../../script/interaction.s.sol";
import {FundMe} from "../../src/FundMe.sol";
import {HelperConfig} from "../../script/HelperConfig.s.sol";
import {Test} from "forge-std/Test.sol";
import {StdCheats} from "forge-std/StdCheats.sol";
import {ZkSyncChainChecker} from "lib/foundry-devops/src/ZkSyncChainChecker.sol";

contract InteractionsTest is ZkSyncChainChecker, StdCheats, Test {
    FundMe public fundMe;
    HelperConfig public helperConfig;

    uint256 public constant SEND_VALUE = 0.1 ether;
    uint256 public constant STARTING_USER_BALANCE = 10 ether;

    address public constant USER = address(1);

    function setUp() external skipZkSync {
        if (!isZkSyncChain()) {
            DeployFundMe deployer = new DeployFundMe();
            (fundMe, helperConfig) = deployer.run();
        } else {
            helperConfig = new HelperConfig();
            // Use the correct function from HelperConfig
            fundMe = new FundMe(
                helperConfig.getConfigByChainId(block.chainid).priceFeed
            );
        }

        vm.deal(USER, STARTING_USER_BALANCE);
    }

    function testUserCanFundAndOwnerWithdraw() public skipZkSync {
        uint256 preUserBalance = address(USER).balance;
        uint256 preOwnerBalance = address(fundMe.getOwner()).balance;
        uint256 originalFundMeBalance = address(fundMe).balance;

        // Simulate funding from USER
        vm.prank(USER);
        fundMe.fund{value: SEND_VALUE}();

        // Withdraw funds
        WithdrawFundMe withdrawFundMe = new WithdrawFundMe();
        withdrawFundMe.withdrawFundMe(address(fundMe));

        uint256 afterUserBalance = address(USER).balance;
        uint256 afterOwnerBalance = address(fundMe.getOwner()).balance;

        assert(address(fundMe).balance == 0);
        assertEq(afterUserBalance + SEND_VALUE, preUserBalance);
        assertEq(
            preOwnerBalance + SEND_VALUE + originalFundMeBalance,
            afterOwnerBalance
        );
    }
}
