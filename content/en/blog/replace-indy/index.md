---
date: 2022-03-03
title: "Replacing Indy SDK"
linkTitle: "Replacing Indy SDK"
description: "I am ranting what and how we should fix the upcoming standard."
author: Harri Lainio
resources:
- src: "**.{png,jpg}**"
  title: "Image #:counter"
---

[Once again, we are at the technology
crossroad](https://findy-network.github.io/blog/2021/09/08/travelogue/): we have
to decide how to proceed with our SSI/DID research and development. Naturally,
the business potential is the most critical aspect, but the research subject has
faced the phase where we have to change the foundation.

![SSI Layers](https://findy-network.github.io/blog/2021/09/08/travelogue/TechTree_hucb3e947ff7ac3c644fea522c44e98b42_1584631_1991x0_resize_catmullrom_3.png)
<p align = "center"> Our Technology Tree - <a
href="https://findy-network.github.io/blog/2021/09/08/travelogue/">
Travelogue</a></p>

Changing any foundation could be an enormous task, especially when such a broad
spectrum of technologies is put together. (Please see the picture above).
Fortunately, we have taken care of this type of a need early in the design where
the underlying foundation, [Indy SDK](https://github.com/hyperledger/indy-sdk)
is double wrapped:

1. We needed a Go wrapper for `libindy` itself.
2. At the beginning of the `findy-agent` project, we tried to find agent-level
   concepts and interfaces for multi-tenant agency use.

This post is peculiar because I'm writing it up front and not just reporting
something that we have been studied and verified carefully.

> "I am in a bit of a paradox, for I have assumed that there is no good in
> assuming." - Mr. Eugene Lewis Fordsworthe

I'm still writing this. Be patient; I'll try to answer *why* in the following chapters.

## Who Should Read This?

You should read this if:

- You are considering jumping on the SSI/DID wagon, and you are searching good
  technology platform for your SSI application. You will get selection criteria
  and fundamentals from here.

- You are in the middle of the development of your own platform, and you need a
  concrete list of aspects you should take care of.

- You are currently using Indy SDK, and you are designing your architecture based
  on [Aries reference architecture](https://github.com/hyperledger/aries)
  and its shared libraries.

## Indy SDK Is Obsolete

Indy SDK and related technologies are obsolete, and they are proprietary already.

You might think that I have lost my mind. We have just reported that our Indy
SDK based DID agency is [AIP
1.0](https://github.com/hyperledger/aries-rfcs/blob/main/concepts/0302-aries-interop-profile/README.md)
compatible, and everything is wonderful. How in the hell did Indy SDK become
obsolete and proprietary in a month or so?

Well, let's start from the beginning. I did write the following list on January
19th 2022:

1. Indy SDK is on the sidetrack from the DID state of the art.

   - Core concepts as explicit entities are missing: *DID method*,
   *DID resolving*, *DID Documents*, etc.

   - Because of the previous reasons, the *API* of Indy SDK is not optimal.

   - `libindy` is too much framework than a library, i.e. it assumes how things
   will be tight together, it tries to do too much in one function, or it
   doesn't isolate parts like ledger from other parts like a wallet in a right
   way, etc.

   - Indy SDK has too many dynamic library dependencies when compared to
     what those libraries achieve.

2. No one in the SSI industry seems to be able to find perfect focus.

   - There are too few solutions running in production (yes, globally as well)
     which would give us needed references to drive a good design from.

   - [Standardization in W3C didn't proceed as it
   should](https://lists.w3.org/Archives/Public/public-new-work/2021Sep/0000.html).

3. Findings during our study of SSI/DID and others in the industry.

   - We don't need a ledger to solve self-certified identities.

   - We don't need human *memorable* identifiers. (memorable <> meaningful
     <> typeable <> codeable)

   - We *rarely* need an identifier just for *referring* but we continuously need
     *self-certified identifiers for secure communication*: should we first fully
     solve the communication problem and not the other way around?

   - Trust always seems to lead back to a specific type of centralization. There are
   many existing studies like web-of-trust that should at least take in a
   review. [Rebooting Web-of-Trust](https://www.weboftrust.info/) is an excellent
   example of that kind of work.

   - We must align the SSI/DID technology to the current state of the art like
     Open ID and federated identity providers. [Self-Issued OpenID Provider
     v2](https://openid.net/specs/openid-connect-self-issued-v2-1_0.html)
     the protocol takes steps in the right direction and will work as a bridge.

### W3C DID Specification Problems

Now, February 20th 2022, the list is still valid, but now, when we have dug
deeper, we have learned that the DID W3C "standard" has its flaws itself.

1. It's far too complex and redundant -- the scope is too broad.

2. There should not be so many DID methods. ["No practical interoperability." &
   "Encourages divergence rather than
   convergence."](https://lists.w3.org/Archives/Public/public-new-work/2021Sep/0000.html) 

3. For some reason, [DID-core](https://www.w3.org/TR/did-core/) doesn't
   cover protocol specifications, but protocols are in [Aries
   RFCs](https://github.com/hyperledger/aries-rfcs/blob/main/index.md). You'll
   face the problem in [the DID peer method
   specification](https://identity.foundation/peer-did-method-spec/).

4. It misses layer structures typical for network protocols. When you start to
   implement it, you notice that there are no network layers to help you to hide
   abstractions. Could we have [OSI
   layer](https://www.networkworld.com/article/3239677/the-osi-model-explained-and-how-to-easily-remember-its-7-layers.html)
   mappings or similar at least? (See more information about the network layers
   at the end.)

5. Many performance red flags pop up when you start to engineer the
   implementation. Just think about [tail
   latency](https://brooker.co.za/blog/2021/04/19/latency.html) in DID resolving
   and you see it. Especially if you think [the performance demand of the
   DNS](https://lig-membres.imag.fr/loiseapa/pdfs/2015/Hours-etal_ImpactDNSCausal_ITC2015.pdf).
   The comparison is pretty fair.

## The Problem Statement Summary

We have faced two different but related problems:
1. Indy SDK doesn't align the current W3C and Aries specifications.
2. The W3C and Aries specifications are too wide and they lack clear focus.

### Fixing W3C & Aries Specifications Problems

I cannot guide the work of W3C or Aries, but I can participate in our own team's
decision making, and we will continue on the road where we'll concentrate our
efforts to [DIDComm](https://identity.foundation/didcomm-messaging/spec/),
which will mean that we'll keep the same Aries protocols implemented as we have
now, but with the latest DID message formats:

1. [DID
   Exchange](https://github.com/hyperledger/aries-rfcs/blob/main/features/0023-did-exchange/README.md)
   to build a DIDComm connection over an invitation or towards public DID.
2. [Issue
   Credential](https://github.com/hyperledger/aries-rfcs/blob/main/features/0453-issue-credential-v2/README.md)
   to use a DIDComm connection to issue credentials to a holder.
3. [Present
   Proofs](https://github.com/hyperledger/aries-rfcs/blob/main/features/0454-present-proof-v2/README.md)
   to present proof over a DIDComm connection.
4. [Basic
   Message](https://github.com/hyperledger/aries-rfcs/blob/main/features/0095-basic-message/README.md)
   to have private conversations over a DIDComm connection.
5. [Trust
   Ping](https://github.com/hyperledger/aries-rfcs/blob/main/features/0048-trust-ping/README.md)
   to test a DIDComm connection.

Keeping the same protocol set might sound simple, but unfortunately, it's not because
Indy SDK doesn't have, e.g. a concept for `DID Method`. At the end of the January
2022, no one has implemented `did:indy` method either, and its specification is
still in work-in-progress.

The methods we'll support first are `did:peer` and `did:key`. The first is
evident because our current Indy implementation builds almost identical pairwise
connections with Indy DIDs. The `did:key` method replaces all public keys in
DIDComm messages, and it has other use as well.

The `did:web` method is probably the next in the line. It gives us an
implementation baseline for the actual *super* [DID Method
`did:onion`](https://blockchaincommons.github.io/did-method-onion/).

## No Need For The Ledger

The `did:onion` method is currently the only straightforward way to build
self-certified *public* DIDs that cannot be correlated. The `did:web` is
analogue, but it doesn't offer privacy as itself. However, it provides privacy
for the individual agents through [*herd privacy* if DID specification doesn't
fail in it](https://github.com/w3c/did-core/issues/539).

Indy stores [credential definitions and
schemas](https://docs.cheqd.io/node/architecture/adr-list/adr-008-identity-resources)
to the ledger addition to public DIDs. However, when [verifiable credentials
move to use BBS+ credential definitions aren't
needed](https://www.evernym.com/blog/bbs-verifiable-credentials/) and schemas
can be read, e.g. from [schema.org](schema.org). Only those DID methods need
a ledger which is using a ledger as *public DID's* [trust
anchor](https://findy-network.github.io/blog/2021/11/09/anchoring-chains-of-trust/)
and source of truth.

### What Is A Public DID?

It's a DID who's DIDDoc you can solve without an
[invitation](https://github.com/hyperledger/aries-rfcs/blob/b3a3942ef052039e73cd23d847f42947f8287da2/features/0434-outofband/README.md).

The `did:key` is superior because it is complete. You can compute (solve) a DID
document by receiving a valid DID key identifier. No third party or additional
source of truth is needed. However, we cannot communicate with the `did:key`'s
holder because the DIDDoc doesn't include [service
endpoints](https://www.w3.org/TR/did-core/#services). So, there is no one
listening and nothing to connect to.

Both `did:onion`'s and `did:web`'s DIDDocs can include service endpoints because
they can offer the DID document by their selves from their own servers. We must
remember that the DID document offers [verification
methods](https://www.w3.org/TR/did-core/#verification-methods) which can be used
to build the actual [cryptographic
trust](https://findy-network.github.io/blog/2021/11/09/anchoring-chains-of-trust/).

## How To Design Best Agency?

How to do it right now when *we don't have a working standard or de facto
specifications*? We have thought that for a long time, over three years for now.

I have thought and compared SSI/DID networks and solutions. I think we need to
have a layer model similar to the OSI network model to handle complexity.
Unfortunately, the famous trust-over-IP picture below isn't the one that is
missing:

![SSI Layers](https://blockchain.tno.nl/media/18029/figure_1_the_toip_technology_stack_and_its_four_layers_20042021_1200_675.png?anchor=center&mode=crop&quality=90&width=1200&slimmage=true&rnd=132633967270000000)
<p align = "center"> The ToIP technology stack and its four layers - <a
href="https://blockchain.tno.nl/blog/self-sovereign-communication/">SSI
Communication</a></p>

Even though it has a layer model, it doesn't help us build technical solutions.

Luckily, I found [a blog
post](https://medium.com/decentralized-identity/the-self-sovereign-identity-stack-8a2cc95f2d45)
which seems to be the right one, but I didn't find any follow-up work.
However, we can use it as a reference and proof that there exists this kind of
need.

The following picture is from the blog post. As we can see, *it includes
problems*, and the weirdest one is the *missing OSI mapping*. Even the post
explains how vital the layer model is for *interoperability* and *portability*.
Another maybe even more weird mistake is mentioning that layers could *be
coupled* when the whole point of layered models is to have **decoupled layers**.
Especially when building **privacy holding technology**, it should be evident
that **there cannot be leaks between layers**.

<img src="https://miro.medium.com/max/1400/1*4zUczSBaVH-8qilvK4nKwQ.png"
width="350" />
<p align = "center"> The Self-sovereign Identity Stack - <a
href="https://medium.com/decentralized-identity/the-self-sovereign-identity-stack-8a2cc95f2d45">The Blog
Post</a></p>

### Missing Layer - Fixing The Internet

The following picture illustrates mappings from the OSI model through protocols to TCP/IP
model.

![TCP/IP and OSI](https://www.dummies.com/wp-content/uploads/296299.image0.jpg)

We all know that the internet was created without security and privacy, and still,
it's incredibly successful and scalable. From the layer model, it's easy to see
that security and privacy solutions should be put under the transport layer to
allow all of the current applications to work without changes. But it's not
enough if we want to have end-to-end encrypted and secure communication pipes.

**We need to take the best of both worlds: fix as much as possible, as a low layer
as you can one layer at a time.**

### Secure & Private Transport Layer

There is one existing solution, and others are coming:
1. [Tor](https://www.torproject.org/) and its onion routing.
1. [NYM](https://nymtech.net/), etc.

I know that Tor has its performance problems, etc., but the point is not about
that. The point is to which network layer should handle secure and private
transport. It's not DIDComm, and it definitely isn't implemented as *statical
routing like currently in DIDComm*. Just think about it: What it means when you
have to change your mediator or add another one, and compare it to current
TCP/IP network? It's a no-brainer that routing should be isolated in a layer.

The following picture shows how OSI and TCP/IP layers map. It also shows one
possibility to use onion routing instead on insecure and public TCP/IP routing
for DID communication.

{{< imgproc OSIMap.png Resize "1200x" >}}
<em>DID Communication OSI Mapping</em>
{{< /imgproc >}}

The solution is secure and private, and there aren't no leaks between layers which
could lead to correlation.

## Putting All Together

We stated our problems in [the problem statement summary](#the-problem-statement-summary).
In the next chapters, we will start to fix the problems and put things together.

The elephant is eaten one bite at a time is a strategy we have used
successfully and continue to use here. We start with missing core
concepts: `DID`, `DID document`, `DID method`, `DID resolving`. The following
UML diagram present our high-level conceptual model of these concepts and their
relations.

{{< imgproc classes.png Resize "1200x" >}}
<em>Agency DID Core Concepts</em>
{{< /imgproc >}}

Because current DID specification allows or supports many different *DID
Methods* we have to take care of them in the model. It would be naive to think 
we could use only external *DID resolver* and delegate DIDDoc solving.
Just for think about performance, it would be a nightmare, security issues even
more.

### Resolving

The following diagram is our first draft of how we will integrate DID document
resolving to our agency.

{{< imgproc resolve.png Resize "800x" >}}
<em>Agency DID Core Concepts</em>
{{< /imgproc >}}

### Building Pairwise -- DID Exchange

You can have an explicit invitation
([OOB](https://github.com/hyperledger/aries-rfcs/blob/main/features/0434-outofband/README.md))
protocol, or you can just have public DID that implies an invitation just by
existing and resolvable the way that leads service endpoints. Our resolver
handles DIDs and DID documents and *invitations* as well. It's essential because
our existing applications have proven that pairwise connections are often made.
The more we can streamline it, the better.

{{< imgproc pairwise.png Resize "800x" >}}
<em>Agency DID Core Concepts</em>
{{< /imgproc >}}

We should be critical just to avoid complexity. If the goal is to reuse existing
pairwise (connection), and the most common case is a public website, should we
leave that for public DIDs and try not to solve by invitation? When public DIDs
would scale and wouldn't be correlatable, we might be able to simplify
invitations at least? 

## Existing Reusable Solutions?

Naturally, Indy SDK is not the only solution for SSI/DID. Actually, many of us
who are working DID field are moving from Indy SDK to something other. When
Aries project and its goals were published, most of us thought that replacing
solutions would come faster. Unfortunately, that didn't happen, and there are
many reasons for that. Building software has many internal
'ecosystems' mainly directed by programming languages. For instance, it's
unfortunate that we gophers behave like managed language programmers and rarely
use pure native binary libraries because we lose too much if we do that.

Sadly, it is so much easier to keep your Go project only written with Go
than have to try to follow the correct binary dependency tree coming from behind just
one [ABI](https://en.wikipedia.org/wiki/Application_binary_interface) library
usage. If you can find a module just written only Go, you select that even it
would be some sort of a compromise.

That's been one reason we have to build our own API with gRPC. That will offer
the best from both worlds and allow efficient polyglot usage. I hope others do
the same and use modern API technologies with local/remote transparency.

## We Are Going To Evaluate AFGO

Currently, the Aries Framework Go seems to be the best evaluation option for us
because:
- It's written in Go, and all its dependencies are native Go packages.
- It follows the Aries specifications by the book.

Unfortunately, it also has the following problems:

1. It's is *a framework* which typically means all or nothing, i.e. you have to
   use the whole framework because it takes care of everything, and it only offers
   you extension points where you can put your application handlers. A
   framework is much more complex to replace than a library.

   ![framework vs library](https://csharpcorner-mindcrackerinc.netdna-ssl.com/UploadFile/a85b23/framework-vs-library/Images/DqCkT.png)
   <p align = "center"> Difference Between Library and Framework - <a
   href="https://www.c-sharpcorner.com/uploadfile/a85b23/framework-vs-library/">The Blog
   Post</a></p>


1. Its protocol state machine implementation is not as good as ours:

   - It doesn't fork protocol handlers immediately after receiving the
     message payload.

   - It doesn't offer a 30.000 ft view to machines, i.e. it doesn't seem to
     be declarative enough.

1. It has totally different concepts than we and Indy SDK have for the key
   entities like DID and storage like a wallet.

We will try to wrap AFGO to use it as a library and 
produce an interface that we can implement with Indy SDK. This way, we can use
our current core components to implement different Aries protocols
and even verifiable credentials.

Our agency has bought the following features and components which we have measured
to be superior to other similar DID solutions:
- Multi-tenancy model, i.e. symmetric agent model
- Fast server-side secure enclaves for KMS
- General and simple DID controller gRPC API
- Minimal dependencies
- Horizontal scalability
- Minimal requirements to hardware
- Cloud-centric design

We really try to avoid inventing the wheel, but with the current knowledge, we
cannot switch to AFGO. Instead, we can wrap it and use it as an independent
library. 

> Don't call us, we'll call you. - [Hollywood
> Principle](https://en.wiktionary.org/wiki/Hollywood_principle)

We will continue to report our progress and publish the AFGO wrapper when 
ready. Stay tuned, folks, something extraordinary is coming!
