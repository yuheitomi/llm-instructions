# Set up pnpm for React Project

## `pnpm-workspace.yaml` Configuration

Ask the user the node version to use (recommended version is 24.xx). Specify the exact version e.g., 24.12.0.

You can check the latest LTS version from: https://nodejs.org/en/blog/release/

```yaml
minimumReleaseAge: 1440 # 24 hours
minimumReleaseAgeExclude:
  - react

useNodeVersion: { nodeVersion }
```
