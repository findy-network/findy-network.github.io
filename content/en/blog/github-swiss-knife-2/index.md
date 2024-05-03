---
date: 2024-04-23
title: "The Swiss Army Knife for the Agency Project, Part 2: Release Management with GitHub"
linkTitle: "Release Management with GitHub"
description: "Multiple aspects need to be considered when releasing and distributing software. In this article, we will examine how we handle releasing and artifact delivery with GitHub tools in our open-source project."
author: Laura Vuorenoja
draft: true
resources:
  - src: "**.{png,jpg}"
    title: "Image #:counter"
---

This article will examine how we handle releasing and artifact delivery with GitHub tools
in our open-source project. When designing our project's release process, we have kept it
lightweight but efficient enough. One important goal has been ensuring that developers
get a stable version, i.e., a working version of the code, whenever they clone the repository.
Furthermore, we want to offer a ready-built deliverable whenever possible so that trying out
our software stack is easy.

## Branching Model

In our development model, we have three different kinds of branches:

* Feature branches, a.k.a. pull request branch: each change is first pushed to a feature branch,
  tested, and possibly reviewed before merging it to the `dev` branch.
* `dev`: the baseline for all changes. One merges pull requests first with this branch.
  If tests for `dev` succeed, one can merge the changes into the `master` branch.
  The `dev` branch test set can be more extensive than the one run for the pull request (feature) branch.
* `master`: the project's main branch that contains the latest working version of the software.
  Changes to this branch trigger automatic deployments to our cloud environment.

{{< imgproc cover Fit "925x925" >}}
<em>Branching model has three branches: feature branches, dev, and master.
</em>
{{< /imgproc >}}

The primary reason for using this branching style is to enable us to run extensive automated testing
for changes introduced by one or multiple pull requests before merging them with the `master` branch.
Therefore, this routine ensures that the `master` branch always has a working version.

## Time for a Release

