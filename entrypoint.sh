#!/bin/bash

# set commit author
git config user.name "Automated"
git config user.email "actions@users.noreply.github.com"

# fetch ordered list of image tags
pixelcrane ls "${INPUT_IMAGE}" > /tmp/images.txt

# iterate tags not present in images.txt and extract
while IFS= read -r line; do
    image=$(echo $line | cut -d ' ' -f1)
    date=$(echo $line | cut -d ' ' -f2)
    tag=$(echo "${image}" | cut -d ':' -f 2)

    if git rev-parse -q --verify "refs/tags/$tag" >/dev/null; then
        echo "Found tag: $tag, skipping"
        continue
    fi

    # extract filtered fs to specified dir
    echo "Extracting ${image}"
    rm -rf "${INPUT_OUTPUT}"
    mkdir -p "${INPUT_OUTPUT}"
    pixelcrane extract "${image}" "${INPUT_FILTER}" | tar -xv -C "${INPUT_OUTPUT}"

    # commit
    git add "${INPUT_OUTPUT}"
    env GIT_AUTHOR_DATE="${date}" GIT_COMMITTER_DATE="${date}" git commit -m "${image}"
    git tag "${tag}"
done < /tmp/images.txt

# push
git push origin main --tags
