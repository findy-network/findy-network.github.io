---
date: 2023-06-13
title: "The Agency Workshop"
linkTitle: "The Agency Workshop"
description: "The Findy Agency workshop contains guided tracks for developers on how to build clients for Findy Agency. Students learn how to use the agency CLI tool to operate their identity agent in the cloud, run simple CLI chatbots, and build web applications with the programming language of their choice (Go, Typescript, or Kotlin)."
author: Laura Vuorenoja
resources:
  - src: "**.{png,jpg}"
    title: "Image #:counter"
---
During the Findy Agency project, our development team initially placed greater emphasis on running
and deploying the agency in terms of documentation.
Due to this prioritization, instructions on building agency
clients have gotten less attention. We have now fixed this shortcoming by publishing [the agency workshop](https://github.com/findy-network/agency-workshop)
to educate developers on using, building, and testing agency clients.

## Agency Clients

What exactly is an agency client? A client is a piece of software operated by an entity with
an identity (individual, organization, or thing). In the agency context, we have three types of clients:

1. CLI: a tool for managing the identity agent in the cloud using the command line interface.
1. Web Wallet: a web-based user interface for holding and proving credentials through a web browser.
1. API client: any application that manages the identity agent with Findy Agency API.

The workshop shows how to use the ready-built clients ([CLI tool](https://github.com/findy-network/findy-agent-cli)
and [web wallet](https://github.com/findy-network/findy-wallet-pwa)) and start
the development using the API. The workshop participant can choose from two tracks, the CLI track,
which demonstrates the agent operations with the CLI tool, and the code track, which
concentrates on the API calls and testing them with the web wallet. Both workshop branches
teach hands-on how SSI's basic building blocks work. Consequently, the participant learns
how to issue, receive and verify credentials utilizing the Findy Agency platform.

<img src="https://github.com/findy-network/agency-workshop/raw/master/track2.1-ts/docs/app-overview.png" /><br>

*The code track instructs on building a simple web application that issues and verifies credentials.*

{{< figure src="/blog/2023/02/06/how-to-equip-your-app-with-vc-superpowers/cover-issue.png" >}}
*Testing for the code track can be done using the web wallet application.*

**The workshop material is suitable for self-studying.** In this case, if the developer
does not have an instance of the agency running in the cloud, using a localhost deployment
with Docker containers is straightforward. The material is available in [a public
GitHub repository](https://github.com/findy-network/agency-workshop),
containing step-by-step instructions that are easy to follow.
Developers can choose the development environment according to their preferences,
from native localhost setting to VS Code dev container or [GitHub Codespaces](https://github.com/findy-network/agency-workshop-codespace).

## Live Workshops

The Findy Agency team has organized the workshop also in a live setting.
We invited developers from our company interested in future technologies
to technical sessions for learning together. These sessions took place in both Helsinki and Oulu
during Spring 2023.

The events started with Harri explaining
[the basic SSI principles](/docs/slides/introduction-to-ssi/)
and then Laura presenting [demos of agency client applications](https://www.youtube.com/@optechlab9732/videos)
that the team has built in the past. The introductory presentations generated
many exciting questions and discussions that helped the participants better understand the concept.

{{< imgproc harri Fit "825x825" >}}
<em>Harri introducing SSI principles.</em>
{{< /imgproc >}}

After the introduction part, the participants could pick the track they were going to work on,
and they had a chance to advance with the tasks at their own pace. The developers could use a
shared agency installation in the cloud, so, in principle, setting up the development environment
was relatively effortless.

Unfortunately, during the first session, we encountered challenges with the shared cloud agency
and observed a few inconsistencies in the instructions for configuring the development environment.
We addressed these findings before the second session was held, which proved highly successful.
In fact, the second workshop was so seamless that the instructors found it almost uneventful,
as nearly no participants needed assistance.

{{< imgproc workshop Fit "825x825" >}}
<em>The happy bunch at Helsinki event.</em>
{{< /imgproc >}}

Both events received good feedback, as working hands-on helped the participants understand
more deeply the idea behind the technology and how one can integrate the tooling into
any application. The participants also thought these workshops were an inspiring way
to learn new things. Future ideas were to organize a hackathon-style event where
the teams could concentrate more on the actual use cases now that they understand the basic tooling.

## Are You Ready to Take the Challenge?

We recommend the workshop for all developers who are interested in decentralized identity.
The tasks require no special skills and have detailed instructions on how to proceed
to the next step. Even non-technical people have been able to do the workshop successfully.

We are happy to take any feedback on how to make the material even better!
You can reach us via SoMe channels:

<div style="display: flex">
<span>
<img src="https://avatars.githubusercontent.com/u/29113682?v=4%22" width="100"/>
<div>Laura</div>
<div><a href="https://github.com/lauravuo/" target="_blank" rel="noopener noreferer"><i class="fab fa-github ml-2 "></i></a>
<a href="https://www.linkedin.com/in/lauravuorenoja/" target="_blank" rel="noopener noreferer"><i class="fab fa-linkedin ml-2 "></i></a>
<a href="https://fosstodon.org/@lauravuo" target="_blank" rel="noopener noreferer"><i class="fab fa-mastodon ml-2 "></i></a>
<a href="https://twitter.com/vuorenoja" target="_blank" rel="noopener noreferer"><i class="fab fa-twitter ml-2 "></i></a></div>
</span><span style="padding-left: 2em">
<img src="https://avatars.githubusercontent.com/u/11439212?v=4" width="100">
<div>Harri</div>
<div><a href="https://github.com/lainio/" target="_blank" rel="noopener noreferer"><i class="fab fa-github ml-2 "></i></a>
<a href="https://www.linkedin.com/in/harrilainio/" target="_blank" rel="noopener noreferer"><i class="fab fa-linkedin ml-2 "></i></a>
<a href="https://twitter.com/harrilainio" target="_blank" rel="noopener noreferer"><i class="fab fa-twitter ml-2 "></i></a></div>
</span></div><br><br>
