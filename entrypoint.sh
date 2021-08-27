#!/bin/bash

# set commit author
git config user.name "Automated"
git config user.email "actions@users.noreply.github.com"

# ensure images.txt exists
touch images.txt

# fetch ordered list of image tags
pixelcrane ls "${INPUT_IMAGE}" > /tmp/images.txt

# iterate tags not present in images.txt and extract
while IFS= read -r line; do
    image=$(echo $line | cut -d ' ' -f1)
    date=$(echo $line | cut -d ' ' -f2)

    echo "Extracting ${image}"
    tag=$(echo "${image}" | cut -d ':' -f 2)

    # extract filtered fs to specified dir
    rm -rf "${INPUT_OUTPUT}"
    mkdir -p "${INPUT_OUTPUT}"
    pixelcrane extract "${image}" "${INPUT_FILTER}" | tar -xv -C "${INPUT_OUTPUT}"

    # add tag to images.txt list
    echo "${image} ${date}" >> images.txt

    # commit
    git add "${INPUT_OUTPUT}"
    env GIT_AUTHOR_DATE="${date}" GIT_COMMITTER_DATE="${date}" git commit -m "${image}"
    git tag "${tag}"
done < <(comm -1 -3 images.txt /tmp/images.txt)

git add images.txt
git commit -m 'image tracking'

# push
git push origin main --tags
