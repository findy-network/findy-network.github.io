---
date: 2021-09-03
title: "Travelogue"
linkTitle: "Travelogue"
description: "We have used many different techniques, technologies and
architectures to build a modern and preformant DID agency. During the journey
we have been able to learn SSI essentials but align modern software and hardware
technologies best suited for decentralized identity network. This a summary of
that journey."
author: Harri Lainio
resources:
- src: "**.{png,jpg,svg}**"
  title: "Image #:counter"
---

#### The Technology Study

The success of the team I'm part of is measured:
- How well we understand emerging technologies?
- How relevant they are to the business we are?
- How much potential they might bring for our company's business? 

> If you are asking yourself is the order of the list wrong? The answer is: it
is not.

We have learned that if you try to priorize technologies by
their business value too early, you will fail. There is a catch though, you must be
sure that you will not fall in love with technologies you are studying. Certain
skeptisim is wellcomed in our line of work.

#### Technology Tree

{{< imgproc tree.png Fill "725x275" >}}
<em>Findy Agency Tech Tree</em>
{{< /imgproc >}}

Technology roots present the most important background areas of our study.
Trunk of the tree is the backboune of our work. The most
fundamental technologies and study subjects are in the trunk.
Branches and leafs are outcomes, conclusions, and key learnings. At the top
of the tree there some future topics which are considered but not 
implemented or even tried yet.

Even the technology tree illustrates the relevant techlogies for the subject we
will not decribe all of them in this post. Still we recommend you study the tree
by yourself a moment to get the picture. You might notice that there
aren't special mention about VC. For us, the VC is internal feature of the whole
DID concept (w3c link here) and it includes The DIDComm protocol itself.

#### Trust Triangle

The famous SSI trust triangle is excellent tool to try to simplyfy what is
important and what is not. As we can see everything builds on peer to peer
connections, thik arrows. VCs are issued and proofs are presented thru them. Only
thing that's not yet solved *at the technology level* is the trust arrow in
the triangle. (I know the recursive trust triangle but I disagree how it's
thought to be implemented). But this blog post is not about that either. 

{{< imgproc trust-triangle Fit "925x925" >}}
<em>The SSI Trust Triangle</em>
{{< /imgproc >}}

#### Targets and Goals

Every project's objectives and goals change during the execution, longer the
project more pivots it has. (The term *project* quite freely in the post.)
When we started to work
with DID/SSI field the goal was
build **a standalone mobile app demo** of the identity wallet based on Hyperledger Indy. We
started in *test drive mode*, but ended up to build full DID Agency and publish
it as OSS.

In every project it's important to maintain the scope. Thanks to nature of our
organisation we didn't have chainging requirements. The widening of the
scope came from facts that the whole area of SSI and DID were evolving. It still
is.

{{< imgproc targets.png  Fit "925x925" >}}
<em>The Journey From Identity Wallet to Identity Ecosystem</em>
{{< /imgproc >}}

Many project goals changed significantly during the execution, but that was part
of the job. And as DID/SSI matured, we matured as well, and goals to our work
aren't *so* "test drive" mode anymore. We still test other related technologies
which have potential to be matced to DID/SSI or even replace some parts of it,
but have transited to state where we have started to build our own related
core technologies to the field.

Incubators usually start their trip by testing different hypothesis and trying
them out in practise. We did the same but more on practical side. We didn't have
so formal hypothesis but we had some use cases and vision how the modern
architecture should work and what kind of scaling requirements it would face.
That kind of princimples lead our decision making process during the project.
(Maybe some us write a detailed blog how our emerging tech process and
organisation worked.)

## The journey

We have been building our multitenant agency since beginning of 2019. During
that time we have tried many different techniques, technologies and
architectures as well as application metaphoras. Where we think we have
suggeeded to find intresting results. 

In the following chapters we will report the time period from beginning of 2019
to autumn of 2021 in a half of a year intervals.


## 2019/H1

{{< imgproc spring19.png  Fit "925x925" >}}
<em>2019/H1</em>
{{< /imgproc >}}

#### The Start

Me:
> "I'm interested to study new tech by programming with it."

Some blockchain expert in the emerging technologies team:
> "We need an identity wallet to be able to continue with our other projects.
> Have you ever heard of Hyperledger Indy.."

In one week I have been smoke tested indy SDK on iOS and Linux. During the
spring, we ended up to follow the Indy's propriatary agent to agent
protocol, **but** we didn't use CVX lib for that because:

> This library is currently in an **experimental** state and is not part of
> official releases.

To be honest that was the most important reason because we have had so much
extra work with other Indy libs and of course we would need a wrapper at least for
Go. It was easy decicion. Afterwards it was the right own because the DIDComm
protocol is the backpone of everything with SSI/DID. And now when it's in our
own (capable) hands it's made many such things possible which weren't othervise.
We will publish a whole new technical blog series of our multitenant DIDComm
protocol engine.

