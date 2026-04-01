# Log Archive Tool

Project URL: https://roadmap.sh/projects/log-archive-tool

A small Bash-based utility for archiving `.log` files from a directory into timestamped `.tar.gz` files.

This repository includes:

- `log-archive.sh`: Archives all `.log` files in a target directory.
- `logger.sh`: Generates sample logs continuously (useful for testing).
- `Dockerfile`: Container image with required tools installed.

## What the script does

When you run `log-archive.sh <log_directory>`, it:

1. Validates that exactly one argument is provided.
2. Checks that the given directory exists.
3. Creates an `archives` folder in the current working directory (if missing).
4. Finds all `*.log` files in the target directory.
5. Creates a compressed archive named like:
   - `logs_archive_YYYYMMDD_HHMMSS.tar.gz`
6. Stores the archive in `./archives`.
7. Appends an operation entry to `./archives/archive.log`.
8. Prompts whether to delete original log files.

## Requirements

- Bash
- `tar`
- `gzip`
- Basic core utilities (`mkdir`, `rm`, `date`)

On Debian/Ubuntu:

```bash
sudo apt update
sudo apt install -y tar gzip coreutils
```

## Usage

Run from the repository root (or any location where `log-archive.sh` is accessible):

```bash
./log-archive.sh <log_directory>
```

Example:

```bash
./log-archive.sh /var/log/myapp
```

If successful, output is similar to:

```text
Archived 5 log files to logs_archive_20260401_142530.tar.gz
Do you want to delete the original log files? [y/N]:
```

## Output files

After each run, you will find:

- Archive files in `./archives/`
- Audit log at `./archives/archive.log`

Example log line inside `archive.log`:

```text
2026-04-01 14:25:30 Archived 5 files to logs_archive_20260401_142530.tar.gz
```

## Interactive delete prompt

After archiving, the script asks:

```text
Do you want to delete the original log files? [y/N]:
```

- Enter `y` or `yes` (any case) to delete original `.log` files.
- Any other input (or Enter) keeps original files.

## Exit behavior and edge cases

- Wrong number of args:
  - Prints: `Usage: log-archive.sh <log_directory>`
  - Exits with code `1`
- Directory does not exist:
  - Prints: `Error: Directory <path> does not exist.`
  - Exits with code `1`
- No `.log` files found:
  - Prints: `No log files found in <path>`
  - Exits with code `0`
- `tar` missing:
  - Prints: `Error: tar command not found. Please install tar to use this script.`
  - Exits with code `1`

## Test log generator (`logger.sh`)

`logger.sh` continuously writes to `/logs/system.log` every 2 seconds:

```bash
./logger.sh
```

Stop with `Ctrl+C`.

## Docker usage

Build image:

```bash
docker build -t log-archive-tool .
```

Start container shell:

```bash
docker run --rm -it log-archive-tool
```

Inside container, scripts are available at:

- `/usr/local/bin/log-archive`
- `/usr/local/bin/logger`

### Container demo flow

1. Start the logger in one shell:

```bash
mkdir -p /logs
logger
```

2. In another shell (same container), run:

```bash
log-archive /logs
```

3. Archives are created in `/app/archives`.

Tip: If you want to persist archives on your host:

```bash
docker run --rm -it -v "${PWD}/archives:/app/archives" log-archive-tool
```

## Project structure

```text
.
├── Dockerfile
├── log-archive.sh
├── logger.sh
└── README.md
```

## Notes

- The archive destination is always `./archives` relative to where you run `log-archive.sh`.
- Only files matching `*.log` are included.
- Archive names are timestamp-based to avoid collisions in normal use.
