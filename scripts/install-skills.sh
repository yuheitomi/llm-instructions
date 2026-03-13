#!/usr/bin/env bash
#
# Install skills into ~/.agents/skills and create symlinks in ~/.claude/skills.
# Overwrites existing skills with the same name.
#
# Usage:
#   ./scripts/install-skills.sh <SOURCE_DIR>     # Install from source, then symlink
#   ./scripts/install-skills.sh --symlink-only   # Only create/update symlinks
#

set -e

AGENTS_SKILLS="${HOME}/.agents/skills"
CLAUDE_SKILLS="${HOME}/.claude/skills"

# Resolve path to absolute. Use realpath if available, else cd+pwd fallback.
resolve_path() {
  local path="$1"
  if command -v realpath &>/dev/null; then
    realpath "$path"
  else
    (cd "$path" && pwd)
  fi
}

usage() {
  echo "Usage: $0 <SOURCE_DIR>           Install skills from SOURCE_DIR and create symlinks"
  echo "       $0 --symlink-only         Only create symlinks from existing ~/.agents/skills"
  exit 1
}

SYMLINK_ONLY=false
SOURCE_DIR=""

for arg in "$@"; do
  if [[ "$arg" == "--symlink-only" ]]; then
    SYMLINK_ONLY=true
  else
    SOURCE_DIR="$arg"
  fi
done

if [[ "$SYMLINK_ONLY" == false ]]; then
  if [[ -z "$SOURCE_DIR" ]]; then
    echo "Error: SOURCE_DIR is required (or use --symlink-only)" >&2
    usage
  fi
  if [[ ! -d "$SOURCE_DIR" ]]; then
    echo "Error: SOURCE_DIR does not exist or is not a directory: $SOURCE_DIR" >&2
    exit 1
  fi
fi

# Install step
if [[ "$SYMLINK_ONLY" == false ]]; then
  SOURCE_ABS="$(resolve_path "$SOURCE_DIR")"
  mkdir -p "$AGENTS_SKILLS"

  for skill_dir in "$SOURCE_ABS"/*; do
    [[ -d "$skill_dir" ]] || continue
    [[ -f "$skill_dir/SKILL.md" ]] || continue

    skill_name="$(basename "$skill_dir")"
    target="$AGENTS_SKILLS/$skill_name"

    if [[ -e "$target" ]]; then
      echo "Overwriting: $skill_name"
      rm -rf "$target"
    else
      echo "Installing: $skill_name"
    fi

    cp -R "$skill_dir" "$target"
  done
fi

# Symlink step
mkdir -p "$CLAUDE_SKILLS"
AGENTS_ABS="$(resolve_path "$AGENTS_SKILLS")"

if [[ ! -d "$AGENTS_SKILLS" ]]; then
  echo "Error: ~/.agents/skills does not exist. Run install first." >&2
  exit 1
fi

for skill_dir in "$AGENTS_SKILLS"/*; do
  [[ -d "$skill_dir" ]] || continue
  [[ -f "$skill_dir/SKILL.md" ]] || continue

  skill_name="$(basename "$skill_dir")"
  link_path="$CLAUDE_SKILLS/$skill_name"
  target_path="$AGENTS_ABS/$skill_name"

  if [[ -e "$link_path" ]]; then
    rm -rf "$link_path"
  fi

  ln -s "$target_path" "$link_path"
  echo "Linked: $skill_name -> ~/.claude/skills/$skill_name"
done

echo "Done."
