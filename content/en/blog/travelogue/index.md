---
date: 2021-09-03
title: "Travelogue"
linkTitle: "Travelogue"
description: "We have used many different techniques, technologies and
architectures to build a modern and high-performance DID agency. During the
journey we have not only been able to learn SSI essentials but also *align modern
software and hardware technologies best suited for decentralized identity
network*."
author: Harri Lainio
resources:
- src: "**.{png,jpg}**"
  title: "Image #:counter"
---

The success of the team I'm part of is measured:
- How well we understand *certain* emerging technologies?
- How relevant they are to the business we are in?
- How much potential they have for our company's business? 

If you are asking yourself is the order of the list wrong the answer is, it
is not.

We have learned that if you try to prioritize technologies by their business
value too early, you will fail. There is a catch though, you must be sure that
you will not fall in love with technologies you are studying. Certain skepticism
is welcomed in our line of work. That attitude may follow thru this post as
well. You have now warned at least.

### Technology Tree

{{< imgproc tree.png Resize "1991x" >}}
<em>Findy Agency Tech Tree</em>
{{< /imgproc >}}

Technology roots present the most important *background knowledge* of our study.
The most fundamental technologies and study subjects are in the trunk.  The
trunk is the backbone of our work. It tights all together. Branches and leafs
are outcomes, conclusions, and key learnings. At the top of the tree there some
future topics which are considered but not implemented or even tried yet.

