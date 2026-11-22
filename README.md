# CI

`build-sw106.yml` is the GitHub Actions workflow for this board.

GitHub requires the `workflow` OAuth scope to push files under
`.github/workflows`. This repository keeps the file here so the code and docs can
be pushed with a normal `repo` token/deploy key.

To enable the action once:

1. Open this file on GitHub.
2. Copy its contents.
3. Create `.github/workflows/build-sw106.yml` through the GitHub web UI and
   paste the contents.
4. Commit. The action will appear as **Build SW-106T-A_XM** and can be run with
   **Run workflow**.

The workflow builds `MACHINE=SW-106T-A_XM`, verifies the image is exactly
524288 bytes, and uploads `SW-106T-A_XM-V0.2.6.bin` as an artifact.
