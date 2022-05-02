---
date: 2022-04-27
title: "Trust in Your Wallet"
linkTitle: "Trust in Your Wallet"
description: "We have previously demonstrated how to speed up the leap to the SSI world
for applications utilizing third-party identity providers. Another shortcut for SSI adoption
is to use existing APIs when issuing credentials and build even so-called self-service issuers.
In this post, we showcase how to implement a service for issuing credentials for Finnish Trust Network data."
author: Laura Vuorenoja
resources:
  - src: "**.{png,jpg}"
    title: "Image #:counter"
---

[Our previous post](/blog/2022/04/07/ssi-empowered-identity-provider/) showed how to speed up
the leap to the SSI world for existing OIDC clients, i.e., web services using external identity
providers for their user authentication. Our demonstrated concept enabled users to log in to
web services using credentials from their identity wallet.

We used an FTN credential in [the demo](https://youtu.be/V5FWX0g3HVk). After reading the post and
seeing the demo, you may have wondered what this FTN credential is? Where did the user get it?
And how the web service can trust this mysterious credential? This post will concentrate
on these questions.

## The Cryptographic Magic

The core concept of self-sovereign identity is verified data. The idea is that entities can hold
cryptographically signed data (aka credentials) in their digital identity wallets. They can produce
proof of this data and hand it over to other parties for verification.

{{< imgproc triangle Fit "925x925" >}}
<em>The trust triangle describes the roles of the data verification scenario.
Verifier utilizes cryptography to verify the proof that the holder provides.</em>
{{< /imgproc >}}

The cryptographic magic during the verification allows the verifier to be sure of two aspects.
Firstly, the issuer was the one who issued the credential, and secondly, the issuer issued
it to the prover's wallet (and no one else's). The verifier must know the issuer's
public key for this magic to happen.

We showcased the cryptographic verification in the demo mentioned above. When logging in to
the sample web service, instead of providing the user name and password, the user made proof of
his credential and handed it over to the identity provider. The identity provider then verified the proof
cryptographically and read and provided the needed data to the sample service (OIDC client application).

{{< imgproc idp Fit "925x925" >}}
<em>OIDC demo actors in the trust triangle. The user creates proof of his FTN credential for
the identity provider's verification.</em>
{{< /imgproc >}}

## Who to Trust?

So cryptography gets our back regarding the authenticity of the data and its origin. But how can we
trust the issuer, the entity that created the credential initially?

{{< figure src="https://i.imgflip.com/2ab5u1.jpg" width="800px">}}

The answer to this question is no different from the present situation regarding dealing with third
parties. *We choose to trust the issuer.*

For example, consider the current OIDC flow, where identity providers deliver data from their silos
to the client applications (relaying parties). The client application implementers consciously
decide to trust that the IdP (identity provider) runs their server in a documented URL and
provides them with correct data in the OIDC protocol flows. They may have secrets and keys
to keep the OIDC data exchange secure and private, but ultimately, the decision to trust
the OIDC provider is part of the application design.

In the SSI scenario, we choose to trust the issuer similarly, only we are not aware of the issuer's
servers but their public key for signing the credential. In our OIDC login demo,
the client application ("issuer-tool") has decided to trust the "FTN service" that has issued
the data to the user's wallet.

## Finnish Trust Network

