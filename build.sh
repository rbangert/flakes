#!/bin/sh

if [ -z "$(git status -s -uno | grep -v '^ ' | awk '{print $2}')" ]; then
    gum confirm "Stage all?" && git add .
fi

TYPE=$(gum choose "fix" "feat" "docs" "style" "refactor" "test" "chore" "revert")
SCOPE=$(gum input --placeholder "scope")

test -n "$SCOPE" && SCOPE="($SCOPE)"

SUMMARY=$(gum input --value "$TYPE$SCOPE:" --placeholder "summary")
DESCRIPTION=$(gum write --placeholder "Details -- Ctrl-D to finish")

gum confirm "Commit Changes? (y/n)" && \
git commit -m "$SUMMARY" -m "$DESCRIPTION"