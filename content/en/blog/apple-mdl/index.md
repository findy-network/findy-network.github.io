---
date: 2024-02-06
title: "I want mDL!"
linkTitle: "I want mDL!"
description: "
"
author: Harri Lainio
resources:
- src: "**.{png,jpg}**"
  title: "Image #:counter"
---

How to heck we have ended up this mesh. We should be the number one in the
world. that was a promise. we had even a press release of it. but no. here we
are without the mobile driver's license or digital ID. 

You might ask who is we. findland of course. tech nerds of the world. at lest we
think so.

# background ends

As a tech nerd, these last couple of years have been most frustrating. A similar
situation was when I couldn’t do my taxes with the government’s digital service
when normal citizens could. I was a part-time freelancer—no candy for me.

They have fixed that since then. But now, as a regular Finn, I cannot use my
mobile devices to authenticate myself in face-to-face situations. WTF, I want my
color TV!


# Real Beginning is here

It's been somewhat funny that we don't have a Mobile Drivers license in
Finland. In the Nordics we are usually quite good with the things related to
digital and mobile services. For example, we have had somewhat famous bank IDs
from early 90's.

FTR, Iceland has had a mobile driver's license since 2020. Surprise surprise, Finland was on the pole
position at summer 2018, when government funded mobile driver's license beta app was in the use with 40.000 users.
The project was started at 2017 but got [cancelled at
2020 (in Finnish)](https://www.traficom.fi/fi/ajankohtaista/autoilija-sovelluksen-kehittaminen-keskeytetaan-traficom-keskittyy-nykyisten).

## SSI Idealism vs Pragmatism

As you probably already know, our innovation team has studied SSI for a long time.
We have started to understand different strategies you can follow to implement
digital ID and services around it.

Christopher Allen, one of the influencers in the field of SSI, divided the
Self-Sovereign Identity into [two primary
tracks](https://youtu.be/MGYOWqCMLKg?si=X4oOBLRBc_IFowFn&t=1997):

1. [LESS (Legally-Enabled Self-Sovereign) Identity](https://trbouma.medium.com/less-identity-65f65d87f56b)
2. Trustless Identity, or more precisely *Trust Minimized* Identity

These two aren't mutually exclusive but give us a platform to state our goals.
Which one do we prefer, a government or an individual?

|   LESS Identity        |   Trust Minimized Identity |
|------------------------|----------------------------|
|   Minimum Disclosure   |   Anonymity |
|   Full Control         |   Web of Trust |
|   Necessary Proofs     |   Censorship Resistance |
|   Legally-Enabled      |   Defend Human Rights vs Powerful Actors (nation states, corps, etc.) |

> The above table is from [the Allen's
> talk](https://youtu.be/MGYOWqCMLKg?si=X4oOBLRBc_IFowFn&t=1997) in YouTube.

I *personally always* prefer Human Rights over Legally-Enabled.

From a researcher's point of view, the LESS Identity track seems faster because
it's easier to find business cases. But this is not only a bad thing. These
*business-driven* use cases will pave the way to even more progress in censorship
resistance, anonymity, etc. It's natural that, for example, the mobile driver's
license will start as a LESS Identity practice. So, let's follow that for a
moment, shall we?

### Example of Good UX

Apple Pay is the world's largest mobile payment platform outside China. It's
been exciting to follow what happened in the Nordics, which already had mobile
payment platforms and the world's most digitalized private banking systems when
Apple Pay arrived.

Why has Apple Pay been so successful? Like many other features in Apple's
ecosystem, they took the necessary final technical steps to remove all the
friction from setting up the payment trail. Significantly, the seller doesn't
need additional steps or agreements to support Apple Pay in the brick-and-mortar
business. That's the way we all should think of technology.

### Use Case -driven approach

The origins of SSI has been somewhat idealistic in some areas at least little
bit. The [ISO mDL](https://www.iso.org/standard/69084.html) is total opposite.
Every single piece of idealism has thrown away. Every designing decision is
hammered down to solve core use cases related to use of mobile driver's license.
And no new technologies has invented. Just put together features that we need.

I had to admit that it's been refreshing to see that angle in practice after
ivory stores of SSI ;-) For the record, there are still excellent work going on
in SSI area in general.

## Differences Since SSI

mDL has almost similar trust triangle as good old
[SSI-version.](https://findy-network.github.io/blog/2021/09/08/travelogue/trust-triangle_hua2e42792a9d20037c5f572b0412e67c1_57626_925x925_fit_catmullrom_3.png)

{{< imgproc ISO-interfaces.png Resize "1200x" >}}
<em>mDL Interfaces And Roles</em>
{{< /imgproc >}}


But when you start too look more carefully you'll notice some differences like
the different names for similar parties. Verifier is `mDL Reader`. Holder is `mDL Holder` or simply `mDL`.
Issuer is `Issuing Authority`.

Also connections between parties are different. Where SSI definitely
doesn't allow direct communication between a verifier and an issuer, mDL
explains that their communication is totally OK, but not mandatory. Only thing
that matters is that the mDL holder and mDL Reader can do what they need to do
to execute the current use case. For example:

> *For offline retrieval, there is no requirement for any device involved in the
> transaction to be connected*

We should ask when that kind of communication is need? Well, first and the most
obvious one is revocation needs. If the use case demands that the mobile
document
([mDOC](https://www.iso.org/obp/ui/en/#iso:std:iso-iec:18013:-5:ed-1:v1:en)) is
still valid, a verifier can contact the issuer and ask. Sounds pretty pragmatic,
doesn't it?


# Concepts

## Interfaces

| ISO 18013-5 Interface Party | DID/SSI Concept |
| --------------- | --------------------------- |
| Issuing Authority Infrastructure | Issuer |
| mDL Reader | verifier |
| mDL | Holder |

mDL ISO Document:
## Identity
## Identity Provider
## Authenticate
## Identification

## Mobile Driver's license

{{< imgproc ISO-retrieval.png Resize "1200x" >}}
<em>Agency DID Core Concepts</em>
{{< /imgproc >}}

The ISO standard.. 

LA Wallet, had other way, they don't store any data to the mobile device.
Everything is fetched from the mainframe server of coverment.

same capabilites that plastic version - mDL.

Local radio modes first. then the internet. 13.5. Over internet means nothing,
      request response protocol. OpenID presentation, critical identification
      how to origin!! URL authentication of source of Origin!

Transport protocols, mobile eID. mDOC format and methods are generic purpose
stuff.

National parties, is good to Go with mDL, they are already part of it. With
other formats, we don't know yet what format wins. 

How get head of the issuers, goverments, etc. Choosing ISO format generally
easier than other. This so early time for mass produced digital credentials.

Digital early adapters, transformation. Making progress.

Call home functionality, is this controversiol, asks the interviewer. With the 

Specific use case vs generic model. Apples you cannot compare. Named value pars,
         salted hasses, coverment accepted cryptos, doesn't do fanzy stuff like
         ZKP (but maybe in future), ZKP you can solve this totally different
         ways, proof of age for example! 
         - how about correlation, maybe call home, is a bad thing. There is no
         revocation, but expires, **revocation is mechanism for correlation**
         - key revocation when this is invented, (really general doesn't yet)
         every system will use that!! That's been excellent decision to wait.

More verifiers will come to the field. mDL, is it id document or something else?


Decentralized Identity term Does describes nothing. There are other flawors.
There are SSI, and others. 

Present digitally signed document, nothing else. The rest is that how you are
doing that. Server call home. Serverless doesn't like that. We have seen in USA,
      more in UE, person hold wallet stored idepended store. W3C structures,
      etc.

As a young lad I remember that I need or just wanted
something, but didn't have funds to achieve the thing. 



. It was a pilot that got
40.000 user at the peek, but was cancelled by the government at TODO. It would be
interesting to know how much money they had spent to it. there had added to
quite extensive features. Laughing turns to crying if your are Apple Pay heavy
user and you start to forget your non-digital wallet to home and you should
authenticate your self at some service desk.

## How about DIDs and SSI?

Since jumping on the SSI (Self-Sovereign Identity) wagon, I have been wondering
some of the approaches:

- like DIDs, why [CRUD](https://en.wikipedia.org/wiki/Create,_read,_update_and_delete)?,
- why DIDComm has a late detection of MITM? [TOFU](https://en.wikipedia.org/wiki/Trust_on_first_use) is very long story and we will
  probably write separate post about this later.
- why not use hybrid cryptography but only asymmetric,
- or why prefer JSON instead of let's say CBOR, or other binary formats.

Quite many the aspects has felt so anti-pragmatic and overly complicated that you
started to wonder what have been the designing philosophy? I have also written
and [publish those findings](TODO) [in several posts](TODO). My current
conclusion is the old wisdom, don't *build platform but solve a specific use that
should be easy to solve with the platform first.*

allen sayd that everything seem to transform from decentralized to centralized
in time. He spokes PKI CAs, block chain mining, ...
