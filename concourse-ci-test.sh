#!/bin/bash

# SETUP:
# brew install gh
# gh auth login

check_concourse_build () {
    CONCOURSE_TASK_NAME=$1
    # TODO: add timeout logic
    lastSuccessfulBuildNumber=$(fly -t devenv jobs --pipeline doozaryl-mvn-lib --json | jq ".[] | select(.name==\"${CONCOURSE_TASK_NAME}-build\") | .finished_build.name")
    while [ $lastSuccessfulBuildNumber == $(fly -t devenv jobs --pipeline doozaryl-mvn-lib --json | jq ".[] | select(.name==\"${CONCOURSE_TASK_NAME}-build\") | .finished_build.name") ]
        do
            echo "${CONCOURSE_TASK_NAME}:${lastSuccessfulBuildNumber} lastSuccessfulBuildNumber==currentBuildNumber ... wiating until currentBuildNumber increases"
            sleep 30s
    done
}

check_artifactory () {
    CURRENT_SHA=$1
    LOCATION=$2
    echo "check_artifactory: checking for artifacts with sha: ${CURRENT_SHA} here: https://${ARTIFACTORY_HOSTNAME}/artifactory/${LOCATION}"
    RESULT=$(curl -s -u $ARTIFACTORY_USERNAME:$ARTIFACTORY_PASSWORD https://${ARTIFACTORY_HOSTNAME}/artifactory/${LOCATION} | grep $CURRENT_SHA)
    if [ -z "$RESULT" ];
        then
            echo "check_artifactory: $CURRENT_SHA: Not found in $LOCATION"
            exit 1
        else 
            echo "check_artifactory:$CURRENT_SHA: Found in $LOCATION - $RESULT"
        fi
}

get_current_sha () {
    SHA=$(git log | head -n 1 | sed 's/commit //' | cut -c1-6)
}

TEST_NAME="CONCOURSE_TEST-$(date '+%d-%m-%Y--%H-%M-%S')"

echo "### TEST: PR BUILD ###"
# checkout a new branch
# modify the readme
# add the changes to staged
# commit the staged changes
# push the branch
# create a pr using gh cli
# wait for concouse pr-build finished_job to increment
# check artifactory for the existance of the new sha
git checkout -b "$TEST_NAME"
echo "\\n $TEST_NAME" >> README.md
git add README.md
git commit -m "$TEST_NAME"
git push -u origin HEAD
gh pr create --title "$TEST_NAME" --body ""
check_concourse_build "pr"
get_current_sha
check_artifactory $SHA "maven-mle-sandbox/mle/mvnlib/snapshot/"

# TODO: close PR then reopen PR and confirm new build? this does not work

echo "### TEST: MAIN BUILD ###"
# merge PR
# wait for concouse main-build finished_job to increment
# checkout master
# check artifactory for the existance of the new sha
gh pr merge $TEST_NAME --delete-branch --squash
check_concourse_build "main"
git checkout master && git fetch
get_current_sha
check_artifactory $SHA "maven-mle-sandbox/mle/mvnlib/snapshot/"

echo "### TEST: RELEASE BUILD ###"
# create new semver release tag
# create tag using gh cli
# wait for concouse release-build finished_job to increment
# check artifactory for the existance of the new release tag
# https://stackoverflow.com/questions/8653126/how-to-increment-version-number-in-a-shell-script
NEW_RELEASE_VERSION=$(git tag | awk '!/TEST/' | tail -n 1 | awk -F. -v OFS=. 'NF==1{print ++$NF}; NF>1{if(length($NF+1)>length($NF))$(NF-1)++; $NF=sprintf("%0*d", length($NF), ($NF+1)%(10^length($NF))); print}')
gh release create $NEW_RELEASE_VERSION --title $TEST_NAME --notes ""
check_concourse_build "release"
check_artifactory $NEW_RELEASE_VERSION "maven-mle-sandbox/mle/mvnlib/release/"