Even if the technology tree illustrates the relevant technologies for the subject we
will not address all of them in this post. **We recommend you to study the tree
for a moment** to get the picture. You will notice that there
aren't mention about VC. For us, the concept of VC is internal feature 
of [DID system](https://www.w3.org/TR/vc-data-model/). Naturally there are huge
amount of enormous study subjects inside VCs like ZKP, etc. But this approach
has lead us to concentrate the network itself and the structure it should have.

The tree has helped us to see how things are bound together and what topics are
the most relevant for the study area.

### Trust Triangle

The famous SSI trust triangle is excellent tool to try to simplify what is
important and what is not. As we can see, everything builds on peer to peer
connections, thick arrows. VCs are issued and proofs are presented thru them. Only
thing that's not yet solved *at the technology level* is the trust arrow in
the triangle. (I know the recursive trust triangle but I disagree how it's
thought to be implemented). But *this blog post* is not about that either. 

{{< imgproc trust-triangle Fit "925x925" >}}
<em>The SSI Trust Triangle</em>
{{< /imgproc >}}

### Targets and Goals

Every project's objectives and goals change during the execution, longer the
project more pivots it has. (Note that I use the term *project* quite freely in
the post). When we started to work with DID/SSI field the goal was build **a
standalone mobile app demo** of the identity wallet based on Hyperledger Indy.
We started in *test drive mode*, but ended up to build full DID agency and
publish it as OSS. The journey has been very exiting and we  have learned a lot.

In every project it's important to maintain the scope. Thanks to nature of our
organisation we didn't have changing requirements. The widening of the
scope came mostly from facts that the whole area of SSI and DID were evolving.
It still is.

{{< imgproc targets.png  Fit "925x925" >}}
<em>The Journey From Identity Wallet to Identity Ecosystem</em>
{{< /imgproc >}}

Many project goals changed significantly during the execution, but that was part
of the job. And as DID/SSI matured, we matured as well, and goals to our work
aren't *so* *test driven* mode anymore. We still test other related technologies
which have potential to be matched to DID/SSI or even replace some parts of it,
but have transited to state where we have started to build our own related
core technologies to the field as well.

Incubators usually start their trip by testing different hypothesis and trying
them out in practise. We did the same but more on practical side. We didn't have
so formal hypothesis but we had some use cases and vision how the modern
architecture should work and what kind of scaling requirements it would face.
That kind of principles lead our *decision making process* during the project.
(Maybe some us write a detailed blog how our emerging tech process and
organisation worked.)

## The journey

We have been building our multi-tenant agency since beginning of 2019. During
that time we have tried many different techniques, technologies and
architectures as well as application metaphors. We think we have succeeded to
find interesting results. 

In the following chapters we will report the time period from beginning of 2019
to autumn of 2021 in a half of a year intervals. I really recommend that you
look the time lines carefully because they include the valuable outcomes.


### 2019/H1

{{< imgproc spring19.png Resize "2000x" >}}
<em>2019/H1</em>
{{< /imgproc >}}

##### The Start

Me:
> "I'm interested to study new tech by programming with it."

Some block-chain expert in the emerging technologies team:
> "We need an identity wallet to be able to continue with our other projects.
> Have you ever heard of Hyperledger Indy.."

In one week I have been smoke tested indy SDK on iOS and Linux. During the
spring, we ended up to follow the Indy's proprietary agent to agent
protocol, **but** we didn't use *libcvx* for that because:

> This library is currently in an **experimental** state and is not part of
> official releases. - [indy SDK GitHub pages]

To be honest that was the most important reason because we have had so much
extra work with other Indy libs and of course we would need a wrapper at least for
Go. It was easy decision. Afterwards it was the right own because the DIDComm
protocol is the backbone of everything with SSI/DID. And now when it's in our
own (capable) hands it's made many such things possible which weren't otherwise.
We will publish a whole new technical blog series of our multi-tenant DIDComm
protocol engine.

All of the modern, native mobile apps end up been written from two parts: mobile
app component running on the device and the server part doing everything it can
to make mobile app's life easier. Early stages DIDComm's edge and cloud agent
roles wasn't that straight forward. From every point of view it seemed overly
complicated. But still we sticked to it.

##### First Results

At then end of the spring 2019 we had quick and dirty demo of the system which had
**multi-tenant** agency to serve cloud agents and iOS mobile app to run edge
agents. An EA on-boarded itself to agency with the same DID Connect
protocol which were used everywhere. Actually, an EA and a CA
used Web Sockets as transport mechanism for indy's DIDComm messages.

We hated the protocol. It was insane. But it was DID protocol, wasn't it?

System was end to end encrypted but the indy protocol, because it had its flaws
like being synchronous, we didn't yet have any persistent state machine or the other
basics of the communication protocol systems. Also the whole thing felted
overly complicated and old -- it wasn't modern cloud protocol.

##### Third party integration demo

In early summer ended up build demo which didn't follow totally the current
architecture, because the mobile app's edge agent was communicating directly to
the third party agent. This gave us a lot of experience and for me, it gave
needed time to spec what kind of protocol the DIDComm should be and what kind of
protocol engine should run it.

It was weird time because indy's legacy agent to agent protocol didn't have a
public, structured and formal specification of its protocol. 

Those who are interested about the history can read more
[here](https://hyperledger-indy.readthedocs.io/projects/hipe/en/latest/text/0002-agents/README.html).

The integration project made it pretty clear for us what kind of protocol was
needed.

> **Async with explicit state machine**

##### Aries news

During the summer, Hyperledger Aries was set up which was good because it showed
exactly the same we learned. We were on the right path.

##### Code Delivery For a Business Partner

For this mail-stone we ended up produce some documentation, mostly be able to
explain the architecture. During the whole project we have had comprehensive
unit and integration test harness.

This point we had all of the important features covered: issuing, holding,
present and verify proofs in quick and dirty way. Now we knew the potential.

##### Results 2019 Summer

We had managed to implement pre-Aries DIDComm over HTTP and WebSocket. We had
multi-tenant agency running cloud agents even that it was far far away from
production readiness. Everything was end to end encrypted. Indy's ledger
transactions were supported and first some tests had been taken from issuing and
proofing protocols. We started to understand what kind of beast was tearing at
us from other end of the road.

### 2019/H2

{{< imgproc autumn19.png Resize "2000x">}}
<em>2019/H2</em>
{{< /imgproc >}}

##### Start Of The Async Protocol Development

When we started architecture redesign after summer break 
we had clear idea what kind of direction we should take and what to leave for
later:
- **Cloud first** and we have newer wanted to step back on that.
- **Modern micro-service architecture** targeting continues delivery and
scalability. That leads certain type technology stack which consist techs like
Go, gRPC, Docker (or other containerization technology), container
orchestration like K8s, etc. One key requirements was that hardware utilization
must be perfect i.e. tiny servers are enough.
- **No support for offline** use cases *for now*.
- **No revocation** until there is working solution. Credit card revocation has
thought us a lot. Scalable and fast revocation is hard problem to solve.
- Message routing should not be part of the protocol's explicit 'headers', i.e.
there is **only one service endpoint for a DID**. The service endpoint should
naturally be handled the way that privacy in maintained as it is in our agency.
By leaving routing out, it has been making everything so much simple. There are
technologies which can do that for us for free like TOR. We have tested TOR
and it works pretty well for setting service endpoints and also connecting to
them.
- **Use push notifications along with the WebSockets**, i.e. lent APNS to trigger
edge agents when they were not connected to server.

##### Multi-ledger Architecture 

Because everything goes thru our Go wrapper to the Plenum ledger I made as a
hobby project a version which used memory or plain file instead of ledger. It
was meant to be used only for tests and development. Later the plug-in
architecture have given us opportunity to have other persistent saving medias as
well. But more importantly it has helped development and automatic testing a
lot.

Technically the *hack* is to use `pool handle` to tell if the system is
connected to a ledger or some other predefined media. `indy` API has only two
functions that take `pool handle` as an argument but doesn't use it at all *or*
the handle is an option.

##### Server Side Secure Enclaves

During the server side development we wanted to have at least post-compromised
secured key storages for cloud servers. Cloud environments like AWS give you
managed storages for master secrets but when developing OSS solution with
especially high performance and scalability requirements we needed more.

Now we store our most important keys for LMDB-based fast key value storage
fully encrypted. Master keys for installation are in managed cloud environment
like AWS, Google, Azure, etc.

##### First Multi-tenant Chat Bot

The first running version of the chat bot used semi-hard-coded version.
It supported only sequential steps which were each a single line in a text file,
and `CredDefIds` in own file, and finally text messages in its own files. The
end result was just few lines of Go code thanks to its concurrent model.

The result was so good that I made a backlog issue to start study if we could
use SCXML or some other exiting language for chat bot state machines later.
About a year later I implemented state machine by my own with proprietary YAML
format.

Before that I considered quite many different options but there wasn't much
of the alternative in OSS. But that search isn't totally over. One option could be
embedded Lua combined with the current state machine engine and replace the
memory model with Lua. We shall see what the real use case needs are.

I personally think that even more important approach would be **a state machine
verifier**. If we keep that as a goal it sets strict limit to the computation
model we could use. What we have learned now you doesn't need full power of
general programming language but
[finite state machine (automata theory)](https://en.wikipedia.org/wiki/Automata_theory)
could just be enough.

#### 2019/H2 Results

We had implemented all the most important use cases with our new protocol
engine. We had symmetric agent which could be in all of the needed roles of SSI:
a holder, an issuer, and a verifier. Also the API seemed to be OK at high
level of abstraction. The individual messages were shit.

At the end of the year we also had a decent toolbox both on command-line and
especially on web.

### 2020/H1

{{< imgproc spring20.png  Resize "2000x">}}
<em>2020/H1</em>
{{< /imgproc >}}

##### Findy-consortium Level OSS Publication

At the beginning of the year 2020 we made decision to publish all the produced
code inside the Findy consortium. For that new GitHub account was
produced and code without history moved from original repos to new ones.

Even the decision brought lot of routine work for that moment it also brought
many good things:
- refactoring,
- interface cleanups,
- documentation updates.

##### ACA-Py Interoperability Tests 

First version of the new async protocol engine was implemented with existing
JSON messages which came from legacy indy a2a protocols. It's mostly because I
wanted to build it in small steps, and it worked pretty well.

Most of the extra work did come from legacy API we had. JSON messages over indy's
proprietary DIDComm. As always, some bad but some good as well: because we had
to keep both DIDComm message formats I managed to integrate quite clever way to
separate different formats and still have generalisation with Go's interfaces. 

##### New CLI

We noticed that Agency's command line UI started to be too complicated. Go has
quite clever idea how you can do services without environment variables. I'm
personally still the guy who would keep with that, but to make the our tools
comfortable for all new users it was a good idea to widen the scope.

Our designing idea was build CLI which follows nowadays idea of subcommands like
git and docker for example. The latest version we have now is quite good
already, but the road was rocky. It is not easy to find right structure first
time. More you use your CLI by yourself more start to notice what is intuitive
and what is not.

We decided to separate CLI commands from Agency to own tool and git repo. It was
good move for that time and when we managed to make it right we were able to
move those same commands pack to agency one year later because we needed CLI
tool without any *libindy* dependencies. That is good example successful
software architecture work. You cannot predict future but you can prepare
yourself for change.

### 2020/H2

{{< imgproc autumn20.png Resize "2000x">}}
<em>2020/H2</em>
{{< /imgproc >}}

##### Architecture Planning

I had having quite long time the idea of using gRPC for Cloud Agent controller.
My core idea was to get rid of the EA because currently it was just a on
boarding tool. The wallet it had, included only the pairwise DID to its cloud
agent, nothing else. The actual wallet (we called it worker edge agent wallet)
was the real wallet, where the VCs were. I went thru many similar protocols
until I find FIDO UAF. The protocol is similar than DIDComm's pairwise protocol
but it's not symmetric. Other end is server and the other end has the
authenticator -- the cryptographical root of trust.

When I was able to present an internal demo of the gRPC with the JWT
authorization and explain that authentications would be FIDO2 WebAuth we were
ready to start architecture transition. Everything was still good when I
implemented first FIDO server with help of Duo Labs Go packages. Our FIDO2 server
was now capable to allocated cloud agents. But there was one missing part I was
hoping someone in the OSS community would implement until we needed it. It
was headless WebAuthn/UAF authenticator for those issuers/verifiers that were
running as service agents. How to on-board them and how they would access
agency's resources with same JWT authorization? To allow us proceed we added
support to get JWT by our old API. It's was only intermediated solution but
served its purpose.

##### Learnings when implementing the new architecture 
- implicit JWT authorization helps gRPC usage a lot and simplifies it too.
- gRPC streams and Go's channel are just excellent together.
- You should use pre generated wallet keys for indy wallets.
- Performance and scalability tests can be integrated to CI.
- gRPC integration and unit testing could be done in same way as with HTTP stack
in Go i.e. inside a single process that can play both client and server.

##### Highlights of the end of the year 2020

We started to build for new SA architecture and allowed both our APIs exist.
WebAuth server, headless authenticator, and Vault first versions were now ready.
Also first version of state machine for service agent implementation was
done. We had an option to use immuDB instead of Plenum ledger.

### 2021/H1

{{< imgproc spring21.png Resize "2000x">}}
<em>2021/H1</em>
{{< /imgproc >}}

Now we have architecture that we can live with. All the important elements are
in place. Now we just clean it up.

##### Summary of Spring 2021 Results

Until the summer the most important results has been:
- Headless WebAuthn authenticator 
- React-based Web Wallet
- Lots of documentation and examples
- Agency's gRPC API v1
- Polyglot implementations gRPC: TypeScript, Go, JavaScript
- New toolbox both Web and Command-line 
- The full OSS release 

As said all of the important elements are in place. However, our solution is
based on `libindy` which is in the interesting point where original contributor
continues with it but rest of the Aries group are moving to shared libraries. We
haven't made the decision yet which direction we will go. Or do we even need to
choose? At least in the meantime we could just add some new solution and run
them both. Thanks to our own architecture and interfaces that's plausible option
for our agency.

There many interesting study subjects we are continuing to work with in the are
of SSI/DID. We will report them in upcoming blog posts. Stay tuned folks!

