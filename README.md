# pixelcrane

![pixelcrane logo](images/pixelcrane.png)

pixelcrane is a tool for extracting files from the layers of a container image.
pixelcrane was designed for use in automated extraction as a Github Action.

pixelcrane is based heavily on [crane](https://github.com/google/go-containerregistry/tree/main/cmd/crane).

## usage

Create a repository and add a `.github/workflows/pixelcrane.yml` file.
An example is shown below:

```yaml
name: pixelcrane

on:
  workflow_dispatch:
  schedule:
    - cron: "0 0 * * 1"
    
jobs:
  build:
    runs-on: ubuntu-latest
    timeout-minutes: 30
    steps:
    - uses: actions/checkout@v2
    - uses: amlweems/pixelcrane@v1
      with:
        image: debian
        filter: etc/(passwd|shadow)
```

pixelcrane will iterate over all tags ordered by creation time,
extract files matching the provided regex filter, and commit
them to the repo. By default, pixelcrane stores these files in
a directory called `rootfs` and tracks its progress in a file
called `images.txt`.
