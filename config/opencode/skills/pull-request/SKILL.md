---
name: pull-request
description: Automated pull request workflow with Copilot review iteration
license: MIT
compatibility: opencode
---

## What I do

I manage the complete pull request lifecycle from start to finish:

1. **Branch Management**: Create a new branch if one doesn't exist (using format `feature/descriptive-name`)
2. **Commit Changes**: Commit current changes with a message based on git diff analysis
3. **Create PR**: Open a GitHub pull request with auto-generated title and description from diff analysis, automatically adding @copilot as reviewer
4. **Iterate on Feedback**: 
   - Poll for review comments every few minutes
   - Respond to each comment in GitHub threads
   - Fix valid comments with new commits
   - Re-request Copilot review after making changes
   - Continue until settled out or comments deemed not worth fixing
5. **Check Status**: Ensure all CI/CD checks pass after each change

## When to use me

Use me when you want to automate the full PR creation and review iteration cycle. I'm designed to handle the back-and-forth with Copilot reviewer until the changes are ready for merge.

## Workflow Details

### Branch Creation
- Check if on a feature branch
- If on main/master, create new branch: `feature/<brief-description>` based on the changes
- Push branch to remote

### Commit Strategy
- Analyze git diff to generate commit message
- Stage relevant files
- Commit with conventional commit format
- Push to remote

### PR Creation
- Analyze all commits to generate title (50-72 chars max)
- Generate description with:
  - Summary of changes
  - Type of change (feature, bugfix, refactor, etc.)
  - Testing performed
  - Related issues
- Create PR using `gh pr create --reviewer @copilot`
- This automatically requests Copilot review when creating the PR
- Display PR URL once created

### Review Iteration
- Poll for review comments every 3 minutes
- For each review comment:
  - Analyze the comment
  - Determine if it's valid or incorrect
  - Post response in GitHub thread explaining reasoning
  - If valid, fix the issue with a new commit
  - If incorrect, explain why in the thread
- After making fixes, re-request Copilot review using `gh pr edit --add-reviewer @copilot`
- Continue until:
  - No more review comments, OR
  - Agent determines remaining comments are not worth addressing (document reasoning)

### Check Management
- After each commit, check PR status
- Wait for all CI/CD checks to pass
- If checks fail:
  - Analyze failure reason
  - Fix the issue with a new commit
  - Re-run checks
- Do not proceed with next review cycle until checks pass

## Important Notes

- Requires GitHub CLI v2.88.0 or later for Copilot review integration
- Always communicate what you're doing at each step
- Show the PR URL once created
- Report on review comments found
- Explain your reasoning when declining to address a comment
- Stop gracefully when the PR is approved or you determine further iteration isn't beneficial
