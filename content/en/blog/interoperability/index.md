---
date: 2022-01-17
title: "Fostering Interoperability"
linkTitle: "Fostering Interoperability"
description: "Hyperledger Aries defines messaging protocols for identity agents capable of sharing verified data. Throughout Findy Agency development, the support for the Aries protocol and the compatibility with other Aries agents has been one of the top priorities for the project. Lately, we have lifted the interoperability testing to a new level by automating the testing and reporting with the help of tools provided by the Aries community. Furthermore, we received promising results from practical interoperability tests executed manually."
author: Laura Vuorenoja
resources:
  - src: "**.{png,jpg}"
    title: "Image #:counter"
---

Different services have different requirements and technical stacks; there are also multiple ways to implement the Aries agent support in an application. Some projects choose to rely on an Aries framework of a specific language and bundle the functionality within the service. Others might run the agent as a separate service or, as in the case of Findy Agency, as an agency that serves multiple clients.

{{< imgproc manual Fit "925x925" >}}
<em>Sending Aries basic messages between wallets from different technology stacks. See full demo in YouTube.</em>
{{< /imgproc >}}

Interoperability is a crucial element when we think about the adaptation and success of the Aries protocol. Even though the agent software might fulfill all the functional requirements and pass testing with use cases executed with a single agent technology stack, the story ending might be different when running the cases against another agent implementation. How can we then ensure that the two agents built with varying technology stacks can still work together and reach the same goals? Interoperability testing solves this problem. Its purpose is to verify that the agent software complies with the Aries protocol used to communicate between agents.

## Aries Interoperability Testing

