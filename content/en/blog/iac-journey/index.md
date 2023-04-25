---
date: 2023-04-25
title: "Agency's IaC Journey"
linkTitle: "Agency's IaC Journey"
description: "Findy Agency's demo environment in the cloud has a fully automated deployment pipeline. The colorful history of the project's IaC tooling includes different phases, from writing CloudFormation YAML manually to porting the deployment on top of CDK pipelines."
author: Laura Vuorenoja
resources:
- src: "**.{png,jpg}"
  title: "Image #:counter"
---

In the early days of Findy Agency's development project, it became evident that we needed
a continuously running environment in the cloud to try out different proofs-of-concept (PoCs)
and demos quickly and easily. As our team is small, we wanted to rely heavily on automation
and avoid wasting time on manual deployments. At that time, I was interested in improving
my AWS skills, so I took the challenge and started working on a continuous PoC environment for our project.

{{< figure src="https://github.com/findy-network/findy-agent-infra/raw/master/aws-ecs/docs/arch.png" title="" width="925" >}}
*Overview of the AWS deployment for the demo environment*

## Setup infra without a hassle

From the start, it was clear that I wanted to use IaC (infrastructure as code) tools to define
our infra. My target was to create scripts that anyone could easily take and
set up the agency without a hassle.

I had been using [Terraform](https://www.terraform.io/) in some of my earlier projects, but using
a third-party tool typically requires compromises, so I wanted to take the native option for
a change with the IaC-tooling as well. At that time, there was only one choice: start writing
the CloudFormation templates manually.

[CloudFormation](https://aws.amazon.com/cloudformation/) is an AWS service that one can use
to provision the infrastructure with JSON- or YAML-formatted templates. CloudFormation stack
is an entity that holds the infrastructure resources. All the resources defined in
the stack template are created and removed together with the stack. One can manage
the infrastructure stacks through the AWS CLI or the CloudFormation UI.

## From manual YAML to CDK

So the first iteration of the agency's AWS infra code was about writing a lot of YAML definitions,
deploying them from the local laptop using the AWS CLI, fixing errors, and retrying.
The process could have been more efficient and successful in many ways. For example,
there was just not enough time to figure out everything needed and, in many cases,
the desired level of automation required to write countless custom scripts.

{{< imgproc yaml Fit "625x625" >}}
<em>Example of YAML template</em>
{{< /imgproc >}}

After some time of struggling with the YAML, AWS released the [CDK](https://aws.amazon.com/cdk/)
(Cloud Development Kit). The purpose of the CDK is to allow developers to write
the CloudFormation templates using familiar programming languages. CDK tooling converts
the code written by the developer to CloudFormation templates.

Writing static definitions using dynamic programming languages felt a bit off for me at first,
but I decided to try it. There were some evident benefits:

* CDK offers constructs that combine CloudFormation resources with higher-level abstractions.
There is less need to know the dirty details of each resource.
* Sharing, customizing, and reusing constructs is more straightforward.
* One can use her favorite IDE to write the infra code. Therefore tools like code completion are available.
* Also, there are other language-specific tools. One can apply dependency management, versioning,
and even unit testing to the infra code similarly to other software projects.

{{< imgproc cdk Fit "675x675" >}}
<em>Example of CDK code</em>
{{< /imgproc >}}

## The missing puzzle piece

Switching to CDK tooling boosted my performance for the infra work significantly.
Also, the manual hassle with the YAML templates is something I have not longed for at all.
Still, it felt like something was missing. I was still running the infra setup scripts
from my laptop. In my ideal world, the pipeline would create the infra, keeping things
more reproducible and less error-prone. Also, defining the build pipeline and the deployment
needed custom steps that made the initial agency setup still complex, which was something that
I wanted to avoid in the first place.

Well, time went on, and we were happy with the deployment pipeline: regardless of
the setup process, it worked as expected. However, in the spring of 2022, I saw
an [OP Software Academy](https://op-careers.fi/content/What-is-studying-at-the-Software-Academy-all-about/?locale=en_GB)
course about the CDK. The Academy is our internal training organization
that offers courses around several topics. I decided to join the class and learn more about CDK
and get some validation if I had done things correctly.

{{< imgproc pipeline Fit "625x625" >}}
<em>Pipeline creation with CDK code</em>
{{< /imgproc >}}

In the course, I found the missing piece of my puzzle. As it happened, AWS had just released [CDK v2](https://docs.aws.amazon.com/cdk/v2/guide/migrating-v2.html),
which introduced a new concept, [CDK pipelines](https://docs.aws.amazon.com/cdk/v2/guide/cdk_pipeline.html).
CDK pipeline is yet another higher-level abstraction, this time for AWS continuous integration
and deployment tools. It utilizes AWS CodePipeline to build, test and deploy the application.
The CDK pipeline's beauty lies in its setup: it is deployed only once from the developer's desktop.
After the creation, the pipeline handles the infra-deployment and subsequent changes to
the deployment or the pipeline via version control.

{{< imgproc cover Fit "925x925" >}}
<em>Evolution of Agency IaC tooling</em>
{{< /imgproc >}}

After porting our deployment on top of the CDK pipeline, the setup has finally reached my standards.
However, the future will show us how the Agency deployment will evolve. Perhaps we will introduce
a more platform-agnostic approach and remove AWS native tooling altogether.

 You can dive deeply into the anatomy of our CDK pipeline in my next blog post.
 And as always, you can find the codes on [GitHub](https://github.com/findy-network/findy-agent-infra/tree/master/aws-ecs#readme)!
