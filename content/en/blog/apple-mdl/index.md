---
date: 2024-04-06
title: "I want mDL!"
linkTitle: "I want mDL!"
description: "
As a tech nerd, these last few years have been most frustrating. A similar
situation was when I couldn’t do my taxes with the government’s digital service.
I was a part-time freelancer. They have fixed that since then. But now, as a
regular Finn, I cannot use my mobile devices to authenticate myself in
face-to-face situations—I want my color TV!
"
author: Harri Lainio
resources:
- src: "**.{png,jpg}**"
  title: "Image #:counter"
---

It's funny that we don't have a mobile driver's license in Finland. In the
Nordics, we are usually good with digital and mobile services. For example, we
have had somewhat famous bank IDs from the early 90s.

For the record, Iceland has had a mobile driver's license since 2020. Surprise,
Finland was in the pole position in the summer of 2018. The government-funded
mobile driver's license app (beta) was used with 40.000 users. The project
started in 2017 but was [canceled in 2020 (link in
Finnish).](https://www.traficom.fi/fi/ajankohtaista/autoilija-sovelluksen-kehittaminen-keskeytetaan-traficom-keskittyy-nykyisten)

How the heck have we ended up in this mess? We should be the number one in the
world! Did we try to swallow too big a bite once when the country-level SSI
studies started?

## SSI Study

As you probably already know, our innovation team has studied SSI for a long
time. We have started to understand different strategies you can follow to
implement digital identity and services around it.

### Trust-foundation

Christopher Allen, one of the influencers in the field of SSI, divided the
Self-Sovereign identity into [two primary
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
|   Legally-Enabled      |   Defend Human Rights vs Powerful Actors (nation-states, corps, etc.) |

> The above table is from [the Allen's
> talk](https://youtu.be/MGYOWqCMLKg?si=X4oOBLRBc_IFowFn&t=1997) in YouTube.

I *personally* prefer Human Rights over Legally-Enabled.

However, from a researcher's point of view, the LESS Identity track seems faster
because it's easier to find business cases. These *business-driven* use cases
will pave the way to even more progress in censorship resistance, anonymity,
etc. The mobile driver's license is a perfect example of a LESS Identity
practice. Let's follow that for a moment, shall we?

### Level Of Decentralization

Most internet protocols have started quite a high level of decentralization as
their goal/vision through the [history of computer
science](https://en.wikipedia.org/wiki/History_of_the_World_Wide_Web). There are
many benefits to setting decentralization as a requirement: no single point of
failure, easier to scale horizontally, etc.

Since blockchain, *decentralization* has become a hype word, and most of us need
help understanding what it means to have fully decentralized systems. One easily
forgotten is trust, and we will only achieve absolute decentralization once we
have a proper model for Self-Certification.

### Idealism vs Pragmatism

I see a paradox here. How about you? Why does anyone try to build maximally
decentralized systems if their identities must be legally binding? Or why do we
put a lot of effort into figuring out consensus protocols for systems that don't
need them?

Our legal system has solved all of these problems already. So, let's stick on
that be pragmatic only, shall we?

## Pragmatism

My current conclusion is the old wisdom: *don't build a platform immediately,
but solve a few use cases first and build the platform if needed.*

Second might be *don't solve imaginary problems.* Look for *monetizable pain*
first and solve that with as small steps as possible.

Let's see what that all means from SSI vs. mDL.

### Example of Good UX

Apple Pay is the [world's largest mobile payment platform outside
China](https://www.businessofapps.com/data/mobile-payments-app-market/). It's
been exciting to follow what happened in the Nordics, which already had several
mobile payment platforms and the world's most digitalized private banking
systems when Apple Pay arrived.

Why has Apple Pay been so successful? Like many other features in Apple's
ecosystem, they took the necessary final technical steps to remove all the
friction from setting up the payment trail. Significantly, the seller doesn't
need additional steps or agreements to support Apple Pay in the brick-and-mortar
business. (That's how it works in Finland.) That's the way we all should think
of technology.

### Use Case -driven approach

The origins of SSI have been idealistic in some areas. The [ISO
mDL](https://www.iso.org/standard/69084.html) is the total opposite. Every
single piece of idealism has been thrown away. Every design decision is hammered
down to solve core use cases related to the use of mobile driver's licenses. And
no new technologies have been invented. Just put together features that we need.

I had to admit that it's been refreshing to see that angle in practice after
ivory towers of SSI ;-) For the record, there is still excellent work going on
in the SSI area in general.

## Differences Between mDL And SSI

mDL has almost a similar trust triangle as good old
[SSI-version.](https://findy-network.github.io/blog/2021/09/08/travelogue/trust-triangle_hua2e42792a9d20037c5f572b0412e67c1_57626_925x925_fit_catmullrom_3.png)

{{< imgproc ISO-interfaces.png Resize "1200x" >}}
<em>mDL Interfaces And Roles — ISO ISO_18013-5</em>
{{< /imgproc >}}

But when you start to look more carefully, you'll notice some differences, like
the names of similar parties.

### Concepts

ISO calls these roles as interfaces.

| ISO 18013-5 Interface Party | DID/SSI Concept |
| --------------- | --------------------------- |
| Issuing Authority Infrastructure | Issuer |
| mDL Reader | verifier |
| mDL | Holder |

### Connections

Also, connections between parties are different. Where SSI doesn't allow direct
communication between a verifier and an issuer, mDL explains that their
communication is OK but optional. The only thing that matters is that the mDL
Holder and mDL Reader can do what they need to execute the current use case. For
example:

> *For offline retrieval, there is no requirement for any device involved in the
> transaction to be connected*

'Connected' means connected to the internet. One of the scenarios is to support
offline use cases, which makes sense if you think about instances where law
enforcement officer needs to check the ID. That must be possible even when the
internet connection is severed.

We continue with transport technologies at [Mobile Driver's
License](#mobile-drivers-license).

### Revocations

We should also ask when that *call-home* is needed. The first and most obvious
one is the validity checks. If the use case demands that the relying party
checks that the mobile document
([mDOC](https://www.iso.org/obp/ui/en/#iso:std:iso-iec:18013:-5:ed-1:v1:en)) is
still valid on every use, a verifier can contact the issuer (Issuing Authority)
and ask. All of this sounds pragmatic.

*Call-home seems perfectly aligned with Finnish bank regulation and
legislation,* **as far as I know**. For example, the party who executes, let's
say, a transaction according to power-of-attorney (PoA) is the party who's
responsible for checking that a PoA is valid and not revoked. *The
responsibility to transfer revocation information* is *not* the one who has
given the PoA. It's enough that the information is available for the party who
relies on the PoA. It's the relying party's responsibility to access that
information case-by-case.

It makes much sense and makes building revocation easier when you think about
that. In summary, some call-home is the only way to make revocation requirements
work. Note that the *home* isn't necessarily the issuer, but it definitely *can
be seen as the Issuing Authority's Infrastructure.*

### One schema

The most specific difference between mDL and SSI is that the schema is locked.
It's based on
([mDOC](https://www.iso.org/obp/ui/en/#iso:std:iso-iec:18013:-5:ed-1:v1:en))
standard. That might first feel like a handicap, but the more you think about
this, the better way it is to start implementing use cases in this area.

## Mobile Driver's License

mDL standard also has similarities to SSI, such as *selective disclosure*. But
it and other features are designed with only one thing in mind: *pragmatism*. No
Fancy Pancy features or saving-the-world idealism, just pure functionality.

The ISO standard defines the mDL standard, which is based on mDOC. The following
diagram describes its most important architectural elements.

{{< imgproc ISO-retrieval.png Resize "1200x" >}}
<em>mDL ISO Architecture — ISO ISO_18013-5</em>
{{< /imgproc >}}

The diagram presents both logical and physical parts of the mDL architecture. At
the bottom are supported data transport technologies: NFC/Bluetooth, Wi-Fi Aware
(optional), etc. Transported data is CBOR coded, which guarantees the best
possible performance. CBOR is a binary-coded data format optimized for limited
resources and bandwidth. 

### Selective Disclosure

mDL's selective disclosure is analog to
[SD-JWT's](https://www.ietf.org/archive/id/draft-fett-oauth-selective-disclosure-jwt-02.html)
mechanism, i.e., only disclosures' digests are used when the issuer signs the
credential document. That allows simple and easy-to-understand implementation,
which is also efficient. At first glance, it only supports property-value pairs,
but I don't see why it couldn't allow the use of hierarchical data structures as
well. However, because the digest list is a one-dimensional array, it would
prevent selection from inside a hierarchy.

### No Need For ZKP

mDL doesn't have [ZKP](https://en.wikipedia.org/wiki/Zero-knowledge_proof) but
has solved similar use case requirements with the *attestations*. For example,
the mDL issuer will include a set of age-over attestations into the mDL. The
format of each attestation identifier is `age_over_NN`, where `NN` is from 00 to
99. 

When mDL Reader sends the request, it can, for example, query the presence of the
attestation `age_over_55`, and the response will include all the attestations
that are equal to or greater than 55 years old. For example, if mDL doesn't have
`age_over_55` but it has `age_over_58` and `age_over_65`, it will send
`age_over_58`.

## Conclusion

mDL specification is excellent and ready for broad adoption. I hope we can build
something over it ASAP. Unfortunately, the road I selected for PoCs and demos
wasn't possible because Apple’s ID Wallet requires that your device is
registered in the US. There are ways to try it on an emulator, but it lacks too
many core features to be interesting enough. Suppose you are asking why Apple
and why not something else; the answer is that I’m looking at this on the
operation system (OS) wallet track. Apple also has exciting features like [Tap
to ID](https://www.nfcw.com/technology/apple-tap-to-present-id-api/).

The next step will be to study what we can learn from mDOC/mDL from the DID
point of view. Is there some common ground between how mDL sees the world and
how DIDComm and generic SSI sees the world—hopefully, the same world.

Until next time, see you!

<br>
<div style="display: flex">
<span>
<img src="https://avatars.githubusercontent.com/u/11439212?v=4" width="100">
<div>Harri</div>
<div><a href="https://github.com/lainio/" target="_blank" rel="noopener noreferer"><i class="fab fa-github ml-2 "></i></a>
<a href="https://www.linkedin.com/in/harrilainio/" target="_blank" rel="noopener noreferer"><i class="fab fa-linkedin ml-2 "></i></a>
<a href="https://twitter.com/harrilainio" target="_blank" rel="noopener noreferer"><i class="fab fa-twitter ml-2 "></i></a></div>
</span></div>
