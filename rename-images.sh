#!/usr/bin/env bash
set -euo pipefail

# rename-images.sh
# Safely rename image files to kebab-case, update references across the repo,
# commit, and push to the repository default branch (typically main).
# Usage: run from the repository root: ./rename-images.sh

# Safety checks
if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  echo "ERROR: Not inside a git repository. Run this from your repo root." >&2
  exit 1
fi

# Determine default branch currently checked out
CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
if [ -z "$CURRENT_BRANCH" ]; then
  echo "ERROR: Unable to determine current branch." >&2
  exit 1
fi

echo "Running on branch: $CURRENT_BRANCH"

# If user is not on main and they want to explicitly use main, change this variable.
TARGET_BRANCH="$CURRENT_BRANCH"

# Ensure working tree is clean
if [ -n "$(git status --porcelain)" ]; then
  echo "ERROR: Your working tree is not clean. Commit or stash changes before running." >&2
  git status --porcelain
  exit 1
fi

# Mapping: each entry contains a comma-separated list of old filename variants then the new filename
# Format: "old1|old2|old3::new"
MAP=(
  "IMG_2481.JPG.jpeg|IMG_2481.JPG::img-2481.jpg"
  "IMG_2493.JPG.jpeg|IMG_2493.JPG::img-2493.jpg"
  "IMG_4159.JPG.jpeg|IMG_4159.JPG::img-4159.jpg"
  "IMG_4408.JPG.jpeg|IMG_4408.JPG::img-4408.jpg"
  "IMG_4416.JPG.jpeg|IMG_4416.JPG::img-4416.jpg"
  "Rajesh Kids_June_Grid \ .jpg|Rajesh_Kids_June_Grid_.jpg|Rajesh Kids_June_Grid .jpg::rajesh-kids-june-grid.jpg"
  "Rajesh Kids_grid_April.jpg|Rajesh_Kids_grid_April.jpg::rajesh-kids-grid-april.jpg"
  "Rajesh kids_May Grid.jpg|Rajesh_kids_May_Grid.jpg::rajesh-kids-may-grid.jpg"
  "SDF WSP Images.jpg|SDF_WSP_Images.jpg::sdf-wsp-images.jpg"
)

any_renamed=0

echo "Starting file rename pass..."
for entry in "${MAP[@]}"; do
  old_variants="${entry%%::*}"
  newfile="${entry##*::}"

  IFS='|' read -r -a olds <<< "$old_variants"

  for old in "${olds[@]}"; do
    # Trim possible leading/trailing whitespace
    old_trimmed="$old"

    # Try to find tracked files matching the old name exactly (full filename match)
    matches=$(git ls-files -- "*${old_trimmed}" 2>/dev/null || true)

    if [ -n "$matches" ]; then
      while IFS= read -r path; do
        dirpath=$(dirname "$path")
        newpath="$dirpath/$newfile"
        # If a file already exists at newpath, add numeric suffix to avoid overwriting
        if [ -e "$newpath" ]; then
          echo "Warning: $newpath already exists — will create a unique name instead." >&2
          suffix=1
          while [ -e "${newpath%.jpg}-$suffix.jpg" ]; do
            suffix=$((suffix+1))
          done
          newpath="${newpath%.jpg}-$suffix.jpg"
        fi
        git mv -- "$path" "$newpath"
        echo "Renamed: '$path' -> '$newpath'"
        any_renamed=1
      done <<< "$matches"
    else
      # No direct matches; attempt a case-sensitive grep of tracked files for the literal string
      grep_matches=$(git grep -I -n --fixed-strings -e "$old_trimmed" -- . || true)
      if [ -n "$grep_matches" ]; then
        # If the file doesn't exist but is referenced, create the new file path placeholder by copying any exact file found by ls-files substring match
        # Try to find closest matching tracked file with the same basename
        basename_search=$(basename "$old_trimmed")
        candidate=$(git ls-files | grep -F "$basename_search" || true)
        if [ -n "$candidate" ]; then
          while IFS= read -r c; do
            dirpath=$(dirname "$c")
            newpath="$dirpath/$newfile"
            if [ -e "$newpath" ]; then
              echo "Warning: $newpath already exists — skipping creating duplicate." >&2
              continue
            fi
            git mv -- "$c" "$newpath" || true
            echo "Renamed (from candidate): '$c' -> '$newpath'"
            any_renamed=1
          done <<< "$candidate"
        else
          echo "Note: no tracked file matched '$old_trimmed' — only references will be updated if present."
        fi
      fi
    fi
  done
done

if [ "$any_renamed" -eq 0 ]; then
  echo "No files were renamed in the rename pass. Either files were already renamed or not present."
else
  echo "Rename pass completed."
fi

# Replace references in tracked text files
# We will search for the old literals and replace them with the new filename.
# This pass is conservative: it operates only on files returned by git grep for each literal.

echo "Starting reference update pass..."

for entry in "${MAP[@]}"; do
  old_variants="${entry%%::*}"
  newfile="${entry##*::}"
  IFS='|' read -r -a olds <<< "$old_variants"

  for old in "${olds[@]}"; do
    old_trimmed="$old"
    # Find files that reference the literal old filename
    refs=$(git grep -I -n --fixed-strings -e "$old_trimmed" -- . || true)
    if [ -n "$refs" ]; then
      echo "Replacing references of '$old_trimmed' -> '$newfile'"
      echo "$refs" | cut -d: -f1 | sort -u | while IFS= read -r file; do
        # Use perl literal replacement to handle special chars
        perl -0777 -pe "s/\Q$old_trimmed\E/$newfile/g" -i.bak "$file"
        rm -f "${file}.bak"
        echo "  Updated: $file"
      done
    fi
  done

  # Additional conservative replacements for common variants (e.g., bare IMG_2481.JPG without .jpeg)
  # Derive a simple underscore/extension-insensitive variant if present
  # e.g., for IMG_2481.JPG.jpeg, also replace IMG_2481.JPG
  if [[ "${entry}" == IMG_* ]]; then
    # extract number
    if [[ "$entry" =~ IMG_([0-9]{4}) ]]; then
      num="${BASH_REMATCH[1]}"
      alt_old="IMG_${num}.JPG"
      refs2=$(git grep -I -n --fixed-strings -e "$alt_old" -- . || true)
      if [ -n "$refs2" ]; then
        echo "Replacing references of '$alt_old' -> '$newfile'"
        echo "$refs2" | cut -d: -f1 | sort -u | while IFS= read -r file; do
          perl -0777 -pe "s/\Q$alt_old\E/$newfile/g" -i.bak "$file"
          rm -f "${file}.bak"
          echo "  Updated: $file"
        done
      fi
    fi
  fi
done

echo "Reference update pass completed."

# Show changes summary
echo "----- git status (summary) -----"
git status --porcelain

# Stage all changes
git add -A

# Commit
if git diff --cached --quiet; then
  echo "No staged changes to commit."
else
  git commit -m "Rename image files to kebab-case and update references"
  echo "Committed changes."
fi

# Push to the current branch
git push origin "$TARGET_BRANCH"

echo "Done. If anything failed, inspect the output above and rerun the script after fixing issues."
