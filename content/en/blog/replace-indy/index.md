---
date: 2022-03-16
title: "Replacing Indy SDK"
linkTitle: "Replacing Indy SDK"
description: "Indy SDK and related technologies are obsolete, and they are proprietary already."
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

Well, let's start from the beginning. I did write the following on January
19th 2022:

**Indy SDK is on the sidetrack from the DID state of the art.**

   - Core concepts as explicit entities are missing: *DID method*,
   *DID resolving*, *DID Documents*, etc.

   - Because of the previous reasons, the *API* of Indy SDK is not optimal.

   - `libindy` is too much framework than a library, i.e. it assumes how things
   will be tight together, it tries to do too much in one function, or it
   doesn't isolate parts like ledger from other parts like a wallet in a right
   way, etc.

   - Indy SDK has too many dynamic library dependencies when compared to
     what those libraries achieve.


## The Problem Statement Summary

We have faced two different but related problems:
1. Indy SDK doesn't align the current W3C and Aries specifications.
2. The W3C and Aries specifications are too wide and they lack clear focus. TODO
   add link to first blog post.

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
