---
date: 2024-04-22
title: "The Swiss Army Knife for the Agency Project, Part 1: GitHub Actions"
linkTitle: "GitHub Actions"
description: "Our research project has been using GitHub tools now for years. In addition to code hosting, GitHub offers vast capabilities for continuous integration, dependency management, release management, artifact distribution, project organization, and community communications. In this article series, I summarize our team's different experiments regarding GitHub features."
author: Laura Vuorenoja
resources:
  - src: "**.{png,jpg}"
    title: "Image #:counter"
---

Our research project has been using GitHub tools now for years. In addition to code hosting,
GitHub offers [vast capabilities](https://github.com/features/)
for continuous integration, dependency management,
release management, artifact distribution, project organization, and community communications.
These tools are free for publicly hosted open-source projects.

We have used these tools with an experimental spirit, gathering experience from
the different features. Although our project does not aim directly at production,
we take a production-like approach to many things we do.

In this article series, I summarize our team's different experiments regarding GitHub features.
As GitHub's functionality is easily extensible through its API and abilities
for building custom GitHub actions, I also explain how we have built custom solutions for some needs.

This first part overviews GitHub Actions as a continuous integration platform.
[The second part](/blog/2024/04/23/the-swiss-army-knife-for-the-agency-project-part-2-release-management-with-github/)
concentrates on release management and software distribution. Finally, in the last post, we introduce
other useful integrations and features we used during our journey.

## CI Vets the Pull Requests

[GitHub Actions](https://docs.github.com/en/actions) is a continuous integration and
continuous delivery (CI/CD) platform
for building automatic workflows. One defines the workflows as YAML configurations,
which get stored along with repository code in a dedicated subfolder (`.github/workflows`).
The GitHub-hosted platform automatically picks up and executes these workflows
when defined trigger events happen.

*Snippet below shows an example of a GitHub Actions workflow configuration:*

```yaml
name: test
on:
  # run whenever there is a push to any branch
  push:
jobs:
  test:
    # runner machine
    runs-on: ubuntu-latest
    steps:

      # check out the repository code
      - uses: actions/checkout@v4

      # setup node environment
      - uses: actions/setup-node@v4
        with:
          node-version: '18.x'

      # install dependencies, build, test
      - name: install deps
        run: npm ci
      - name: build
        run: npm run build
      - name: test
        run: npm test

      # upload test coverage to external service
      - name: upload coverage
        uses: codecov/codecov-action@v4
        with:
          files: ./coverage/coverage-final.json
          fail_ci_if_error: true
          token: ${{ secrets.CODECOV_TOKEN }}
```

In our project development model, developers always introduce changes through a pull request.
CI runs a collection of required checks for the pull request branch, and only when the checks
succeed can the changes be integrated into the main development branch.

{{< imgproc cover Fit "1025x1025" >}}
<em>CI checks are visible in the pull request view.
</em>
{{< /imgproc >}}

Our code repositories typically have a dedicated workflow for running linting, unit testing,
license scanning, and e2e tests. CI runs these workflow jobs whenever the developer pushes
changes to the PR branch. The CI jobs are visible in the PR view,
and merging is impossible if some required checks fail.

## Actions Simplify the Workflows

The basic structure of a GitHub Actions job definition contains:

* Setting up the base environment for the workflow.
* Checking out the repository code.
* Execution steps that one can define as command-line scripts or actions.

Actions are reusable components written to simplify workflows. GitHub offers actions for
the most commonly needed functionalities. You can also create custom actions specific
to your needs or search for the required functionality in [the actions marketplace](https://github.com/marketplace?type=actions),
where people can share the actions they have made.

*[Example](https://github.com/findy-network/findy-agent-vault/blob/master/.github/workflows/test.yml)
of using a custom action in a workflow:*

```yaml
name: test
on: push
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - name: setup go, lint and scan
        uses: findy-network/setup-go-action@master
        with:
          linter-config-path: .golangci.yml
```

For instance, we have written a custom action for our Go code repositories. These repositories
need similar routines to set up the Go environment, lint the code, and check
its dependencies for incompatible software licenses. We have combined this functionality into
one custom action we use in each repository. This way, the workflow definition is kept more compact,
and implementing changes to these routines is more straightforward as we need to edit only
the shared action instead of all the workflows.

*Custom action [configuration example](https://github.com/findy-network/setup-go-action/blob/master/action.yml):*

```yaml
runs:
  using: "composite"
  steps:

    # setup go environment
    - uses: actions/setup-go@v5
      if: ${{ inputs.go-version == 'mod' }}
      with:
        go-version-file: './go.mod'
    - uses: actions/setup-go@v5
      if: ${{ inputs.go-version != 'mod' }}
      with:
        go-version: ${{ inputs.go-version }}

    # run linter
    - name: golangci-lint
      if: ${{ inputs.skip-lint == 'false' }}
      uses: golangci/golangci-lint-action@v4
      with:
        version: ${{ inputs.linter-version }}
        args: --config=${{ inputs.linter-config-path }} --timeout=5m

    # run license scan
    - name: scan licenses
      shell: bash
      if: ${{ inputs.skip-scan == 'false' }}
      run: ${{ github.action_path }}/scanner/scan.sh
```

In this shared action, [`setup-go-action`](https://github.com/findy-network/setup-go-action),
we can run our custom scripts or use existing actions.
For example, we set up the Go environment with [`actions/setup-go`](https://github.com/actions/setup-go),
which is part of
the GitHub offering. Then, we lint the code using
the [`golangci/golangci-lint`](https://github.com/golangci/golangci-lint) action,
which is made available by the golangci-team. Lastly, the action utilizes our script to scan
the licenses. We can efficiently combine and utilize functionality crafted by others and ourselves.

## Runners Orchestrating E2E-tests

In addition to linting, scanning, and unit tests, we typically run at least one e2e-styled test
in parallel. In e2e tests, we simulate the actual end-user environment where the software
will be run and execute tests with bash scripts or test frameworks that allow us
to run tests through the browser.

{{< imgproc wf-run Fit "1025x1025" >}}
<em>GitHub Actions workflow view run shows the jobs and their hierarchy.
The artifacts and logs are available for each job also in this view.
</em>
{{< /imgproc >}}

In these e2e tests, we typically set up the test environment using Docker containers,
and the GitHub-hosted runners have worked well for orchestrating the containers.
We can define needed container services in the workflow YAML configuration or use, e.g.,
Docker's compose tool directly to launch the required containers.

*[Example](https://github.com/findy-network/findy-agent-vault/blob/master/.github/workflows/test.yml#L21)
of defining a needed database container in a GitHub Actions workflow:*

```yaml
    services:
      postgres:
        image: postgres:13.13-alpine
        ports:
          - 5433:5432
        env:
          POSTGRES_PASSWORD: password
          POSTGRES_DB: vault
```

## External Integrations

Once the CI has run the tests, we use an external service to analyze the test coverage data.
[Codecov.io](https://github.com/codecov/codecov-action)
service stores the coverage data for the test runs. It can then use the stored
baseline data to compare the test run results of the specific pull request.
Once the comparison is ready, it gives feedback on the changes' effect on the coverage.
The report gets visualized in the pull request as a comment and
line-by-line coverage in the affected code lines.

{{< imgproc codecov Fit "1025x1025" >}}
<em>Codecov.io inserts the coverage report as a comment to the pull request view through the GitHub API.
</em>
{{< /imgproc >}}

Codecov is an excellent example of integrating external services into GitHub Actions workflows.
Each integration needs a GitHub application that gives the third-party tool access
to your organization's resources. The organization must review the required permissions
and install the application before GitHub allows the integration to work. One can also build
GitHub applications for custom purposes.
[Read more](http://localhost:1313/blog/2024/03/27/managing-github-branch-protections/)
about how a GitHub application can be helpful when automating release versioning.

## Next Up: Release Management

This article gave an overview of how Findy Agency uses GitHub Actions as a continuous
integration platform. The next one will be about
[release management](/blog/2024/04/23/the-swiss-army-knife-for-the-agency-project-part-2-release-management-with-github/).
Stay tuned.
