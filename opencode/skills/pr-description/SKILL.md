---
name: pr-description
description: Generate PR descriptions in Jordan's preferred format
metadata:
  author: jordantrent
---

# PR Description Generator

Generate pull request descriptions following this exact format and workflow.

## Workflow

When the user requests a PR description:

1. **Get the diff:**

   ```bash
   # Fetch latest from remote to ensure we're comparing against current state
   git fetch origin

   # Get current branch name
   git rev-parse --abbrev-ref HEAD

   # Determine base branch and get diff (three-dot to exclude base branch commits)
   BASE=$(git rev-parse --verify origin/dev 2>/dev/null && echo origin/dev || \
          git rev-parse --verify origin/develop 2>/dev/null && echo origin/develop || \
          git rev-parse --verify origin/main 2>/dev/null && echo origin/main || \
          echo origin/master) && \
   git diff $BASE...HEAD --stat
   ```

2. **Extract issue IDs from branch name:**
   - Branch format: `feature/stu2-2545-some-description` or `feature/stu2-2545-stu2-2560-description`
   - Parse all issue IDs (e.g., STU2-2545, STU2-2560)
   - If multiple issues, use array notation: `[STU2-2545, STU2-2560]`
   - If single issue: `[STU2-2545]`
   - If no issue ID, omit the `Closes` statement

3. **Fetch Linear context (if issue IDs found):**
   - Use `linear_get_issue` with each extracted issue ID
   - Extract relevant context: title, description, labels, project
   - Use this to inform the PR summary and understand the broader context
   - If issue fetch fails (404/not found), proceed without Linear context

4. **Check for feature flags in the diff:**

   ```bash
   # Search for newly added feature flag calls (excluding imports)
   BASE=$(git rev-parse --verify origin/dev 2>/dev/null && echo origin/dev || \
          git rev-parse --verify origin/develop 2>/dev/null && echo origin/develop || \
          git rev-parse --verify origin/main 2>/dev/null && echo origin/main || \
          echo origin/master) && \
   git diff $BASE...HEAD | grep -E "^\+.*(useFeatureFlag|useFeatureFlagAsync|useVariant|getFeatureFlag)" | grep -v "import"
   ```

   - Look for these patterns: `useFeatureFlag`, `useFeatureFlagAsync`, `useVariant`, `getFeatureFlag`
   - Only count truly new flags (check the flag name strings in added lines)
   - Ignore refactors/renames of existing flags (variable name changes, etc.)
   - If new flags found, note them in the PR description under the Summary section

5. **Suggest labels:**

   ```bash
   # Get available labels from the repo
   gh label list --limit 100 --json name,description --jq '.[] | "\(.name): \(.description)"'
   ```

   - Based on the diff and PR content, suggest 1-3 relevant labels
   - Present suggestions to the user in a simple list
   - Don't auto-apply labels, just suggest them

6. **Generate title:**
   - Format: `[ISSUE-ID] Human-readable description`
   - If Linear issue was fetched, prefer the Linear issue title over branch name
   - Otherwise, convert kebab-case branch name to readable title
   - Example: `feature/stu2-2545-visual-and-copy-tweaks` → `[STU2-2545] Visual and copy tweaks`
   - If no issue ID: Just use human-readable description

7. **Generate description:**

   ```markdown
   ## Summary

   [One-line context about what this PR accomplishes]

   [If feature flagged: **Feature flag:** `flag-name`]

   - **Component/Area**: Brief description of changes
   - **Component/Area**: Brief description of changes
     ...

   Closes ISSUE-ID
   ```

   If no issue ID, omit the `Closes` line.

## Guidelines

- **Summary intro**: Single sentence describing the overall purpose/theme. Use Linear issue context to inform this.
- **Feature flag**: Only include if new feature flags are introduced (not refactors). Check multiple patterns: `useFeatureFlag`, `useFeatureFlagAsync`, `useVariant`, `getFeatureFlag`
- **Bullet points**: Group by logical component or feature area, not by individual commits. Linear issue description may provide useful groupings.
- **Be concise**: Brief, scannable descriptions
- **Close statement**: Use primary issue ID (first one if multiple)
- **Linear context**: Use issue title/description to understand intent, but write PR description based on actual code changes

## Example Output (without feature flag)

**Title:**

```
[STU2-2545] Visual and copy tweaks through planner creation flow
```

**Description:**

```markdown
## Summary

Polish improvements to the revision planner onboarding flow based on design feedback:

- **Subject selection**: Changed "select/deselect all" from button to text link style
- **Confidence menu**: Added tooltips to emoji options and updated border colors (primary when selected, neutral by default)
- **Target step**: Updated "Select target grade" copy to "What's your target grade?" and improved border colors to show primary on expand
- **Plan review**: Shortened subtitle copy and hide footer during loading spinner

Closes STU2-2545
```

**Suggested labels:** `enhancement`, `ui`

## Example Output (with feature flag)

**Title:**

```
[STU2-2532] Support show-planner-free flag
```

**Description:**

```markdown
## Summary

Add support for the `show-planner-free` feature flag to control planner visibility for free users.

**Feature flag:** `show-planner-free`

- **Planner gating**: Check flag in `useShouldShowRevisionPlanner` hook
- **Dashboard**: Conditionally render planner widget based on flag status

Closes STU2-2532
```

**Suggested labels:** `enhancement`, `feature-flag`

## Notes

- Always analyze actual code changes, not just commit messages
- Group related changes together logically
- If no issue ID in branch name, omit the closes statement
- Feature flag format: inline code (backticks), not quoted
- DO NOT push until prompted
- For visibility, add a note in italics "Generated using the pr-description skill from the agent-skills repo", with a link (https://github.com/SenecaLabs/agent-skills/blob/main/skills/pr-description/SKILL.md)