All of the modern, native mobile apps end up been written from two parts: mobile
app component running on the device and the server part doing everthying it can
to make mobile app's life easier. Early stages DIDComm's edge and cloud agent
roles wasn't that straight forward. From every point of view it seemed overly
complicated. But still we sticked to it.

##### First Results

At then end of the spring 2019 we had quick and dirty demo of the system which had
**multi-tenant** agency to serve cloud agents and iOS mobile app to run edge
agents. An EA onboarded itself to agency with the same DID Connect
protocol which were used everywhere. Actually, an EA and a CA
used Web Sockets as transport mechanism for indy's DIDComm messages.

We hated the protocol. It was insane. But it was DID protocol, wasn't it?

System was end to end encrypted but the indy protocol, because it had its flaws
like beeing syncronounsh, we didn't yet have any presistent state machine or the other
basics of the communication prootocol systems. Also the whole thing seemed
overly complicated and old -- it wasn't modern cloud protocol.

##### Third party integration demo

In early summer ended up build demo which didn't follow totally the current
arhictecture, because the mobile app's edge agent was communicating directly to
the third party agent. This gave us a lot of experience and for me, it gave
needed time to spec what kind of protocol the DIDComm should be and what kind of
protocol engine should run it.

It was weird time because indy's legacy agent to agent protocol didn't have a
public, structured and formal specification of its protocol. 