[Finnish Trust Network](https://www.kyberturvallisuuskeskus.fi/en/our-activities/regulation-and-supervision/electronic-identification)
(FTN) consists of "strong electronic identification" providers. The concept
means proving one's identity in electronic services that meets specific requirements laid down
by Finnish law. The identity providers are required to implement multi-factor authentication
to authenticate the users. The result data of the authentication process typically contains
the user's name and personal identification code.

{{< imgproc identity Fit "1025x1025" >}}
<em>
In the FTN flow, users usually authenticate using their bank ID.
Before the users start the authentication,
they select the identity provider in the identity service broker view.
</em>
{{< /imgproc >}}

FTN is an exciting playground for us as it is so essential part of the digital processes
of Finnish society. Integrating FTN in one way or another into the SSI wallet seems like a natural
next step for us when thinking about how to utilize verified data large scale in Finland.

Even though regulation may initially prohibit using SSI wallets as a
“strong electronic identification” method, the FTN credential could be part of onboarding wallet
users or provide additional security to services that currently use weak authentication.
[The selective disclosure](https://www.w3.org/TR/vc-data-model/#dfn-selective-disclosure) feature
would allow users to share only the needed data, e.g., age or name, without revealing sensitive
personal identification code information.

We decided to experiment with the FTN and create a PoC for a service (“FTN service”) that can issue
credentials through an FTN authentication integration. And as it happened, we met our old friend
OIDC protocol again.

## The Demo

The idea of the PoC FTN service is to authenticate users through FTN and issue a credential for
the received FTN data. The PoC integrates an [identity broker test service](<https://github.com/op-developer/Identity-Service-Broker-API>)
with dummy data that enables us to test out the actual authentication flow.

The process starts with the user reading the FTN service connection invitation QR code with his SSI wallet.
After the connection is ready,  the interaction with the FTN service and the user happens
in the mobile device browser. FTN service instructs the user to authenticate with
his bank credentials. After successful authentication, the FTN service receives
the user information and issues a credential for the data.

{{< youtube 7b4tKnSndxk >}}
*The demo video shows how the technical PoC works.
The user receives the FTN credential by authenticating himself with bank credentials.*

Our previous OIDC demo provided data from the credentials through the OIDC protocol.
In this FTN issuer demo, we utilized the OIDC protocol again but now used it *as
the credential data source*. Once the user has acquired the FTN credential to his wallet,
he can prove facts about himself without reauthenticating with his bank credentials.

### The Sequence Flow

The entire process sequence is below in detail:

{{< figure src="/blog/2022/04/27/trust-in-your-wallet/sequence.svg" >}}
*[Step-by-step sequence for the issuing process](https://github.com/findy-network/findy-issuer-tool/blob/master/api/README.md#ftn-credential-flow)*

## Food for Thought: Self-Service Issuers

In the SSI dream world of the future, each organization would have the capabilities to issue
credentials for the data they possess. Individuals could store these credentials in their wallets
and use them how they see fit in other services. Verified data would enable many use cases that
are cumbersome or even manual today. Only in the financial sector the possibilities to improve
various processes (for example, AML, KYC, or GDPR) are countless.

However, our pragmatic team realizes that this future may be distant, as the adoption of SSI
technologies seems to be still slow. The presented experimentation led us to consider another
shortcut to the SSI world. What if we could create similar services as the PoC FTN service
to speed up the adoption? These “issuer self-services” would utilize existing API interfaces
(such as OIDC) and issue credentials to users.

And at the same time, we could utilize another significant benefit of verified data technology:
*reducing the count of integrations between systems*.

Once we have the data available in the user’s wallet, we do not need to fetch it from online servers
and integrate services with countless APIs. Instead, the required data is directly available in
the digital wallets of different process actors using a standard protocol for verified data exchange,
Hyperledger Aries.

Also, from the application developer’s point of view, the count of integrations reduces only to one
point—and for that, the SSI agent provides the needed functionality.

## Try It Out

The codes are available on GitHub. You can set up the demo on your localhost by launching
[the agency](https://github.com/findy-network/findy-wallet-pwa/tree/dev/tools/env#agency-setup-for-local-development)
and [the issuer service](https://github.com/findy-network/findy-issuer-tool).
Once you have the services running, you can access the web wallet opening browser at `http://localhost:3000`
and the FTN service at `http://localhost:8081`.

If you have any questions about these demos or Findy Agency, you can contact our team and me
via [GitHub](https://github.com/findy-network), [LinkedIn](https://www.linkedin.com/in/lauravuorenoja/),
or [Twitter](https://twitter.com/vuorenoja). You can also find me in
[Hyperledger Discord](https://discord.gg/hyperledger).
