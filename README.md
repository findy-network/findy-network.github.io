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

1. Clone repository:

   ```bash
   git clone --recurse-submodules --depth 1 git@github.com:findy-network/findy-network.github.io.git
   ```

1. Install dependencies

   ```bash
   cd findy-network.github.io
   npm install
   ```

1. Run hugo (`make run` just added)

   ```
   hugo server
   ```

   Or if you need to connect from some other host in the same network.

   ```
   hugo server --bind=0.0.0.0 --baseURL=http://0.0.0.0:1313
   ```

1. Open browser at http://localhost:1313 or if from other host use its address
   instead of `localhost`.

1. Problem Solving:
   - use extended version
   - use latest version
   - when writing a blog post's hugo header be aware that the `date:` field tell
     hugo when to publish. If you are currently constructing the post **and want
     to see the rendering result use current or previous date**.
   - read error messages carefully, any of the blog posts can cause whole
     subtree unable to be rendered.

## Releasing

Releases to GitHub pages https://findy-network.github.io are done via GitHub actions on merge to master.