Those who are interested about the history can read more
[here](https://hyperledger-indy.readthedocs.io/projects/hipe/en/latest/text/0002-agents/README.html).

The integration project made it prettly clear for us what kind of protocol was
needed.

> **Async with explicit state machine**

##### Aries news

During the summer, Hyperledger Aries was set up which was good because it showed
excatly the same we learned. We were on the right path.

##### Code Delivery For a Business Partner

For this mailstone we ended up produce some documentation, mostly be able to
explain the architecture. During the whole project we have had comprehensive
unit and integration test harness.

This point we had all of the important features covered: issuing, holding,
present and verify proofs in quick and dirty way. Now we knew the potential.
     
##### 2019 End of the summer, Status Review

Retros and reviewing propsals for the rest of the year 2019. We had our cloud centric
approach still as a guiding princimple. We understood that if we keep everything
as an agent (edge agent and cloud agent) and communicate thru DIDComm even when it's
the old indy proprietary it gives some advance with its symmetry. But because we
were so **beginning of our learning curve** we couldn't know for sure what the
actual benefits at the long run were. It was big surprice for us that other
players of the field didn't follow pure DIDComm princimple. The communication
in their solutions wasn't pure DIDComm. There was HTTPS and
REST e.g. agent controllers. Already then we thought that everything should be
self-certified which is core princimples of SSI technology.

##### Results 2019 Summer

We had managed to implement pre-Aries DIDComm over HTTP and WebSocket. We had
multitenant agency running cloud agents even that it was far far away from
production readyness. Everything was end to end crypted. Indy's ledger
transactions were supported and first some tests had been taken from issuing and
proofing protocols. We started to understand what kind of peast was tearing at
us from other end of the road.

## 2019/H2

{{< imgproc autumn19.png  Fit "925x925" >}}
<em>2019/H2</em>
{{< /imgproc >}}

##### Start Of The Async Protocol Development

When we started architecture redesign after summer break 
We had clear idea what kind of direction we should take and what to leave for
later:
- **cloud first** and we have newer wanted to step back on that
- **no support for offline** use cases *for now*.
- **no revocation** until there is working solution. Credid card revocation has
tougth us a lot. Scalable and fast revocation is hard problem to solve.
- message routing should not be part of the protocol's explicit headers. We
did leave rounting out and it has been making everything so much siple. There are
technologies which can do that for us for free like TOR. We have tested TOR
and it works pretty well for setting service endpoinst and also connecting to
them.

We had
APNS to trigger edge agents when they were not connected to server.

##### Multiledger Architecture 

Because everything goes thru our Go wrapper to the plenum ledger I made as a
hoppy project tests and checked libindy's code if we could have a memory ledger
for unit tests and development. Later the plugin architecture have given us
opportunity to have other persistent saving medias as well. But more importantly
it has helped development and automatic testing hugely.

##### Server Side Secure Enclaves

During the server side development we wanted to have at least post-compromised
secured key storage for cloud servers. Cloud environments like AWS give you the
storages for master secrets but when developing OSS solution with especially
high performance and scalability requirements we needed more.

Now we store our most important keys for LMDB-based fast key value storage
fully encrypted. Master keys for installation are in managed clould environment
like AWS, Google, Azure, etc.

##### First Multitenant Chat Bot

The first running version of the chat bot used semi-hard coded version.
It supported only sequential steps which were each a single
line in a text file, and CredDefIds in own file, and finally text messages
in its own files. The end result was just few lines of Go code thanks to its
excellent concurrent model.

The result was so good that I made a backlog issue to start study if I could use
SCXML or some other exiting language for chat bot state machines later. About a
year later I implmented statemachine by my own with propretiary YAML format.
Before that I tested quite many different options but there wasn't much of the
options in OSS.

#### 2019/H2 Results

We had implemented all the most important use cases with our new protocol
engine. We had symmetric agent which could be in all of the needed roles of SSI:
as a holder, an issuer, and a verifier. Also the API seemed to be ok at high
level of abstraction. The individual messages were shit.

At the end of the year we also had a deacent toolbox both on command line and
especially on web.

## 2020/H1

{{< imgproc spring20.png  Fit "925x925" >}}
<em>2020/H1</em>
{{< /imgproc >}}

##### Findy-consortium Level OSS Publication

At the beginning of the year 2020 we made decision to publish all the produced
code inside the Findy consortium. For that new github account was
produced and code without history moved from original repos to new ones.

Even the decision brought lot of routine work for that moment it also brought
many good things:
- refactoring,
- interface cleanups,
- documentation updates.

##### AcaPy Interoperability Tests 

First version of the new async protocol engine was implemented with existing
JSON messages which came from legacy indy a2a protocols. It's mostly because I
wanted to build it in small steps, and it worked pretty well.

Most of the extrawork did come from legacy API we had. JSON messages over indy's
propretiary DIDComm. As always, some bad but some good as well: because we had
to keep both DIDComm message formats I managed to integrate quite clever way to
separate different formats and still have generalisation with Go's interfaces. 

Go Code Tip! *Many think that implementation inheritance is a bad thing
even evil, but there are case when it works just well. With Go you can have
pretty clever structures and reduce poilerplate by using default name with
agregated structs. Also the serialization codecs kept along well.*


##### New CLI

We noticed that Agency's command line UI started to be too complicated. Go has
quite clever idea how you can do services without environment variables. I'm
personally still the guy who would keep with that, but to make the our tools
comfortable for all new users it was a good idea to viden the scope.

Our designing idea was build CLI which follows nowdays idea of subcommands like
git and docker for example. The latest version we have now is quite good
already, but the road was rocky. It is not easy to find right structure first
time. More you use your CLI by yourself more start to notice what is intuitive
and what is not.


: separted and full CLI tool for startup agency and maingain it:
     preform SA handshakes, have a full EA in CLI,

## 2020/H2

{{< imgproc autumn20.png  Fit "925x925" >}}
<em>2020/H2</em>
{{< /imgproc >}}
2020 summer architecture planning

I had selling internally quite long time the idea of using gRPC for Cloud Agent
controller. Unfortunately my selling pitch was lacking some details or the were
clouded. My core idea was to get rid of the EA because currently it was just a
onboarding tool. The wallet it had, included only the pairwise DID to its cloud
agent, nothing else. The actual wallet (we called it worker edge agent wallet)
was the the real wallet, where the VCs were. I went thru many similar protocols
until I find FIDO UAF. The protocol is similar than DIDComm's pairwise protocol
but it's not symmetric. Other end is server and the other end has the
authenticator. 

When I was able to present a demo of the gRPC with the JWT authorization and
explain that authencations would be FIDO2 WebAuth. It was sold. Everything was
good when I implmented first FIDO server which allocated clould agents. But
there was one missing part I was hoping someone in the OSS community would
already implemented when we needed. It was headleas WebAuthn/UAF authenticator
for those issuers/verifiers that were running as service agents. How to onboard
them and how they would access agency's resources with same JWT authorization.

     , polyglot with high level IDL tech
     
# todo and remember:

performance and scalability tests, using pregenrated wallet keys, dramatically
better wallet open perf. 

2020 autumn: we started to build for new SA architecture, both API exists
2020 autumn gRPC and WebAuth development started + Headless acator, Vault
2020 autumn first version of state machine for service agent implementation
2020 autumn first implementation of immuDB plugin for libindy Go wrapper

## 2021/H1

{{< imgproc spring21.png  Fit "925x925" >}}
<em>2021/H1</em>
{{< /imgproc >}}

2021 spring installation shell scripts for libindy to Mac 
2021 spring 1st version of Agency's pRPC API, tried iterate IDL as good as
     possible, we still have Legacy API (indy did pairwise + json) but ready to
     drop it.
2021 spring first polyglot implementations thanks to gRPC: type script, Go,
     java script, upcoming Dart, Java, Kotling?
2021 spring all important repos open for public, OSS Release

- refactorings and updates turing the years:
  - 2020: Go mobules for all of the repos, maybe it would be better if we had
  only one repo 
  - keep minimal dependencies, 

The end.
