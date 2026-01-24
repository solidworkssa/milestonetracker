// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract MilestoneTracker {
    struct Milestone {
        uint256 id;
        uint256 projectId;
        string title;
        string description;
        bool completed;
        uint256 completedAt;
    }

    struct Project {
        uint256 id;
        address owner;
        string name;
        uint256 milestoneCount;
        uint256 completedCount;
    }

    mapping(uint256 => Project) public projects;
    mapping(uint256 => Milestone) public milestones;
    uint256 public projectCount;
    uint256 public milestoneCount;

    event ProjectCreated(uint256 indexed projectId, address owner, string name);
    event MilestoneAdded(uint256 indexed milestoneId, uint256 indexed projectId, string title);
    event MilestoneCompleted(uint256 indexed milestoneId, uint256 indexed projectId);

    function createProject(string memory _name) external returns (uint256) {
        uint256 projectId = projectCount++;

        projects[projectId] = Project({
            id: projectId,
            owner: msg.sender,
            name: _name,
            milestoneCount: 0,
            completedCount: 0
        });

        emit ProjectCreated(projectId, msg.sender, _name);

        return projectId;
    }

    function addMilestone(
        uint256 _projectId,
        string memory _title,
        string memory _description
    ) external returns (uint256) {
        Project storage project = projects[_projectId];
        require(msg.sender == project.owner, "Not owner");

        uint256 milestoneId = milestoneCount++;

        milestones[milestoneId] = Milestone({
            id: milestoneId,
            projectId: _projectId,
            title: _title,
            description: _description,
            completed: false,
            completedAt: 0
        });

        project.milestoneCount++;

        emit MilestoneAdded(milestoneId, _projectId, _title);

        return milestoneId;
    }

    function completeMilestone(uint256 _milestoneId) external {
        Milestone storage milestone = milestones[_milestoneId];
        Project storage project = projects[milestone.projectId];
        
        require(msg.sender == project.owner, "Not owner");
        require(!milestone.completed, "Already completed");

        milestone.completed = true;
        milestone.completedAt = block.timestamp;
        project.completedCount++;

        emit MilestoneCompleted(_milestoneId, milestone.projectId);
    }

    function getProject(uint256 _projectId) external view returns (Project memory) {
        return projects[_projectId];
    }

    function getMilestone(uint256 _milestoneId) external view returns (Milestone memory) {
        return milestones[_milestoneId];
    }
}
