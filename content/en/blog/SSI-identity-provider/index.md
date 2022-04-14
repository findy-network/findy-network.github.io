---
date: 2022-04-07
title: "SSI-Empowered Identity Provider"
linkTitle: "SSI-Empowered Identity Provider"
description: "Open ID Connect (OIDC) is a popular identity protocol for authenticating users and providing identity data for access control. It allows web services to externalize the authentication of end-users by securely signing users in using a third-party identity provider. Findy Agency team has experimented with integrating SSI (self-sovereign identity) agent capabilities to a sample OIDC provider, thus enabling verified data usage in the login flow. The proof-of-concept shows that this approach would allow numerous web applications to switch to SSI-based login with minimal changes."
author: Laura Vuorenoja
resources:
  - src: "**.{png,jpg}"
    title: "Image #:counter"
---

Utilizing SSI wallets and verifiable credentials in OIDC authentication flows has been an
interesting research topic for [our team](https://findy-network.github.io) already for a while now.
As said, [the OIDC protocol](https://openid.net/connect/) is popular. Countless web services sign
their users in using OIDC identity providers. And indeed, it provides many benefits, as it
simplifies the authentication for service developers and end-users. The developers do not have
to reinvent the authentication wheel and worry about storing username/password information.
The users do not have to maintain countless digital identities with several different passwords.

{{< figure src="https://pbs.twimg.com/media/FA_yO0jUcAM2fMa.jpg" width="500px"
attr="<small>Example of login page with support for multiple identity providers.<br/> Image source: IndieWeb NASCAR Problem</small>"
attrlink="https://indieweb.org/NASCAR_problem" >}}

However, [the protocol is not flawless](https://medium.com/mattr-global/if-you-build-an-island-youll-need-a-boat-537f48525edc),
and it seems evident that using verified data would fix many of the known weaknesses.

**Our most significant concerns for current OIDC protocol practices are related to privacy.**

Let's suppose that our imaginary friend Alice uses an application, say a dating service,
that provides a Facebook login button for its users. Each time Alice logs in, Facebook becomes
aware that Alice uses the dating service. Depending on the service authentication model, i.e., how
often the service requires users to reauthenticate, it can also
learn a great deal at which time and how often Alice is using the service.

Alice probably didn't want to share this data with Facebook and did this
unintentionally. Even worse, Alice probably uses a similar login approach with other applications.
Little by little, Facebook learns about which applications Alice is using
and how often. Moreover, as applications usually provide a limited amount of login options,
most users choose the biggest identity providers such as Facebook and Google.
The big players end up collecting an enormous amount of data over users.

## How Would SSI and Verified Data Change the Scenario?

In the traditional OIDC flow, identity providers hold the sensitive end-user data and personally
identifiable information. Yet, this is not the case with the SSI model, where the user owns
her data and stores it in her digital wallet as verifiable credentials. In the SSI-enabled
authentication process, instead of typing username and password to the identity provider login
form, *the user presents verifiable proof of the needed data*. No third parties are necessary for
the login to take place.

Furthermore, the transparent proof presentation process lets the user know which data fields
the application sees. In the traditional flow, even though the service usually asks if the user
wishes to share her profile information, the data is transferred server-to-server invisibly.
The level of transparency depends on the identity provider’s goodwill and service design quality.
In the proof presentation, the wallet user sees in detail which attributes she shares with the application.

{{< imgproc attributes Fit "625x625" >}}
<em>In the proof presentation, the wallet user sees in detail which attributes she shares with the application.</em>
{{< /imgproc >}}

The verifiable credentials technology would even allow computations on the user data without
revealing it. For example, if we assume that Alice has a credential about her birthdate
in her wallet, she could prove that she is over 18 without exposing her birthdate when registering
to the dating service.

## Midway Solution for Speeding up Adoption

The ideal SSI-enabled OIDC login process wouldn't have any identity provider role, or actually,
the user would be the identity provider herself. The current identity provider (or any other service
holding the needed identity data) would issue the credential to the user’s wallet before any logins.
After the issuance, the user could use the data directly with the client applications
as she wishes without the original issuer knowing it.

{{< imgproc cover.shift Fit "925x925" >}}
<em>In SSI-Enabled OIDC login flow there is no need for traditional identity provider
with user data silos.</em>
{{< /imgproc >}}

The OIDC extension
[SIOP (Self-Issued OpenID Provider)](https://openid.net/specs/openid-connect-self-issued-v2-1_0.html)
tries to reach this ambitious goal. The specification defines how the client applications can verify
users' credential data through the renewed OIDC protocol. Unfortunately, implementing SIOP would require
considerable changes to existing OIDC client applications.

As adapting these changes to OIDC client applications is undoubtedly slow, we think a midway
solution not requiring too many changes to the OIDC clients would be ideal for speeding up
the SSI adoption. The identity provider would work as an SSI proxy in this solution, utilizing
SSI agent capabilities. Instead of storing the sensitive user data in its database, the provider
would verify the user's credential data and deliver it to the client applications using the same
API interfaces as traditional OIDC.

## Findy Agency under Test

In the summer of 2020, our team did some initial proofs-of-concept around this subject.
The experiments were successful, but our technology stack
[has matured](https://findy-network.github.io/blog/2021/08/11/announcing-findy-agency/) since then.
We decided to rewrite the experiments on top of our latest stack and take a closer look at this topic.

{{< imgproc overview Fit "825x825" >}}
<em>Overview of the midway solution process participants</em>
{{< /imgproc >}}

Other teams have created [similar demos](https://github.com/bcgov/vc-authn-oidc/blob/main/docs/README.md)
in the past but using different SSI technology stacks. Our target was to test our
[Findy Agency gRPC API](https://github.com/findy-network/findy-agent-api) hands-on. Also, our
web wallet's user experience is somewhat different from other SSI wallets. The web wallet
can be used securely with the browser without installing mobile applications. Furthermore,
the core concept of our wallet app is the chat feature, which is almost missing altogether from
other SSI wallet applications. We think that the chat feature has an essential role in creating
an excellent user experience for SSI wallet users.

## Demo

{{< youtube V5FWX0g3HVk >}}
*The demo video shows how the technical PoC works on localhost setup.
The user logs in to a protected service using the web wallet.*

The basic setup for the demo is familiar to OIDC utilizers. The end-user uses a browser
on the laptop and wishes to log in to a protected web service. The protected sample service
for this demo playing the OIDC client role is called
the ["issuer tool"](https://github.com/findy-network/findy-issuer-tool). The service has configured
[an SSI-enabled identity provider](https://github.com/findy-network/findy-oidc-provider)
as a login method. It displays the button “Login via credential” on its login page.
The service redirects the user to the identity provider login page with a button click.

Then the flow changes from the usual OIDC routine. Before the login, the user has already acquired
the needed data (an FTN - Finnish Trust Network credential) in her SSI wallet. She uses her
[web wallet](https://github.com/findy-network/findy-wallet-pwa) on her mobile device to read
the connection invitation as a QR code from the login page
to begin the DIDComm communication with the identity provider. The identity provider will then
verify the user’s credential and acquire the data the client application needs for the login.
The rest of the flow continues as with traditional OIDC, and finally, the client application
redirects the user to the protected service. The entire process sequence is below in detail:

{{< figure src="/blog/2022/04/07/ssi-empowered-identity-provider/sequence.svg" >}}
*Step-by-step sequence for the login process*

## Implementation

The demo services utilize OIDC JS helper libraries
([client](https://github.com/panva/node-openid-client),
[server](https://github.com/panva/node-oidc-provider)). We implemented the client application
integration similarly to any OIDC login integration, so there was no need to add any dedicated code
for SSI functionality. For the identity provider, we took
[the JS OIDC provider sample code](https://github.com/panva/node-oidc-provider/tree/main/example)
as the basis and extended the logic with
[the SSI-agent controller](https://github.com/findy-network/findy-oidc-provider/blob/master/src/agent/index.js).
The number of needed code changes was relatively small, which showed us that these integrations to
the “legacy” world are possible and *easy* to implement with an SSI agency that provides
a straightforward API.

All of the codes are available on GitHub
([client](https://github.com/findy-network/findy-issuer-tool),
[provider](https://github.com/findy-network/findy-oidc-provider))
so that you can take a closer look or even set up the demo on your local computer.

*We will continue our exploration journey with the verified data and the OIDC world, so stay tuned!*
