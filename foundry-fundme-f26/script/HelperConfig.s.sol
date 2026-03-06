// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;
import {Script} from "forge-std/Script.sol";
import { MockV3Aggregator} from "../test/mocks/MockV3Aggregator.sol"


contract Helperconfig is Script {
    Networkconfig public activeNetworkconfig;

    uint8 public constant DECIMALS = 8;
    int256 public constant INITIAL_PRICE = 200e18;

    struct Networkconfig {
        address priceFeed; //Eth/usd price feed address
    }

    constructor() {
        if (block.chainid == 11155111) {
            activeNetworkconfig = getsepoliaEthConfig();
        } else if (block.chainid == 1) {
            activeNetworkconfig = getmainnerEthConfig();
        } else {
            activeNetworkconfig = getAnvilEthConfig();
        }
    }

    function getsepoliaEthConfig() public pure returns (Networkconfig memory) {
        Networkconfig memory sepoliaConfig = Networkconfig({
            priceFeed: 0x694AA1769357215DE4FAC081bf1f309aDC325306
        });

        return sepoliaConfig;
    }

    function getmainnerEthConfig() public pure returns (Networkconfig memory) {
        Networkconfig memory ethConfig = Networkconfig({
            priceFeed: 0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419
        });

        return ethConfig;
    }
function getAnvilEthConfig() public returns (NetworkConfig memory) {
    // 1. Check if we already deployed this (prevents wasting gas/memory)
    if (activeNetworkConfig.priceFeed != address(0)) {
        return activeNetworkConfig;
    }

    // 2. Deploy the mock
    vm.startBroadcast();
    MockV3Aggregator mockPriceFeed = new MockV3Aggregator(DECIMALS, INITIAL_PRICE);
    vm.stopBroadcast();

    // 3. Return the config
    NetworkConfig  anvilConfig = NetworkConfig({
        priceFeed: address(mockPriceFeed)
    });
    return anvilConfig;
}}