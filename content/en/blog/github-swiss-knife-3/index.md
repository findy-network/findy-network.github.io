---
date: 2024-04-24
title: "The Swiss Army Knife for the Agency Project, Part 3: Other Tools"
linkTitle: "Other GitHub Tools"
description: ""
author: Laura Vuorenoja
resources:
  - src: "**.{png,jpg}"
    title: "Image #:counter"
---

This article concludes the series by providing an overview of how our open-source project utilizes
GitHub as a software development platform. In this last part, we will examine documentation
and communication tools, as well as some utilities that help the development process.

## GitHub Pages

Already in the early days, when we started to experiment with SSI technology,
there arose a need to publish different experiment outcomes and findings to the rest of the community.
However, we were missing a platform to collect these different reports and articles.

Finally, when we decided to open-source our agency code, we also established a documentation site
along with the project. This blog has been valuable to us since then. It has worked as
a low-threshold publication platform, where we have collected our various opinions,
experimentation findings, and even technical guides. It has been a way of distributing information
and an excellent source for discussion. It is easy to refer to articles that even date back some
years when all of the posts are collected on the same site.

We use the Hugo framework for building the site, specifically with the Docsy theme,
which is especially suitable for software project documentation. The framework uses
a low-code approach, where most of the content can be edited as Markdown files.
However, when needed, modifications can also be made to the HTML pages quite easily.

We publish the site via GitHub Pages, a static website hosting solution that
GitHub offers for each repository. When the feature is enabled, the service serves
the content of the pages from a dedicated branch. A GitHub action handles the deployment,
i.e., builds the website and pushes the site files to this dedicated branch. The site URL
combines organization and repository names, excluding the "<organisation-name>" .github.io-named
repositories that one can find in the similarly formatted URL.

## Dependabot

Dependabot is a GitHub-offered service that helps developers with the security and
version updates of repository dependencies. When Dependabot finds a vulnerable dependency
that can be replaced with a more secure version, it creates a pull request that implements
this change. A similar approach exists with dependency version updates:
When a new version is released, Dependabot creates a PR with the dependency update to the new version.

The pull requests that the Dependabot creates are like any other PR.
The CI runs tests on Dependabot PRs similar to those, as with the changes developers have made.
One can review and merge the PR similarly.

Using Dependabot requires a comprehensive enough automated test set. The one who merges
the PR needs to confirm that the change will not cause regression. Manual testing is required
if the CI is missing the automated tests for the changes. In that case, we lose the benefit
of using the bot for automated PR creation, and it might even be more laborious to update
the dependencies one by one.

In our project, we used the principle of testing all the crucial functionality with
each change automatically. Therefore, it was safe for us to merge the Dependabot PRs without
manual intervention. We even took one step further. We enabled automatic merging for those
Dependabot PRs that passed the CI. In this approach, a theoretical risk exists that malicious code
is injected from the supply chain through the version updates without us noticing it. However,
we were willing to take the risk as we estimated that sparing a small team's resources
would be more important than shielding the experimental code from theoretical attacks.

## Notifications And Labeling

There are integrations one can use to send automatic notifications to different chat applications
from GitHub. We have used this feature to get notified when PRs are created and merged to keep
the whole team up-to-date on what changes are introduced. In addition, we always get
a notification when someone raises an issue in our repositories. It has allowed us
to react quickly to community questions and needs.

There have also been some problems regarding the notifications. The Dependabot integration
creates a lot of pull requests for several repositories, and sometimes,
the information flood is too much. Therefore, we have custom labeling functionality
that helps us automatically label PRs based on the files the changes affect.
The automatic labeling is implemented with GitHub Action, which is triggered on PR creation.
We can filter only the PR notifications needed for our chat integration using these labels.

Automatic labeling can be tremendously helpful, especially with large repositories
with many subprojects. Labels can also be used as a filter basis for GitHub Actions.
For instance, one can configure a specific test for changes that affect only a particular folder.
This approach can speed up the CI runtimes and save resources.

## Codespaces And CLI Tool

GitHub Codespaces was a less-used feature for our project. Still, we found it helpful,
especially when we organized workshops to help developers get started with agency application development.

Codespaces offers a cloud-based development environment that works as VS Code dev containers.
A repository can have a configuration for the environment, and the codespace is created and
launched based on that configuration. Once the codespace is up and running, the developers have
a ready development environment with all the needed bells and whistles. It removes a lot of
the setup hassle we usually encounter when using different operating systems and tools for development.

The GitHub CLI tool was another helpful tool we found during the agency project.
It offers the GitHub functionality most users are used to using through a browser via
the command line. The tool is especially useful for those who suffer from context switching
from terminal to browser and vice versa or who prefer to work from a terminal altogether.
In addition, the CLI tool can be used to automate certain routines, specifically in CI.

## Thanks for Reading

This article completes our three-part saga of using GitHub in our agency project.
I hope you have learned something from what you have read so far.
I am always happy to discuss our approach and hear if you have ideas and experiences on
how your team handles things!
