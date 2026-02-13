// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title MilestoneTracker Contract
/// @notice Project milestone tracking with escrow payments.
contract MilestoneTracker {

    struct Project {
        address client;
        address provider;
        uint256 totalAmount;
        uint256 released;
    }
    
    mapping(uint256 => Project) public projects;
    uint256 public nextProjectId;
    
    function createProject(address _provider) external payable returns (uint256) {
        uint256 id = nextProjectId++;
        projects[id] = Project({
            client: msg.sender,
            provider: _provider,
            totalAmount: msg.value,
            released: 0
        });
        return id;
    }
    
    function releaseMilestone(uint256 _id, uint256 _amount) external {
        Project storage p = projects[_id];
        require(msg.sender == p.client, "Only client");
        require(p.released + _amount <= p.totalAmount, "Over release");
        
        p.released += _amount;
        payable(p.provider).transfer(_amount);
    }

}
