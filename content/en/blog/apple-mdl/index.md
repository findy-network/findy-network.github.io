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

As a tech nerd these last couple of years have been most frustrated. The
similar situation was when I couldn't do my taxes with government's digital
service as normal citizens could. I was part-time freelancer. They have
fixed that since then. But now, as a normal Finn, I cannot use may mobile devices to
authenticate myself in face2face situations. WTF, I want my color TV!

# Real Beginning is here

It's been somewhat funny that we don't have a Mobile Drivers license working in
Finland. In the Nordics we are usually quite good with the things related to
digital and mobile services. For example, we have had somewhat famous bank IDs
from early 90's.

FTR, Iceland has had a mobile driver's license since 2020. Surprise surprise, Finland was on the pole
position at summer 2018, when government funded mobile driver's license beta app was in the use with 40.000 users.
The project was started at 2017 but got [cancelled at
2020 (in Finnish)](https://www.traficom.fi/fi/ajankohtaista/autoilija-sovelluksen-kehittaminen-keskeytetaan-traficom-keskittyy-nykyisten).

## Self-Sovereign vs Pragmatism

As you probably already know, our innovation team has studied SSI long time. So
long that we start to understand different paths you can take to solve the value
promise of the SSI.

Christopher Allen one of the major influencer in the field of SSI divided the
Self-Sovereign Identity to [two major
tracks](https://youtu.be/MGYOWqCMLKg?si=X4oOBLRBc_IFowFn&t=1997):

1. LESS Identity (Term originally coined by Tim Bouma)
2. Trustless Identity (or more properly *Trust Minimized* Identity)

These two aren't totally mutually exclusive, but they give us the platform to
state our goals. Which one we prefer a government or the individual?

| LESS Identity | Trust Minimized Identity |
|---------------|--------------------------|
| - Minimum Disclosure | - Anonymity |
| - Full Control | - Web of Trust |
| - Necessary Proofs | - Censorship Resistance |
| - Legally-Enabled | - Defend Human Rights vs Powerful Actors (nation states, corps, etc.) |

I *personally always* prefer Human Rights over Legally-Enabled.

From researcher's point of view it seems that LESS Identity track is the faster
because it's easier to find business cases. But it is not only a bad thing. These
business driven use cases will pave the way to even more progress in a form of
censorship resistance, anonymity, etc.

## Example of Good UX

The Apple Pay is worlds largest mobile payment platform outside China. In the
Western Hemisphere Apple Pay has shown the way. It's been especially interesting
to follow what has happened in the Nordics which already had mobile payment
platforms and which had worlds most digitalized private banking systems when
Apple Pay arrived. 

Why Apple Pay has been so successful? Like so many other features in Apple's
ecosystem, they took the necessary final technological and technical steps that
the friction in the payments were minimal for both payer and the seller.

## Use Case -driven approach

approach was used in many designing aspects of DIDs, DIDComm,
    etc.  The ISO
    mDL <TODO> is total opposite. Every single piece of idealism has thrown
    away. Every single designing decision is hammered down to solve core use
    cases related to mobile drivers license. And no new technologies has invented.
    Just put together features that we need.

I had to admit that it's been refreshing after ivory stores of SSI ;-) For the
record, there are still excellent work going on e.g. block chain commons.

## Mobile Driver's license

The ISO standard.. 

## Differences Since SSI

mDL has almost similar trust triangle as good old SSI-version.

<OLD SSI Trust Triangle>

But when you start too look more carefully you'll notice some differences like
the used names for similar parties. Verifier is <TODO> Holder is the User. Only
one that is the same is the Issuer role.

Also connections between parties are drawn differently. Where SSI definetily
doesn't draw communication relation between a verifier and an issuer, mDL
explains that their communication is totally OK, but not mandatory.

We should ask when that kind of communication is need? Well, first and the most
obvious one is revocation needs. If the use case demands that the mobile
document (TODO: term) is still valid, a verifier can contact the issuer and ask.
Sounds pretty pragmatic, doesn't it?


# Concepts

## Interfaces

| DID/SSI Concept | ISO 18013-5 Interface Party |
| --------------- | --------------------------- |
| Issuing Authority Infrastructure | Issuer |
| mDL Reader | verifier |
| mDL | Holder |

<TODO mDL interface image>

mDL ISO Document:
> *For offline retrieval, there is no requirement for any device involved in the
> transaction to be connected*

## Identity
## Identity Provider
## Authenticate
## Identification

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
