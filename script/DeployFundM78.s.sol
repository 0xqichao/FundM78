// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {FundM78} from "../src/FundM78.sol";

contract DeployFundM78 is Script{
    function run() external returns(FundM78){
        vm.startBroadcast();
        FundM78 fundM78 = new FundM78();
        vm.stopBroadcast();
        return fundM78;
    }
} 