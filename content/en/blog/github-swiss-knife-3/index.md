---
date: 2024-04-24
title: "The Swiss Army Knife for the Agency Project, Part 3: Other GitHub Tools"
linkTitle: "Other GitHub Tools"
description: "This post concludes the article series that provides an overview of how our open-source project utilizes the GitHub platform for software development. In this last part, we will examine other useful features such as GitHub Pages, Dependabot and automatic PR labeling."
author: Laura Vuorenoja
draft: true
resources:
  - src: "**.{png,jpg}"
    title: "Image #:counter"
---

This post concludes the article series that provides an overview of how our open-source project
utilizes the GitHub platform for software development. In this last part, we will examine documentation
and communication tools, as well as some utilities that help the development process.

## GitHub Pages

Already in the early days, when we started to experiment with SSI technology,
there arose a need to publish different experiment outcomes and findings to the rest of the community.
However, we were missing a platform to collect these different reports and articles.

Finally, when [we decided to open-source our agency code](/blog/2021/08/11/announcing-findy-agency/),
we also established a documentation site and blog. [This site](https://findy-network.github.io/)
has been valuable to us since then. It has worked as
a low-threshold publication platform, where we have collected our various opinions,
experimentation findings, and even technical guides. It has been a way of distributing information
and an excellent source for discussion. It is easy to refer to articles that even date back some
years when all of the posts are collected on the same site.

We use [the Hugo framework](https://gohugo.io/) for building the site, specifically
[the Docsy theme](https://www.docsy.dev/),
which is especially suitable for software project documentation. The Hugo framework uses
a low-code approach, where most of the content can be edited as Markdown files.
However, when needed, modifications can also be made to the HTML pages quite easily.

{{< imgproc cover Fit "825x825" >}}
<em>The project site serves as a platform for documentation and blogs.
</em>
{{< /imgproc >}}

We publish the site via [GitHub Pages](https://pages.github.com/),
a static website hosting solution that
GitHub offers for each repository. When the Pages feature is enabled, GitHub serves
the content of the pages from a dedicated branch.
[A GitHub action handles the deployment](https://github.com/findy-network/findy-network.github.io/blob/f72bcd9cdec4882eae541320f5dce48499965d4f/.github/workflows/on-release.yml#L7),
i.e., builds the website and pushes the site files to this dedicated branch. The site URL
combines organization and repository names. An exception is the `<organisation-name> .github.io`-named
repositories that one can find in the similarly formatted URL, e.g., our
[`findy-network/findy-network.github.io`](https://github.com/findy-network/findy-network.github.io)
repository is served in URL <https://findy-network.github.io>.

## Dependabot

[Dependabot](https://docs.github.com/en/code-security/dependabot) is a GitHub-offered service
that helps developers with the security and
version updates of repository dependencies. When Dependabot finds a vulnerable dependency
that can be replaced with a more secure version, it creates a pull request that implements
this change. A similar approach exists with dependency version updates:
When a new version is released, Dependabot creates a PR with the dependency update to the new version.

{{< imgproc dependabot Fit "825x825" >}}
<em>Dependabot analyzes the project dependencies based on the dependency graph.
It creates PRs for security and version updates automatically.
</em>
{{< /imgproc >}}

The pull requests that the Dependabot creates are like any other PR.
The CI runs tests on Dependabot PRs similar to those, as with the changes developers have made.
One can review and merge the PR similarly.

Using Dependabot requires a comprehensive enough automated test set. The one who merges
the PR needs to confirm that the change will not cause regression. Manual testing is required
if the CI is missing the automated tests for the changes. If one needs manual testing, the benefit
of using the bot for automated PR creation is lost, and it might even be more laborious to update
the dependencies one by one.

In our project, we used the principle of testing all the crucial functionality with
each change automatically. Therefore, it was safe for us to merge the Dependabot PRs without
manual intervention. We even took one step further. We enabled automatic merging for those
Dependabot PRs that passed the CI. In this approach, a theoretical risk exists that malicious code
is injected from the supply chain through the version updates without us noticing it. However,
we were willing to take the risk as we estimated that sparing a small team's resources
would be more important than shielding the experimental code from theoretical attacks.

*CI enables the automatic merging of Dependabot PRs on pull request creation*:

```yaml
name: "pr-target"
on:
  pull_request_target:

  # automerge successful dependabot PRs
  dependabot:
    # action permissions
    permissions:
      pull-requests: write
      contents: write
    # runner machine
    runs-on: ubuntu-latest
    # check that the PR is from dependabot
    if: ${{ github.event.pull_request.user.login == 'dependabot[bot]' }}
    steps:
      - name: Dependabot metadata
        id: dependabot-metadata
        uses: dependabot/fetch-metadata@v2
      - name: Enable auto-merge for Dependabot PRs
        # check that target branch is dev
        if: ${{steps.dependabot-metadata.outputs.target-branch == 'dev'}}
        # enable PR auto-merge with GitHub CLI
        # PR will be automatically merged if all checks pass
        run: gh pr merge --auto --merge "$PR_URL"
        env:
          PR_URL: ${{github.event.pull_request.html_url}}
          GH_TOKEN: ${{secrets.GITHUB_TOKEN}}
```

## Notifications And Labeling

There are chat application integrations (for example [Teams](https://github.com/integrations/microsoft-teams),
[Slack](https://slack.github.com/))
one can use to send automatic notifications from GitHub. We have used this feature to get notified
when PRs are created and merged to keep
the whole team up-to-date on what changes are introduced. In addition, we always get
a notification when someone raises an issue in our repositories. It has allowed us
to react quickly to community questions and needs.

There have also been some problems regarding the notifications. The Dependabot integration
creates a lot of pull requests for several repositories, and sometimes,
the information flood is too much. Therefore, we have custom labeling functionality
that helps us automatically label PRs based on the files the changes affect.
The automatic labeling is implemented with [GitHub Action](https://github.com/actions/labeler),
which is triggered on PR creation.
We can filter only the PR notifications needed for our chat integration using these labels.

Automatic labeling can be tremendously helpful, especially with large repositories
with many subprojects. Labels can also be used as a filter basis for GitHub Actions.
For instance, one can configure a specific test for changes that affect only a particular folder.
This approach can speed up the CI runtimes and save resources.

## Codespaces And CLI Tool

[GitHub Codespaces](https://github.com/features/codespaces) was a less-used feature for our project.
Still, [we found it helpful](https://github.com/findy-network/agency-workshop-codespace),
especially when we organized workshops to help developers get started with agency application development.

Codespaces offers a cloud-based development environment that works as
[VS Code dev containers](https://code.visualstudio.com/docs/devcontainers/containers).
A repository can have a configuration for the environment, and the codespace is created and
launched based on that configuration. Once the codespace is up and running, the developers have
a ready development environment with all the needed bells and whistles. It removes a lot of
the setup hassle we usually encounter when using different operating systems and tools for development.

*Example of [a codespace configuration](https://github.com/findy-network/agency-workshop-codespace/blob/master/.devcontainer/devcontainer.json)
for our workshop participants. All the needed tools are preinstalled
to the codespace that one may need when doing the workshop exercises:*

```json
{
  "name": "Findy Agency workshop environment",
  "image": "ghcr.io/findy-network/agency-workshop-codespace:0.1.0",
  "workspaceFolder": "/home/vscode/workshop",
  "features": {
    "ghcr.io/devcontainers-contrib/features/direnv-asdf:2": {}
  },
  "customizations": {
    "vscode": {
      "extensions": [
        "golang.go",
        "mathiasfrohlich.Kotlin"
      ]
    }
  },
  "postCreateCommand": "asdf direnv setup --shell bash --version latest"
}
```

[The GitHub CLI](https://cli.github.com/) tool was another helpful tool we found during the agency project.
It offers the GitHub web application functionality via the command line. The tool is especially useful
for those who suffer from context switching
from terminal to browser and vice versa or who prefer to work from a terminal altogether.
In addition, the CLI tool can be used to automate certain routines, specifically in CI.

{{< imgproc cli Fit "825x825" >}}
<em>Example of listing PRs with the GitHub CLI tool.
</em>
{{< /imgproc >}}

## Thanks for Reading

This article completes our three-part saga of using GitHub in our agency project.
I hope you have learned something from what you have read so far.
I am always happy to discuss our approach and hear if you have ideas and experiences on
how your team handles things!

<div style="display: flex">
<span>
<img src="https://avatars.githubusercontent.com/u/29113682?v=4%22" width="100"/>
<div>Laura</div>
<div><a href="https://github.com/lauravuo/" target="_blank" rel="noopener noreferer"><i class="fab fa-github ml-2 "></i></a>
<a href="https://www.linkedin.com/in/lauravuorenoja/" target="_blank" rel="noopener noreferer"><i class="fab fa-linkedin ml-2 "></i></a>
<a href="https://fosstodon.org/@lauravuo" target="_blank" rel="noopener noreferer"><i class="fab fa-mastodon ml-2 "></i></a>
<a href="https://twitter.com/vuorenoja" target="_blank" rel="noopener noreferer"><i class="fab fa-twitter ml-2 "></i></a></div>
</span></div><br><br>
