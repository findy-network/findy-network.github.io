# findy-network.github.io

[![test](https://github.com/findy-network/findy-network.github.io/actions/workflows/test.yml/badge.svg?branch=dev)](https://github.com/findy-network/findy-network.github.io/actions/workflows/test.yml)

Findy Agency technical documentation and blog.

## Setup local environment

1. [Install hugo](https://gohugo.io/getting-started/installing/)

   - install latest version: `hugo version` > 0.78
   - You must install extended Sass/SCSS version
   - On Linux, **especially on Ubuntu**, which have `snap` use the following:

   ```sh
   snap install hugo --channel=extended
   ```
   - On ARM (Sample, Linux Ubuntu), you can easily build it by your own:
   ```console
   wget https://github.com/gohugoio/hugo/archive/refs/tags/v0.93.0.tar.gz
   tar -zxvf v0.93.0.tar.gz 
   cd hugo-0.93.0
   go build --tags extended
   sudo mv hugo /usr/local/bin/hugo
   ```

1. Clone repository:

   ```bash
   git clone --recurse-submodules --depth 1 git@github.com:findy-network/findy-network.github.io.git
   ```

   To get, e.g. `dev` branch from the server:
   ```bash
   git fetch origin dev:dev
   ```

1. Get PR branch to local examination:

   To get PR branch, e.g. `add-getting-started-blog` branch from the server:
   ```bash
   git fetch origin add-getting-started-blog:add-getting-started-blog
   ```

1. Run hugo

   By using a make rule `run` that will start hugo to be visible for the whole
   LAN or for `ngrok`.
   ```bash
   make run
   ```
   

   Naturally you can start it with hugo
   ```bash
   hugo server
   ```

   Or if you need to connect from some other host in the same network.

   ```bash
   hugo server --bind=0.0.0.0 --baseURL=http://0.0.0.0:1313
   ```

1. Open browser at http://localhost:1313 or if from other host use its address
   instead of `localhost`.

1. Problem Solving:
   - use extended version
   - first `git` cloning or must be used to get submodules (or to use some other
     methods to get them)
   - use latest version of hugo
   - when writing a blog post's hugo header be aware that the `date:` field tell
     hugo when to publish. If you are currently constructing the post **and want
     to see the rendering result use current or previous date**.
   - read error messages carefully, any of the blog posts can cause whole
     subtree unable to be rendered.

## Releasing

Releases to GitHub pages https://findy-network.github.io are done via GitHub actions on merge to master.
