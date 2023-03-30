#!/bin/sh
#
# A script which checks that an appropriate newsfile has been added on this
# branch.

# fetch up to HEAD ($CI_DEFAULT_BRANCH..HEAD)
git fetch --depth=200

# If check-newsfragment returns a non-zero exit code, exit
towncrier check --compare-with origin/$CI_DEFAULT_BRANCH || exit 1

matched=0
for f in $(git diff --diff-filter=d --name-only origin/$CI_DEFAULT_BRANCH -- changelog.d); do
    # check that any added newsfiles on this branch end with a full stop.
    lastchar=$(tr -d '\n' < "$f" | tail -c 1)
    if [ "$lastchar" != '.' ] && [ "$lastchar" != '!' ] && [ "$f" != "changelog.d/README.md" ]; then
        echo -e "\e[31mERROR: newsfragment $f does not end with a '.' or '!'\e[39m" >&2
        exit 1
    fi

    # see if this newsfile corresponds to the right PR
    if [ -n "$CI_MERGE_REQUEST_IID" ] && [ "$f" = changelog.d/"$CI_MERGE_REQUEST_IID".* ]; then
        matched=1
    fi
done

if [ -n "$CI_MERGE_REQUEST_IID" ] && [ "$matched" -eq 0 ]; then
    echo -e "\e[31mERROR: Did not find a news fragment with the right number: expected changelog.d/$CI_MERGE_REQUEST_IID.*.\e[39m" >&2
    exit 1
fi
