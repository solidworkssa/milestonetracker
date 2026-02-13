// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
import "forge-std/Test.sol";
import "../src/MilestoneTracker.sol";

contract MilestoneTrackerTest is Test {
    MilestoneTracker public c;
    
    function setUp() public {
        c = new MilestoneTracker();
    }

    function testDeployment() public {
        assertTrue(address(c) != address(0));
    }
}
