#!/usr/bin/env bash
set -euo pipefail

# Load an image from a .tar file, tag it, and push to Docker Hub.
#
# Requirements:
#   - Docker CLI installed and running
#   - You are logged in: `docker login` (or use a credential helper)
#
# Usage:
#   ./dockerhub-publish.sh -f myimage.tar -r username/repo -t 1.2.3 [--also-latest]
#
# Examples:
#   ./dockerhub-publish.sh -f dist/app.tar -r myuser/myapp -t 2025.08.15
#   ./dockerhub-publish.sh -f dist/app.tar -r myuser/myapp -t v1.0.0 --also-latest
#
# Notes:
#   - The .tar should be created with `docker save` or a compatible tool.
#   - If the tar contains its own repo:tag, we’ll still retag it to the target.

usage() {
  cat <<'EOF'
Usage:
  dockerhub-publish.sh -f <image.tar> -r <dockerhub-user/repo> -t <tag> [--also-latest] [--dry-run]

Options:
  -f, --file        Path to the image tarball (from `docker save`)
  -r, --repo        Target Docker Hub repository, e.g. "username/myimage"
  -t, --tag         New tag to push, e.g. "1.2.3"
      --also-latest Also tag and push ":latest" in addition to the provided tag
      --dry-run     Show what would be done without making changes
  -h, --help        Show this help

Prereqs:
  - Docker daemon available
  - Run `docker login` beforehand to authenticate with Docker Hub
EOF
}

# Defaults
FILE=""
REPO=""
TAG=""
ALSO_LATEST="false"
DRY_RUN="false"

# Parse args
while (( "$#" )); do
  case "${1:-}" in
    -f|--file)        FILE="${2:-}"; shift 2 ;;
    -r|--repo)        REPO="${2:-}"; shift 2 ;;
    -t|--tag)         TAG="${2:-}"; shift 2 ;;
    --also-latest)    ALSO_LATEST="true"; shift ;;
    --dry-run)        DRY_RUN="true"; shift ;;
    -h|--help)        usage; exit 0 ;;
    *) echo "Unknown option: $1" >&2; usage; exit 2 ;;
  esac
done

# Basic validation
if [[ -z "$FILE" || -z "$REPO" || -z "$TAG" ]]; then
  echo "Error: -f/--file, -r/--repo, and -t/--tag are required." >&2
  usage
  exit 2
fi

if [[ ! -f "$FILE" ]]; then
  echo "Error: file not found: $FILE" >&2
  exit 1
fi

if ! command -v docker >/dev/null 2>&1; then
  echo "Error: 'docker' command not found. Please install Docker." >&2
  exit 1
fi

# Helpful banner
echo "==> Publishing image"
echo "    File:        $FILE"
echo "    Repository:  $REPO"
echo "    Tag:         $TAG"
echo "    Also latest: $ALSO_LATEST"
echo "    Dry run:     $DRY_RUN"
echo

run() {
  if [[ "$DRY_RUN" == "true" ]]; then
    echo "[dry-run] $*"
  else
    eval "$@"
  fi
}

# Load the image tar
echo "==> Loading image from tar..."
# Capture docker load output lines into an array
LOAD_OUTPUT="$(docker load -i "$FILE" 2>&1 | tee /dev/stderr || true)"

# Extract either a loaded reference (repo:tag) or an image ID.
# docker load prints lines like:
#   "Loaded image: some/repo:tag"
#   "Loaded image ID: sha256:abcd..."
# We try to grab the last such line.
LOADED_REF="$(printf '%s\n' "$LOAD_OUTPUT" | awk -F': ' '/Loaded image: /{ref=$2} END{print ref}')"
LOADED_ID="$(printf '%s\n' "$LOAD_OUTPUT" | awk -F': ' '/Loaded image ID: /{id=$2} END{print id}')"

if [[ -z "$LOADED_REF" && -z "$LOADED_ID" ]]; then
  echo "Warning: Could not parse docker load output for a reference or ID. Continuing..." >&2
fi

# Choose a source for tagging: prefer the loaded ref; fallback to the ID
SRC_FOR_TAG=""
if [[ -n "$LOADED_REF" ]]; then
  SRC_FOR_TAG="$LOADED_REF"
elif [[ -n "$LOADED_ID" ]]; then
  SRC_FOR_TAG="$LOADED_ID"
else
  # As a last resort, try to infer the most recently created image ID
  echo "==> Attempting to detect most recent image ID as fallback..."
  SRC_FOR_TAG="$(docker images --no-trunc --quiet | head -n 1)"
  if [[ -z "$SRC_FOR_TAG" ]]; then
    echo "Error: Could not determine a source image to tag." >&2
    exit 1
  fi
fi

TARGET_TAG="${REPO}:${TAG}"
echo "==> Tagging image:"
echo "    Source: $SRC_FOR_TAG"
echo "    Target: $TARGET_TAG"
run "docker tag \"$SRC_FOR_TAG\" \"$TARGET_TAG\""

if [[ "$ALSO_LATEST" == "true" ]]; then
  echo "==> Tagging also as :latest"
  run "docker tag \"$SRC_FOR_TAG\" \"${REPO}:latest\""
fi

# Quick sanity check: ensure the image now exists locally with the target tag
if [[ "$DRY_RUN" != "true" ]]; then
  if ! docker image inspect "$TARGET_TAG" >/dev/null 2>&1; then
    echo "Error: Tag \"$TARGET_TAG\" not found locally after tagging." >&2
    exit 1
  fi
  if [[ "$ALSO_LATEST" == "true" ]] && ! docker image inspect "${REPO}:latest" >/dev/null 2>&1; then
    echo "Error: Tag \"${REPO}:latest\" not found locally after tagging." >&2
    exit 1
  fi
fi

# Push
echo "==> Pushing $TARGET_TAG to Docker Hub..."
run "docker push \"$TARGET_TAG\""

if [[ "$ALSO_LATEST" == "true" ]]; then
  echo "==> Pushing ${REPO}:latest to Docker Hub..."
  run "docker push \"${REPO}:latest\""
fi

echo "==> Done!"
echo "    Pushed: $TARGET_TAG"
if [[ "$ALSO_LATEST" == "true" ]]; then
  echo "    Pushed: ${REPO}:latest"
fi
