#!/usr/bin/env sh

# Script to help creating a release
# git and yq are required in PATH.

set -e

scriptDir=$(readlink -f "$0" | xargs dirname)
chart_file=$scriptDir/../Chart.yaml

cur_git_tag_version=$(git describe --tags --abbrev=0 | cut -c2-)
chart_version=$(grep "^version:" "$chart_file" | cut -d' ' -f2-)

printf "\n================================================================================\n"
printf "|                    Welcome to the release script!                            |\n"
printf "================================================================================\n"

printf "Checking environment...\n"
envError=0

# git
git --version
ret=$?
if [ $ret -ne 0 ]; then
    printf "Fatal: git is not installed in the environment.\n"
    envError=1
fi

# yq
yq --version
ret=$?
if [ $ret -ne 0 ]; then
    printf "Fatal: yq is not installed in the environment.\n"
    envError=1
fi

if [ ${envError} -eq 1 ]; then
  exit 1
fi

printf "\n================================================================================\n"
printf "Ensuring \"main\" and \"develop\" branches are up to date...\n"

git checkout main
git pull
git checkout develop
git pull

printf "\n================================================================================\n"
printf "Check current version:\n"
printf "  Helm Chart: %s\n" "$chart_version"
printf "  Git Tag:    %s\n" "$cur_git_tag_version"

if [ "$chart_version" = "$cur_git_tag_version" ]; then
    printf "\nVersions are synchron.\n"
else
    printf "\nVersions are NOT synchron.\n"
fi

printf "\n================================================================================\n"
printf "Choose next version\n"

RE='[^0-9]*\([0-9]*\)[.]\([0-9]*\)[.]\([0-9]*\)\([0-9A-Za-z-]*\)'
major=$(echo "$cur_git_tag_version" | sed -e "s#$RE#\1#")
minor=$(echo "$cur_git_tag_version" | sed -e "s#$RE#\2#")
patch=$(echo "$cur_git_tag_version" | sed -e "s#$RE#\3#")

printf "\n"
while true; do
    printf "Next version level: major (1), minor (2) or patch (3)? "
    read -r yn
    case $yn in
        [1]* ) major=$((major + 1)); minor=0; patch=0; branchprefix="release";source="develop"; break;;
        [2]* ) minor=$((minor + 1)); patch=0; branchprefix="release";source="develop"; break;;
        [3]* ) patch=$((patch + 1)); branchprefix="hotfix"; source="main"; break;;
        * ) echo "Please answer with \"1\", \"2\" or \"3\".";;
    esac
done

# ToDo: RCs

nextVersion="${major}.${minor}.${patch}"

printf "\n"
while true; do
    printf "Please confirm if calculated version \"%s\" is correct? (yes/no) " "$nextVersion"
    read -r yn
    case $yn in
        [Yy]* ) break;;
        [Nn]* ) exit;;
        * ) echo "Please answer yes or no.";;
    esac
done

printf "\n================================================================================\n"
printf "Starting the release %s\n" "$nextVersion"

git checkout -b "$branchprefix/v$nextVersion" "$source"

ret=$?
if [ $ret -ne 0 ]; then
  printf "Mmh, it seems that the release is already started. Checking out the release branch...\n"
  git checkout "$branchprefix/v$nextVersion"
  git pull
fi

printf "\n================================================================================\n"
printf "Create config YAML (ci/versions/v%s.yaml)\n" "$nextVersion"

# new_config_file=$scriptDir/versions/v${nextVersion}.yaml

"$scriptDir/create_version_yaml_file.sh" "$nextVersion"

printf "\n================================================================================\n"
printf "Update Helm Chart\n"

# printf "\nSet image tags in values.yaml\n"
# $scriptDir/update_images_in_chart.sh $nextVersion

printf "\nCreate docs (docs/versions/v%s.md)\n" "$nextVersion"
"$scriptDir/create_version_docs.sh" "$nextVersion"

printf "\nUpdate Chart.yaml\n"
# synapse_version=$(yq '.[].images[] | select(.name == "Synapse") | .version' $new_config_file)
yq "(
    .version = \"$nextVersion\"
)" "$chart_file" | diff -B "$chart_file" - | patch "$chart_file" -
# keep blank lines in YAML: https://github.com/mikefarah/yq/issues/515#issuecomment-1113420114

printf "\n================================================================================\n"
printf "Commit\n"

git add --no-all \
    "$chart_file" \
    "$scriptDir/../changelog.d/"* \
    "$scriptDir/versions/v${nextVersion}.yaml" \
    "$scriptDir/../docs/versions/v${nextVersion}.md"
git commit -a -m "Setting version for the release ${nextVersion}"

printf "\n================================================================================\n"
printf "Done, push the branch \"%s/v%s\"? (YES/no) " "$branchprefix" "$nextVersion"
read -r doPush

if [ "${doPush:-yes}" = "yes" ]; then
    printf "Pushing branch \"%s/v%s\".\n" "$branchprefix" "$nextVersion"
    git push -u origin "$branchprefix/v$nextVersion"
else
    printf "Not pushing, do not forget to push manually!\n"
fi


printf "\n================================================================================\n"
printf "Cherry pick or add other commits now. Done? "
read -r yn

printf "\n================================================================================\n"
printf "CI pipeline updates helm-docs (\"✍ helm-docs\") and adds a commit.\n"
printf "It needs some time… Did it finish? (enter) "
read -r yn

printf "\n================================================================================\n"
printf "Create CHANGELOG and review it.\n"
printf "The simplest way is to manually trigger the CI pipeline \"📰❗ towncrier-create-changelog\".\n" >&2
printf "Is the CHANGELOG free of mistakes? (enter) "
read -r yn
# ToDo: optional here with towncrier

printf "\n================================================================================\n"
printf "Pull release branch from Gitlab.\n"
printf "Make sure that all commits have been pulled from Gitlab.\n"
printf "Manual commands:\n"
printf "\"git checkout %s/v%s\"\n" "$branchprefix" "$nextVersion"
printf "\"git pull\" "
read -r yn

printf "\n================================================================================\n"
printf "Merge release branch into main and push.\n"
printf "Manual commands:\n"
printf "\"git checkout main\"\n"
printf "\"git merge --no-ff %s/v%s\"\n" "$branchprefix" "$nextVersion"
printf "\"git push\" "
read -r yn

printf "\n================================================================================\n"
printf "Check CI pipeline for tagging and mirroring. "
read -r yn

printf "\n================================================================================\n"
printf "Merge branch \"main\" back into \"develop\" and push.\n"
printf "Manual commands:\n"
printf "\"git checkout develop\"\n"
printf "\"git merge --no-ff main\"\n"
printf "\"git push\" "
read -r yn

printf "\n================================================================================\n"
printf "Delete release branch.\n"
printf "Manual command:\n"
printf "\"git branch -d %s/v%s\" " "$branchprefix" "$nextVersion"
read -r yn

printf "\n================================================================================\n"
printf "Done!\n"
printf "================================================================================\n"
