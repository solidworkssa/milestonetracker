# MilestoneTracker

Project milestone tracking with completion verification on Base and Stacks.

## Features

- Create projects
- Add milestones
- Mark completion
- Track progress

## Contract Functions

### Base (Solidity)
- `createProject(name)` - Create new project
- `addMilestone(projectId, title, description)` - Add milestone
- `completeMilestone(milestoneId)` - Mark complete
- `getProject(projectId)` - Get project details
- `getMilestone(milestoneId)` - Get milestone info

### Stacks (Clarity)
- `create-project` - Create project
- `add-milestone` - Add milestone
- `complete-milestone` - Mark complete
- `get-project` - Fetch project
- `get-milestone` - Fetch milestone

## Quick Start

```bash
pnpm install
pnpm dev
```

## Deploy

```bash
pnpm deploy:base
pnpm deploy:stacks
```

## License

MIT