Our release bot is [a custom GitHub action](https://github.com/findy-network/releaser-action).
Each repository that follows the branching model described
above uses the bot for tagging the release. The bot's primary duty is to check if the `dev` branch
has code changes missing from the `master` branch. If the bot finds changes, it will create a version
tag for the new release and update the working version of the `dev` branch.

The bot works night shifts and utilizes
[a GitHub scheduled event](https://docs.github.com/en/actions/using-workflows/events-that-trigger-workflows#schedule)
as an alarm clock.
For each repository it is configured for, it runs the same steps:

1. Check if there are changes between the `dev` and `master` branches
1. Check if the required workflows (tests) have succeeded for the `dev` branch
1. Parse the current working version from the `VERSION` file
1. Check out the `dev` branch and tag the `dev` branch `HEAD` with the current version
1. Push tag to remote
1. Increase the working version and commit it to the `dev`-branch.

When step 5 is ready, i.e., the bot has created a new tag, another workflow will start.
This workflow will handle building the project deliverables for the tagged release.
After a successful release routine, the CI merges the tag to `master`.

{{< imgproc releaser Fit "1025x1025" >}}
<em>Changes are updated nightly from dev to master.
</em>
{{< /imgproc >}}

## Package Distribution

Each time a release is tagged, the CI builds the release deliverables for distribution.
As our stack contains various-style projects built in various languages, the release artifacts
depend on the project type and programming language used.

{{< imgproc packages Fit "925x925" >}}
<em>One can navigate to linked packages from the repository front page.
</em>
{{< /imgproc >}}

The CI stores all of the artifacts in GitHub in one way or another. Docker images and library
binaries utilize different features of [GitHub Packages](https://github.com/features/packages),
a GitHub offering for delivering packages
to the open-source community. The Packages UI is integrated directly with the repository UI,
so finding and using the packages is intuitive for the user.

### Docker Containers for Backend Services

Our agency software has a microservice architecture, meaning multiple servers handle the backend
functionality. To simplify cloud deployment and service orchestration in
a local development environment, we build Docker images for each service release and store them in
the GitHub container registry.

The GitHub Actions workflow handles the image building. We build two variants of the images.
In addition to amd64, we make an arm64 version to support Apple-silicon-based Mac environments.
You can read more about utilizing GitHub Actions to create images for multiple platforms [here](/blog/2021/09/20/the-arm-adventure-on-docker/).

The community can access the publicly stored images without authentication.
The package namespace is `https://ghcr.io`, meaning one can refer to an image with the path
`ghcr.io/NAMESPACE/IMAGE_NAME:TAG`, e.g., `ghcr.io/findy-network/findy-agent:latest`.
Publishing and using images from the Docker registry is straightforward.

### Libraries

We also have utility libraries that provide the common functionalities needed to build
clients for our backend services. These include helpers for
[Go](https://github.com/findy-network/findy-common-go),
[Node.js](https://github.com/findy-network/findy-common-ts),
and [Kotlin](https://github.com/findy-network/findy-common-kt).

In the Go ecosystem, sharing modules is easy. The Go build system must find the dependency code
in a publicly accessible Git repository. Thus, the build compiles the code on the fly;
one does not need to distribute or download binaries. Module versions are resolved directly
from the git tags found in the repository.

The story is different for Node.js and Kotlin/Java libraries.
GitHub offers registries for
[npm](https://docs.github.com/en/packages/working-with-a-github-packages-registry/working-with-the-npm-registry),
[Maven](https://docs.github.com/en/packages/working-with-a-github-packages-registry/working-with-the-apache-maven-registry),
and [Gradle](https://docs.github.com/en/packages/working-with-a-github-packages-registry/working-with-the-gradle-registry),
and one can easily integrate the library's
publishing to these registries into the project release process. However, accessing the libraries
is more complicated. Even if the package is public, the user must authenticate to GitHub
to download the package. This need adds more complexity for the library user, and therefore,
it might not become a popular option in the open-source communities.

*Sample for publishing Node.js package to GitHub npm registry via GitHub action:*

```yaml
name: release
on:
  push:
    tags:
      - '*'
jobs:
  publish-github:
    # runner machine
    runs-on: ubuntu-latest
    # API permissions for the job
    permissions:
      contents: read
      packages: write
    steps:
      # checkout the repository code
      - uses: actions/checkout@v4
      # setup node environment
      - uses: actions/setup-node@v4
        with:
          node-version: '18.x'
          registry-url: 'https://npm.pkg.github.com'
          scope: 'findy-network'
      # install dependencies, build distributables and publish
      - run: npm ci
      - run: npm run build
      - run: npm publish
        env:
          NODE_AUTH_TOKEN: ${{ secrets.GITHUB_TOKEN }}
```

### Executables And Other Artifacts

For other artifacts, we utilize
[the GitHub releases feature](https://docs.github.com/en/repositories/releasing-projects-on-github/about-releases).
For instance, we use the [`goreleaser`](https://goreleaser.com/)
helper tool for our [CLI](https://github.com/findy-network/findy-agent-cli),
which handles the cross-compilation of the executable for several platforms.
It then attaches the binary files to [the release](https://github.com/findy-network/findy-agent-cli/releases),
from where each user can download them.
We even have an automatically generated installation script that helps the user download
the correct version for the platform in question.

{{< imgproc release Fit "925x925" >}}
<em>CLI release has binaries for multiple platforms.
</em>
{{< /imgproc >}}

One can also attach other files to releases. We define our backend gRPC API with
[an IDL file](https://github.com/findy-network/findy-agent-api/tree/master/idl/v1).
Whenever the API changes, we release a new version of the IDL using a GitHub release.
We can then automate other logic (gRPC utility helpers) to download the IDL for a specific release
and easily keep track of the changes.

## Summary

This post summarized how our open-source project uses different GitHub features for versioning,
release management, and artifact distribution. In our [last article](/blog/2024/04/24/the-swiss-army-knife-for-the-agency-project-part-3-other-github-tools/),
we will review various
other GitHub tools we have utilized.