Interoperability considerations came along quite early to the protocol work of the Aries community. The community faced similar challenges as other technical protocol developers have faced over time. When the number of Aries protocols increases and the protocol flows and messages are updated as the protocols evolve, how can the agent developers maintain compatibility with other agent implementations? The community decided to take [Aries Interoperability Profiles (AIPs)](https://github.com/hyperledger/aries-rfcs/tree/main/concepts/0302-aries-interop-profile) in use. Each AIP version defines a list of [Aries RFCs](https://github.com/hyperledger/aries-rfcs) with specific versions. Every agent implementation states which AIP version it supports and expects other implementations with the same version support to be compatible.

To ensure compatibility, the community had [an idea of a test suite](https://github.com/hyperledger/aries-rfcs/tree/main/concepts/0270-interop-test-suite) that the agent developers could use to make sure that the agent supports the defined AIP version. The test suite would launch the agent software and run a test set that measures if the agent under test behaves as the specific protocol version requires. The test suite would generate a report of the test run, and anyone could then easily compare the interoperability results of different agents.

At first, there were two competing test suites with different approaches to execute the tests. [Aries Protocol Test Suite (APTS)](https://github.com/hyperledger/aries-protocol-test-suite) includes an agent implementation that interacts with the tested agent through the protocol messages. On the other hand, [Aries Agent Test Harness (AATH)](https://github.com/hyperledger/aries-agent-test-harness) runs the tests operating the agent-client interface. This approach makes it possible to measure the compatibility of any two agent implementations. AATH seems to be the winning horse of the test suite race. Its test suite includes several test cases and has extensive reporting in place.

### Aries Agent Test Harness

Aries Agent Test Harness provides a BDD (behavioral driven) test execution engine and a set of tests derived from Aries RFCs. The aim is to run these tests regularly between different Aries agents (and agent frameworks) to monitor the compatibility score for each combination and catch compatibility issues.

Harness operates the agents under test through backchannels. Backchannel is a REST interface defined by [an OpenAPI definition](https://github.com/hyperledger/aries-agent-test-harness/blob/main/docs/assets/openapi-spec.yml), and its purpose is to pass the harness requests to the agents. The target is to handle the agent as a black box without interfering with the agent's internal structures. Thus, the backchannel uses the agent's client interface to pass on the harness requests.

{{< figure src="https://courses.edx.org/assets/courseware/v1/571727dd6d3f57d64158c9567f0d8ff2/asset-v1:LinuxFoundationX+LFS173x+1T2020+type@asset+block/The_Aries_Agent_Test_Harness.png" attr="image source: LinuxFoundationX LFS173x (CC BY 4.0)" attrlink="https://learning.edx.org/course/course-v1:LinuxFoundationX+LFS173x+1T2020/home" >}}

Harness utilizes Docker containers for testing. It launches a container based on a required agent image for each test scenario actor during the test run. Before the test run, one needs to build and bundle the agent-required services and the backchannel to a single agent image that provides both the agent and the backchannel functionality. The recipes for making each of the different agent images, i.e., Dockerfiles with the needed scripts, are stored in the AATH repository. The same repository also contains CI scripts for executing the tests regularly and generating [an extensive test report site](https://aries-interop.info/).

## Interoperability for Findy Agency

One of our main themes for 2H/2021 was to verify the Aries interoperability level for Findy Agency. When I investigated the Aries interoperability tooling more, it became evident that we needed to utilize the AATH to accomplish the satisfactory test automation level.

My first task was to create [a backchannel](https://github.com/findy-network/findy-agent-backchannel) for the harness to operate Findy Agency-hosted agents. Backchannel's role is to convert the harness's REST API requests to Findy Agency gRPC client interface. Another challenge was to bundle the agency microservices into a single Docker image. Each agency microservice runs in its dedicated container in a regular agency deployment. For AATH, I needed to bundle all of the required services into a single container, together with the backchannel. [The bundle](https://github.com/findy-network/findy-agent-backchannel/blob/master/aath/Dockerfile) is necessary because the harness runs a single container per agent.

Once the bundle was ready, I made [a PR to the AATH repository](https://github.com/hyperledger/aries-agent-test-harness/pull/341) to include Findy Agency in the Aries interoperability test set. We defined the supported AIP version (1.0) and the exception features (revocation). Tests exposed some essential but mainly minor interoperability issues with our implementation, and we were able to solve all of the found problems quite swiftly. The tests use the latest Findy Agency release with each test run. One can monitor [the test results for Findy Agency](https://aries-interop.info/findy.html) on the test result site.

{{< imgproc cover Fit "939x649" >}}
<em>Test result snapshot from <a href="https://aries-interop.info/" target="_blank" rel="noopener noreferer">Aries test reporting site</a></em>
{{< /imgproc >}}

In addition to interoperability testing, we currently utilize the AATH tooling for our functional acceptance testing. Whenever PR gets merged to our agency core repository that hosts the code for Aries protocol handlers, [CI builds](https://github.com/findy-network/findy-agent/blob/master/.github/workflows/iop.yml) an image of the code snapshot and runs a partial test set with AATH. The testing does not work as a replacement for unit tests but more as a last acceptance gate. The agency core runs in the actual deployment Docker container. The intention is to verify both the successful agency bootup and the functionality of the primary protocol handlers. This testing step has proven to be an excellent addition to our test repertoire.

### Manual Tests

Once the interoperability test automation reached an acceptable level, my focus moved to actual use cases that I could execute between the different agents.

My main interests were two wallet applications freely available in the app stores, [Lissi Wallet](https://lissi.id/) and [Trinsic Wallet](https://trinsic.id/trinsic-wallet/). I was intrigued by how Findy Agency-based applications would work with these identity wallets. I also wanted to test our Findy Agency web wallet with an application from a different technology stack. [BCGov](https://github.com/bcgov) provides a freely available test network that both wallet applications support, so it was possible to execute the tests without network-related hassle.

I executed the following tests:

- **Test 1: Findy Agency based issuer/verifier with Lissi Wallet**

  A Findy Agency utilizing issuer tool invites Lissi Wallet to form a pairwise connection. Issuer tool sends and verifies a credential with Lissi Wallet.

- **Test 2: Findy Agency Web Wallet with Trinsic Wallet**

  Findy Agency Web Wallet user forms a pairwise connection with Trinsic Wallet user. Wallet applications send Aries basic messages to each other.

- **Test 3: AcaPy based issuer/verifier with Findy Agency Web Wallet**

  Aries Test Harness runs [AcaPy](https://github.com/hyperledger/aries-cloudagent-python)-based agents that issue and verify credentials with Findy Agency Web Wallet.

The practical interoperability of Findy Agency also seems to be good, as proven with these manual tests. You can find the video of the test screen recording on YouTube.

## Next Steps

Without a doubt, Aries interoperability will be one of the drivers guiding the development of Findy Agency also in the future. With the current test harness integration, the work towards AIP2.0 is now easier to verify. Our team will continue working with the most critical Aries features relevant to our use cases. We also welcome contributions from others who see the benefit in building an OS world-class enterprise-level identity agency.
