---
date: 2023-11-16
title: "Test Coverage Beyond Unit Testing"
linkTitle: "Coverage for E2E Tests"
description: "Automated testing is like having an extra member in your team, a shining knight against regression. Test coverage measurements and automatic test coverage monitoring help the team keep the knight shiny, i.e., automated test sets in good shape. Traditionally, we have measured the coverage for unit tests, but thorough CI pipelines also include other types of testing. Go has recently introduced new tooling that allows us to measure the test coverage for application tests and thus improve our capabilities for keeping our automated tests in shape automatically."
author: Laura Vuorenoja
resources:
- src: "**.{png,jpg}"
  title: "Image #:counter"
---


Automated testing is your superpower against [regression](https://en.wikipedia.org/wiki/Software_regression).
It prevents you from breaking existing
functionality when introducing new code changes. The most important aspect of automated testing
is **automation**. The testing should happen automatically in the continuous integration (CI) pipeline
whenever developers do code changes. If the tests are not passing, the team shouldn't merge
the changes to the main branch. I often regard the automated test set as
an extra team member – the team's tireless knight against regression.

{{< imgproc cover Fit "925x925" >}}
<em>Automated test set - the team's knight against regression</em>
{{< /imgproc >}}

## Complementing Unit Tests

The automated test set usually consists of many types of testing. Unit tests are
the bread and butter of any project's quality assurance process. But quite often,
we need something more to complement the unit tests.

We usually write simulation code for external functionality to keep the unit tests relevant,
modular, and fast to execute. However, wasting the team's resources on creating
the simulation code doesn't always make sense. Furthermore, we don't include simulation code
in the end product. Therefore, we should also have testing that verifies the functionality
with the proper external dependencies.

{{< imgproc application Fit "925x925" >}}
<em>Findy Agency application tests are run in GitHub Actions workflows,
utilizing docker-compose to orchestrate the agency services.</em>
{{< /imgproc >}}

Application (integration/e2e) tests execute the software without unit testing tooling
in the software's "real" running environment and with as many actual external dependencies
as possible. Those tests validate the functionality from the end user's point of view.
They complement unit tests, especially when verifying interoperability, asynchronous
functionality, and other software features that are difficult or impossible to test with unit testing.

## Keeping the Knight in Shape

Test coverage measurement is the process that can gather data on which code lines the test executes.
Typically, this tooling is available for unit tests. Although coverage measurement and
result data visualization can be handy in a local development cycle, I see the most value
when the team integrates the coverage measurement with the CI pipeline and automated monitoring
tooling that utilizes the coverage data.

The automated monitoring tool is an external service that stores the coverage data from
the test runs over time. When the team creates new pull requests, unit tests measure
the coverage data, and the pipeline sends the data to the monitor. It can then automatically
alert the team if the test coverage is about to decrease with the new changes.

{{< imgproc monitor Fit "925x925" >}}
<em><a href="https://about.codecov.io/" target="_blank">Codecov.io</a> is an example of
a SaaS-service that can be used as an automatic test coverage monitor.</em>
{{< /imgproc >}}

Thus, the automated coverage monitoring keeps the team's knight in good shape. Developers
cannot add new code without adding new tests to the knight's toolbox. Or at least
the decision to decrease the coverage needs to be made knowingly. Forgetting to add
tests is easy, but it gets trickier when someone nags you about it (automatically).

However, as stated above, we are used to measuring the coverage only for unit test runs.
But as we also test without the unit test tooling, i.e., application tests, we would like
to gather and utilize the data similarly for those test runs.

## Coverage for Application Tests

[Go 1.20 introduced a new feature flag](https://go.dev/blog/integration-test-coverage)
for the `go build` command, `-cover`.
The new flag enables the developer to build an instrumented version of the software binary.
When running the instrumented version, it produces coverage data for the run,
as with the unit tests.

```bash
# build with –cover flag
go build –cover -o ./program

# define folder for result files
export GOCOVERDIR=”./coverage”

# run binary (and the application tests)
./program

# convert and analyze result files
go tool covdata textfmt –i=$GOCOVERDIR –o coverage.txt
```

Using the new feature means we can include the test coverage of the application test runs in the automated monitoring scope. We put this new feature to use in the Findy Agency project.

## Instrumenting the Container Binary

Measuring the test coverage for application tests meant we needed to refactor our application testing
pipeline so that CI could gather the data and send it to the analysis tool.

{{< imgproc steps Fit "925x925" >}}
<em>Acceptance application test set for Findy Agency microservice are run using
<a href="https://github.com/findy-network/e2e-test-action" target="_blank">a dedicated GitHub Action</a>.
The action is capable of building and running the container with instrumented binary and reporting the
coverage data back to the parent job.</em>
{{< /imgproc >}}

* We use [a shared GitHub action](https://github.com/findy-network/e2e-test-action) to execute
the same application acceptance test set for all
our microservices. The action handles setting up the agency environment and running the test set.
* Service Docker images used in the application tests must have the instrumented binary.
We modified [the Docker image](https://github.com/findy-network/findy-agent-vault/blob/master/Dockerfile)
build phase to include the new `-cover` flag.
* We define the `GO_COVERDIR` environment variable in the service image,
and the environment definition maps that container path to a folder in the local environment.
* Once the agency is running, GitHub Action executes the tests. After test execution,
[CI copies the result files](https://github.com/findy-network/findy-agent-vault/blob/cda27be1aaacdf1e73f8c879408134ce1f2fa076/.github/workflows/test.yml#L30),
converts and sends them to the analysis tool as with unit tests.

{{< imgproc dockerfile Fit "625x625" >}}
<em>Changes required to service Dockerfile.</em>
{{< /imgproc >}}

## Increased Coverage

The change has the expected effect: coverage increased in our repositories where we introduced
this change. The coverage counts now in previously unmonitored code blocks, such as code in the `main`
function that was missing unit tests. The change improves our understanding of our testing scope and
helps us to keep our automated test set in better shape.

You can inspect the approach, for example, in the [findy-agent-vault](https://github.com/findy-network/findy-agent-vault/tree/master#findy-agent-vault)
repository CI configuration.

{{< youtube EwCFRVkqHic >}}
*Watch my "Boosting Test Coverage for Microservices" talk on GopherCon UK on YouTube.*

**Note!** The coverage data is lost if the process is forced to be terminated and it doesn't handle
the termination signal gracefully. Ungraceful termination prevents the added instrumentation code
from writing the coverage file. Therefore, the service needs to
have graceful shutdown in place. Also, the Docker container runtime needs to pass
the `SIGTERM` signal to the server process for this approach to work.
