# findy-network.github.io

Findy Agency technical documentation and blog.

## Setup local environment

1. [Install hugo](https://gohugo.io/getting-started/installing/)

1. Clone repository:

   ```bash
   git clone --recurse-submodules --depth 1 git@github.com:findy-network/findy-network.github.io.git
   ```

1. Install dependencies

   ```bash
   cd findy-network.github.io
   npm install
   ```

1. Run hugo

   ```
   hugo server
   ```

1. Open browser at http://localhost:1313


## Releasing

Releases to GitHub pages https://findy-network.github.io are done via GitHub actions on merge to master.
