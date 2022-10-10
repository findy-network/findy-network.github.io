---
date: 2022-09-27
title: "The Hyperledger Global Forum Experience"
linkTitle: "The Hyperledger Global Forum Experience"
description: "Hyperledger Foundation is a non-profit organization that hosts open-source software blockchain projects. It is part of the Linux Foundation. The Hyperledger Global Forum is the biggest annual gathering of the Hyperledger community, and this year the foundation organized the event in Dublin, Ireland."
author: Laura Vuorenoja and Harri Lainio
resources:
- src: "**.{png,jpg}"
  title: "Image #:counter"
---

Our team started utilizing Hyperledger technologies in 2019 when we began the experimentation with
decentralized identity. Since then, we have implemented [our identity agency](https://findy-network.github.io/)
with the help of two [Hyperledger Foundation](https://www.hyperledger.org/) projects:
Hyperledger Indy for implementing the low-level credential
handling and Hyperledger Aries for the agent communication protocols specification.

{{< imgproc cover Fit "925x925" >}}
<em>The Dublin Convention Centre hosted the Global Forum. At the same time,
the Open Source summit also took place at the same venue.
</em>
{{< /imgproc >}}

We released our work as open-source in 2021. When the pandemic restrictions finally eased in 2022,
we thought the Hyperledger Forum would be an excellent chance to meet fellow agent authors and
present our work to an interested audience. Luckily, the program committee chose [our presentation](https://hgf22.sched.com/event/14H5g/findy-agency-highway-to-verified-data-networks-laura-vuorenoja-harri-lainio-op-financial-group)
among many candidates, so it was time to head for Ireland.

The three-day event consisted of two days of presentations and demos and one workshop day where
the participants had a chance to get their hands dirty with the actual technologies.
When over 600 participants and 100 speakers gather together, there is also an excellent
chance to meet old friends and make new ones.

## Presenting Findy Agency

{{< youtube dlWWMeiSUfE >}}
*Our presentation is available on YouTube.*

We had the opportunity to present our project’s achievements on the second day of the conference,
Tuesday, 13th September. Our overall Hyperleger-timing was perfect because the other SSI agent
builders had comforted the issues we had already solved. And for that reason, for example,
our ledger-less running mode got lots of attention.

We had a little luck that the feature stayed in the slides. Previous conversations with Hyperledger
Aries's core team had not raised any interest in the subject. Now they had an idea that [AnonCreds](https://anoncreds-wg.github.io/anoncreds-spec/)
(Hyperledger Indy verified credentials) could stay in version 1.0 format, but VDR
([verified data registry](https://www.w3.org/TR/did-core/#dfn-verifiable-data-registry),
ledger in most of the DID methods) could be something else in [Indy SDK](https://github.com/hyperledger/indy-sdk).

Our ledger multiplexer solves the same issue. It makes it possible to use Indy SDK with whatever
VDR, or even multiple VDRs if necessary, for example, the second one as a cache.

{{< imgproc presentation Fit "925x925" >}}
<em>We had lots of questions in the Q&A section. (Photo by the Linux Foundation)</em>
{{< /imgproc >}}


Summary of the rest of the QA section of the talk:

* There was a question about the business cases we have thought about or are keeping potential.
Everybody seemed eager to find good use cases that could be referenced for their own use.
Many sources confirmed that we should first solve something internal. Something that we can decide
everything by ourselves. As a large enterprise, that would still give us
a tremendous competitive advantage.
* Questions about how our solution differs from systems based on DIDComm routing, i.e., you must
have multiple agents like a relay, a mediator (cloud agent), and an edge agent.
We explained that you wouldn’t lose anything but get a much simpler system.
There were questions about wallet export and import, which both we have implemented and tested.
* There were multiple reasonable questions about where DIDComm starts in our solution and where
it’s used. Because our wallet app doesn’t use (anymore) DIDComm, e.g., for edge agent onboarding,
it wasn’t easy to get your head around the idea that we integrated all the agent types into one
identity domain agent (the term we used in the talk). Our web wallet was a UI extension of it. 
* Luckily, we had some extra time because there was a break after our talk.
We could answer all the questions. We can say that we had an excellent discussion
at the end of the presentation.

The organizer recorded our talk and it is published on [YouTube](https://www.youtube.com/watch?v=dlWWMeiSUfE).

<blockquote class="twitter-tweet"><p lang="en" dir="ltr">As shown in the Findy Agency demo at <a href="https://twitter.com/hashtag/HyperledgerForum?src=hash&amp;ref_src=twsrc%5Etfw">#HyperledgerForum</a>, using FIDO2 to authenticate to a web wallet is a great way to keep access to an online web wallet passwordless. <a href="https://t.co/GGuHnecnI7">pic.twitter.com/GGuHnecnI7</a></p>&mdash; Animo (@AnimoSolutions) <a href="https://twitter.com/AnimoSolutions/status/1569648888415670275?ref_src=twsrc%5Etfw">September 13, 2022</a></blockquote> <script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>

## The Technical Demos

In addition to keeping our presentation, our goal was to participate in the sessions handling
self-sovereign identity and verifiable data. There would have been exciting sessions covering,
e.g., the Hyperledger Fabric project. However, unfortunately, many of the sessions were overlapping,
so one needed to cherry-pick the most interesting ones, naturally keeping our
focus on the technical track.

[Aries Bifold](https://github.com/hyperledger/aries-mobile-agent-react-native) project is
a relatively new acquaintance in the Aries community. It is a long-awaited open-source mobile
agent application built on react-native. The community was long missing an open-source solution
for edge agents running on mobile devices, and they had to use proprietary solutions for this purpose.
Aries Bifold tries to fill this gap and provide an easily customizable, production-ready wallet application.

In the Aries Bifold demo, we saw two wallet applications receiving and proving credentials,
one being the basic version of the app and another with customization, [the BC Wallet application](https://www2.gov.bc.ca/gov/content/governments/government-id/bc-wallet).
The BC Wallet is a digital wallet application developed by the Government of British Columbia
in Canada and is even publicly available in application stores.

{{< imgproc bc Fit "925x925" >}}
<em>The BC Wallet application is available in the application stores.</em>
{{< /imgproc >}}

Another open-source demo was about building controllers for ACAPy. ACAPy intends to provide services
for applications (controllers) that aim to utilize Aries credential flows in their logic.
In the demo, we saw how the ACAPy controllers could handle their agent hosted by ACAPy using
the ACAPy REST API. However, this demo was a bit disappointing as it did not show us anything
we hadn't seen before.

## ”Decentralized Identity Is Ready for Adoption Now”

One of the most exciting keynotes was a panel talk with four SSI legends, Drummond Reed,
Heather Dahl, Mary Wallace, and Kaliya Young. Their clear message was that we are now done
with the mere planning phase and should boldly move to execution and implement real-world
use cases with the technology. Also, the panelists raised the public sector to the conversation.
The point was that the public sector should act as an example and be the pioneer in using the technology.

Some public sector organizations have already listened to this message as we heard about exciting
pilot projects happening in the Americas. The state of North Dakota is issuing a verifiable
credential to each graduating senior, and potential employers and universities can then verify
these credentials. The city of San Francisco uses verified credentials to replace legacy
authentication mechanisms in over 100 public sites. The change effectively means that users
must remember 100 fewer passwords, significantly improving the user experience.
Furthermore, [the Aruba Health Pass](https://www.aruba.com/us/traveler-health-requirements/commonpass)
allows Aruba travelers to enter the island using
the digital health pass. Hyperledger Indy and Aries technologies empower all of the abovementioned cases.

## Workshopping

The last day of the conference was about workshopping. We joined the workshop intended
for building SSI agents with [the Aries JavaScript framework](https://github.com/hyperledger/aries-framework-javascript).
The framework approach for building the agent functionality differs from the approach
we use with our agency: the framework makes building an agent more effortless compared to
starting from scratch, but one still needs to host the agent themselves.
In the agency way, agency software runs and hosts the agent even though the client application
would be offline.

{{< imgproc workshop Fit "925x925" >}}
<em>Timo Glastra from Animo was one of the workshop hosts.</em>
{{< /imgproc >}}

The workshop's purpose was to set up a web service for issuing and verifying credentials
and a mobile application for storing and proving the credentials. Both projects,
the Node.js and the React Native applications, used the Aries JavaScript Framework
to implement the agent functionality under the hood. The organizers provided
templates – all the participants needed to do was fill out the missing parts.

The organizers arranged the workshop quite nicely, and after we solved the first hiccups
related to the building with Docker in ARM architecture, it was pretty easy to get going with
the development – at least for experienced SSI developers like us.
The session showed again how important these hands-on events are, as there was
a lot of valuable technical discussion going on the whole day.

## The Most Important Takeaways

**The technology is not mature, but we should still go full speed ahead.**

[Kaliya Young's blog post](https://identitywoman.net/being-real-about-hyperledger-indy-aries-anoncreds/)
listing the challenges in the Hyperledger Indy and Aries technologies shook
the Hyperledger SSI community just a week before the conference started. The article was
a needed wake-up call to make the community start discussing that much work is still required
before the technology is ready for the masses.

It is essential to take into account these deficiencies of the technology. Still, it shouldn't stop
us from concentrating on the most complicated problems: figuring out the best user experience
and how to construct the integrations to the legacy systems. To get started with the pilot projects,
we should take conscious technical debt regarding the underlying credential technology and rely on
the expert community to figure it out eventually. This approach is possible when we use products
such as Findy Agency that hide the underlying technical details from client applications.

**Creating a first-class SSI developer experience is challenging.**

There are many participants in a credential utilizing application flow. Quite often end-user is using
some digital wallet on her mobile device to receive and prove credentials. There might be running
a dedicated (web) application both for issuing and verifying. And, of course, a shared ledger is
required where the different participants can find the needed public information
for issuing and verifying credentials.

Sounds like a complex environment to set up on one's local computer? Making these three
applications talk with each other and access the shared ledger might be an overwhelming
task for a newcomer, not to mention grasping the theory behind SSI. However, getting
developers quickly onboard is essential when more and more developers start working with SSI.
We think we have successfully reduced the complexity level in the Findy Agency project,
which positively impacts the developer experience.

{{< imgproc interaction Fit "925x925" >}}
<em>The post-pandemic era with interaction buttons.</em>
{{< /imgproc >}}

**There's no substitute for live events and meeting people f2f.**

The event proved that live interaction between people is often more efficient and
creative than many hours of online working and countless remote meetings. Meeting people
in informal discussions is sometimes needed for new ideas to be born.
Also, the change of knowledge is so much more efficient. For example, we have had
the ledgerless run mode in our agency for several years, but only now did our
fellow agent developers realize it, and they may utilize this finding as well.
