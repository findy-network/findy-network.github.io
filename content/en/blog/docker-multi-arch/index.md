---
date: 2021-09-20
title: "The Arm Adventure on Docker"
linkTitle: "The Arm Adventure on Docker"
description: "Since the Findy Agency project launched, Docker has been one of our main tools to help set up the agency development and deployment environments. Unexpected headache developed when our colleague purchased a M1 Mac and our images refused to run on ARM platform."
author: Laura Vuorenoja
resources:
- src: "**.{png,jpg}"
  title: "Image #:counter"
---

Since the Findy Agency project launched, Docker has been one of our main tools to help set up the agency development and deployment environments. First of all, we use Docker images for our cloud deployment. On a new release, the CI build pipeline bundles all needed binaries to each service image. After the build, the pipeline pushes Docker images to [the GitHub container registry](https://github.blog/2020-09-01-introducing-github-container-registry/), from where the deployment pipeline fetches them and updates the cloud environment. 

{{< imgproc agency-deployment-pipeline Fit "925x925" >}}
<em>Agency deployment pipeline: New release triggers image build in GitHub actions. When the new image is in the registry, AWS Code Pipelines handles the deployment environment update.</em>
{{< /imgproc >}}


In addition, we've used Docker to take care of the service orchestration in a local development environment. Agency consists of three different services, and if one wishes to set agency fully up on a local desktop, it is straightforward by executing a docker-compose script. The script pulls correct images to the local desktop and sets needed configuration parameters. Without the orchestration, setting up and updating the three services would be cumbersome.

{{< imgproc arch-overview Fit "625x625" >}}
<em>High-level architecture of Findy Agency. Setting up agency to localhost is most straightforward with the help of container orchestration tool.</em>
{{< /imgproc >}}

Until recently, we were happy with our image-building pipeline. Local environments booted up with ease, and the deployment pipeline rolled out updates beautifully. Then one day, our colleague with an M1-equipped Mac tried out the docker-compose script. Running the agency images in an Arm-based architecture was something we hadn't considered. We built our Docker images for amd64 architecture, while M1 Macs expect container images for arm64 CPU architecture. It became clear we needed to support also the arm64, as we knew that the popularity of the M1 chipped computers would only increase in the future.

## Multi-architecture Support in Docker

Typically, when building images for Docker, the image inherits the architecture type from the building machine. And as each processor architecture requires a dedicated Docker image, one needs to build a different container image for each target architecture. To avoid the hassle with the multiple images, Docker has added support for multi-architecture images. It means that there is a single image in the registry, but it can have many variants. Docker will automatically choose the appropriate architecture for the processor and platform in question and pull the correct variant.

Ok, so Docker takes care of the image selection when running images. How about building them then? There are [three strategies](https://docs.docker.com/buildx/working-with-buildx/#build-multi-platform-images).
1. **QEMU emulation support in the kernel**: QEMU works by emulating all instructions of a foreign CPU instruction set on the host processor. For example, it can emulate ARM CPU instructions on an x86 host machine. The QEMU emulator enables building images that target another architecture than the host.
1. **Multiple native nodes using the same builder instance**: With this approach, multiple hosts that run on different CPU architectures execute the build. The build time is faster. The drawback is that it requires access to native nodes.
1. **Stage in a Dockerfile for cross-compilation**: This option is possible with languages that support cross-compilation. Arguments exposing the build and the target platforms are automatically available to the build stage. The build command can utilize these parameters to build the binary for the correct target.

From these three options, we chose the first one, as it seemed the most straightforward route. However, in our case, the third option might have worked as well since we are building with tools that support cross-compilation, Rust, and GoLang. 

A Docker CLI plugin, [buildx](https://docs.docker.com/buildx/working-with-buildx/), is required to build multi-architecture images. It extends the docker command with additional features, the multi-architecture build capability being one of them. Using buildx is almost the same as using the ordinary Docker build function. The target platform is added to the command wit the flag `--platform`.

Example of building Docker image with buildx for arm64:
```bash
docker buildx build --platform linux/arm64 -t image_label .
```

## Building the Images

Now we had chosen the strategy and had the tools installed. The next step was to review each image stack and ensure that it was possible to build all image layers for the needed variants.

Our default image stack consists of [the custom base image](https://github.com/findy-network/findy-common-go/blob/master/infra/aws/Dockerfile.indy.ubuntu) and an application layer (service binary in question). The custom base image contains some tools and libraries that are common for all of our services. It expands the official Docker image for Ubuntu. For the official Docker images, there are no problems since Docker provides the needed variants out-of-the-shelf. However, our custom base image installs indy-sdk libraries from the Sovrin Debian repository, and unfortunately, the Debian repository did not provide binaries for arm64. So instead of installing the library from the Debian repository, we needed to add [a build step](https://github.com/findy-network/findy-common-go/blob/8bef1cbc4cc7d698275a69a9c9c4aff2622b84de/infra/aws/Dockerfile.indy.ubuntu#L12) that would build and install the indy-sdk from the sources.

Otherwise, building for arm64 revealed no problems. The only needed change was that some of our server start scripts were missing [shebangs](https://en.wikipedia.org/wiki/Shebang_(Unix)) from the start of the script file. For yet an unknown reason, it prevented the shell from running the script properly on an arm64 container. The problem was fixed easily by adding the missing shebangs.

The final step was to modify our GitHub Actions pipelines to build the images for the different architectures. Fortunately, Docker provides ready-made actions for setting up QEMU (*[setup-qemu-action](https://github.com/docker/setup-qemu-action)*) and buildx (*[setup-buildx-action](https://github.com/docker/setup-buildx-action)*), logging to the Docker registry (*[login-action](https://github.com/docker/login-action)*), and building and pushing the ready images to the registry (*[build-push-action](https://github.com/docker/build-push-action)*).

We utilized the actions provided by Docker and [the release workflow](https://github.com/findy-network/findy-agent/blob/master/.github/workflows/release.yml) for findy-agent looks now like this:

```yml
name: release
on:  
  push:
    tags:
      - '*'
jobs:

  push-image:
    runs-on: ubuntu-latest
    permissions:
      packages: write
      contents: read
    steps:
      - uses: actions/checkout@v2

      - name: Set up QEMU
        uses: docker/setup-qemu-action@v1
        with:
          platforms: all

      - name: Set up Docker Buildx
        uses: docker/setup-buildx-action@v1

      - name: Login to Registry
        uses: docker/login-action@v1
        with:
          registry: ghcr.io
          username: ${{ github.repository_owner }}
          password: ${{ secrets.GITHUB_TOKEN }}

      - run: echo "version=$(cat ./VERSION)" >> $GITHUB_ENV

      - uses: docker/build-push-action@v2
        with:
          platforms: linux/amd64,linux/arm64
          push: true
          tags: |
            ghcr.io/${{ github.repository_owner }}/findy-agent:${{ env.version }}
            ghcr.io/${{ github.repository_owner }}/findy-agent:latest
          cache-from: type=registry,ref=ghcr.io/${{ github.repository_owner }}/findy-agent:latest
          cache-to: type=inline
          file: ./scripts/deploy/Dockerfile
```

The result was as expected, the actions take care of the building successfully. Building of the images is considerably slower with QEMU but luckily the build caches speed up the process a bit.

Now have the needed variants for our service images in the registry. Furthermore, our colleague with the M1-Mac can run the agency successfully with his desktop.

{{< imgproc findy-agent-packages Fit "925x925" >}}
<em><a href="https://github.com/findy-network/findy-agent/pkgs/container/findy-agent">Docker registry</a> for Findy agent</em>
{{< /imgproc >}}






