// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;
import {Script} from "forge-std/Script.sol";

contract Helperconfig is Script {
    Networkconfig public activeNetworkconfig;
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

    function getAnvilEthConfig() public pure returns (Networkconfig memory) {}
}
