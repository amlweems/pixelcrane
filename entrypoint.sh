#!/bin/bash

# set commit author
git config user.name "Automated"
git config user.email "actions@users.noreply.github.com"

# ensure images.txt exists
touch images.txt

# fetch ordered list of image tags
pixelcrane ls "${INPUT_IMAGE}" > /tmp/images.txt

# iterate tags not present in images.txt and extract
for image in `comm -1 -3 images.txt /tmp/images.txt`; do
    echo "Extracting ${image}"
    tag=$(echo "${image}" | cut -d ':' -f 2)

    # extract filtered fs to specified dir
    rm -rf "${INPUT_OUTPUT}"
    mkdir -p "${INPUT_OUTPUT}"
    pixelcrane extract "${image}" "${INPUT_FILTER}" | tar -xv -C "${INPUT_OUTPUT}"

    # add tag to images.txt list
    echo "${image}" >> images.txt

    # commit
    git add "${INPUT_OUTPUT}" images.txt
    git commit -m "${image}"
    git tag "${tag}"
done

# push
git push origin main --tags
