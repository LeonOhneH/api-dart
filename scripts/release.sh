#!/bin/bash
# release.sh - Usage: ./release.sh [major|minor|patch] [-m "commit message"]

BUMP_TYPE="patch"
COMMIT_MSG=""

while [[ $# -gt 0 ]]; do
  case $1 in
    major|minor|patch)
      BUMP_TYPE="$1"
      shift
      ;;
    -m)
      COMMIT_MSG="$2"
      shift 2
      ;;
    *)
      echo "Usage: $0 [major|minor|patch] [-m \"commit message\"]"
      exit 1
      ;;
  esac
done

CURRENT=$(cat VERSION)

IFS='.' read -r MAJOR MINOR PATCH <<<"$CURRENT"

case $BUMP_TYPE in
major)
  MAJOR=$((MAJOR + 1))
  MINOR=0
  PATCH=0
  ;;
minor)
  MINOR=$((MINOR + 1))
  PATCH=0
  ;;
patch) PATCH=$((PATCH + 1)) ;;
*)
  echo "Unknown bump type: $BUMP_TYPE"
  exit 1
  ;;
esac

NEW_VERSION="${MAJOR}.${MINOR}.${PATCH}"
echo "$NEW_VERSION" >VERSION

# Update pubspec.yaml
sed -i "s|^version: ${CURRENT}|version: ${NEW_VERSION}|" pubspec.yaml

git add VERSION pubspec.yaml
if [[ -n "$COMMIT_MSG" ]]; then
  git commit -m "$COMMIT_MSG"
else
  git commit -m "Bump version to $NEW_VERSION"
fi
git tag "v$NEW_VERSION"
git push origin main --tags

echo "Released v$NEW_VERSION"
