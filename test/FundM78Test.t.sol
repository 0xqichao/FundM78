// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Test,console} from "forge-std/Test.sol";
import {FundM78} from "../src/FundM78.sol";
import {DeployFundM78} from "../script/DeployFundM78.s.sol";

contract FundM78Test is Test{
    FundM78 fundM78;
    address testUser = makeAddr("testUser");
    function setUp() external{
        DeployFundM78 deployFunM78 = new DeployFundM78();
        fundM78 = deployFunM78.run();
        vm.deal(testUser, 100 ether);
    }

    function testOwnerIsMsgSender() public view{
        assertEq(fundM78.getOwner(),msg.sender);
    }

    function testFundFails() public{
        vm.expectRevert();
        fundM78.fund();
    }

    function testFundSuccess() public{
        vm.prank(testUser);
        fundM78.fund{value:0.1 ether}();
        assertEq(address(fundM78).balance , 0.1 ether);
        assertEq(fundM78.getAddressToAmountFunded(testUser), 0.1 ether);
    }


    modifier funded(){
        vm.prank(testUser);
        fundM78.fund{value:0.1 ether}();
        _;
    }

    function testOnlyOwnerCanWithdraw() public funded{
        vm.expectRevert();
        vm.prank(testUser);
        fundM78.withdraw();

        vm.prank(msg.sender);
        fundM78.withdraw();
    }

    function testWithdraw() public funded{
        uint256 startOwnerBalance = fundM78.getOwner().balance;
        uint256 startFundM78Blence = address(fundM78).balance;

        vm.prank(fundM78.getOwner());
        fundM78.withdraw();

        uint256 endOwnerBalance = fundM78.getOwner().balance;
        uint256 endFundM78Blence = address(fundM78).balance;

        assertEq(endFundM78Blence, 0);
        assertEq(endOwnerBalance, startOwnerBalance + startFundM78Blence);
    }
}