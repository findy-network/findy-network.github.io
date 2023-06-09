---
date: 2023-06-09
title: "The Time to Build SSI Capabilities Is Now"
linkTitle: "The Time to Build SSI Capabilities Is Now"
description: "The decentralized identity technology landscape is fragmented. Multiple credential formats and data exchange protocols are competing for adoption. The application developers cannot bet on the winning horse because of the technology's immatureness. As a result, organizations are hesitant to implement Self-Sovereign Identity (SSI) solutions. However, waiting for the technology to become perfect is not the answer."
author: Laura Vuorenoja
resources:
  - src: "**.{png,jpg}"
    title: "Image #:counter"
---

During corridor discussions with various teams and organizations in recent months, I have been
surprised by the emphasis on the underlying technology in SSI implementations. Even non-technical
folks are wondering, e.g., which credential format will overcome them all. Don't get me wrong;
it's not that I don't see the importance of choosing the most interoperable, best performant,
and privacy-preserving cryptography. It's the fact we are hiding a more critical problem when
concentrating only on technical details.

## Focus on the Use Cases

Teams implementing flows utilizing SSI capabilities should focus primarily on the use case and,
more importantly, the user experience. If the flow requires an individual to use a wallet application
and several different web services, many users have a steep learning curve ahead of them.
It can even be too steep. Furthermore, we should also think outside of "the individual-user-box."
How can we utilize this technology in a broader range of use cases, for instance,
inter-organizational transactions?

Therefore, we need more real-world use cases implemented with SSI technology to develop it correctly.
After all, the use cases should ultimately be the source of the requirements, the drivers of how
to bring the technology further. And if use case implementors are waiting for the technology
to become ready, we have a severe chicken-egg problem.

Instead of overthinking the low-level crypto operations, etc., the teams should concentrate
on the high-level building blocks of SSI. The starting point should be clarifying
the issuer's, holder's, and verifier's roles. What exactly happens when data is
issued and verified? And how can the team apply the verifiable data in the use case
in question: who are the issuer, holder, and verifier? Furthermore, what data does
the issuer sign, and which part is available to the verifier?

## It Is All About Communication

After figuring out answers to these questions, the selection of the technical stack
becomes more relevant. However, even then, I would put less weight on the credential
format selection. What is even more important is the used credential exchange protocol.

For instance, if your primary use case is user identification and authentication,
and you wish to create an architecture that suits well and fast in the legacy world,
the most straightforward choice is a protocol offering strict client-server roles
and HTTP-request-response style API. In this style, the issuer, holder, and
verifier roles are hard-coded, and one party cannot simultaneously play multiple parts.

{{< imgproc cover Fit "925x925" >}}
<em>DIDComm and Hyperledger Aries are examples of a symmetric protocols. Findy Agency
supports currently both.</em>
{{< /imgproc >}}

However, choosing a symmetric protocol may widen the spectrum of your use cases.
Participants can execute different functions during the interaction in a symmetric protocol.
So, for example, in the user authentication scenario, in addition to the service (server)
authenticating the user (client) based on verified data, the individual could
also get a verification from the service-operating organization of its authenticity.

## Integrate Carefully

Whichever stack you choose, there are two things to keep in mind

1. Implement the integration to the library or service providing SSI functionality following
well-known modular principles so that it is easy to replace with a different library or service.
1. Do not let the underlying technology details pollute your application code.
Thus, ensure the SSI tooling you use hides the implementation details related
to credentials formats and protocol messages from your application.
This approach ensures that changes, for example, to the credential data format,
have a manageable effect on your application.

<br><img src="https://github.com/findy-network/agency-demo/raw/master/client/public/seo-logo.jpg?raw=truef" width="800px" /><br>

*Decentralized Identity Demo is a cool SSI simulation. Its original developer is [Animo](https://animo.id/),
and the SSI functionality was done using [aries-framework-javascript](https://github.com/hyperledger/aries-framework-javascript).
As an experiment for SSI technology portability, I took
the open-sourced codes and converted the application to use [Findy Agency](https://findy-network.github.io/)
instead of AFJ. You can find both [the original codes](https://github.com/animo/animo-demo)
and [my version](https://github.com/findy-network/agency-demo) in GitHub.*

The best option is to pick open-source tooling so that if some functionality is missing,
you can roll up your sleeves and implement it yourself. If this is not an option,
select a product that ensures compatibility with multiple flavors of SSI credentials
and data exchange protocols so that interoperability with other parties is possible.
After all, if there is no interoperability, there is no decentralization.

## The Time Is Now

The recent advancements in LLM technology and ChatGPT offer a glimpse of what's possible
when large audiences can suddenly access new technology that provides them added value.
SSI can potentially revolutionize digital services similarly, and organizations
should prepare for this paradigm shift. Is your organization ready when this transformation takes place?

In conclusion, now is the time to plan, experiment and build SSI capabilities. Begin
by understanding the high-level building blocks and experimenting with the technology
that best aligns with your use case. The technology will mature in time, and
the application layer will be unaffected if implemented correctly.
