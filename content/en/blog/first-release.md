---
date: 2021-08-11
title: "Announcing Findy Agency"
linkTitle: "Announcing Findy Agency"
description: "We, the Findy development team at OP Lab, are proud to present Findy Agency. Findy Agency is a collection of services and tools that makes building applications easier that rely on verified data exchange. Findy Agency has been published fully as open-source, so now anyone can start exploring and utilizing it."
author: Laura Vuorenoja
---

Findy Agency provides a Hyperledger Aries compatible identity agent service. It includes a web wallet for individuals and an API for organizations to utilize functionality related to verified data exchange: issuing, holding, verifying, and proving credentials. The agents hosted by the agency operate using DIDComm messaging and Hyperledger Aries protocols. Thus it is interoperable with other Hyperledger Aries compatible agents. The supported verified credential format is currently Hyperledger Indy “Anoncreds” that work with Hyperledger Indy distributed ledger. However, the plan is to add more credential formats in the future.

In this post, we share some background information on the project.

**Verified data exchange as digitalization enabler**

Distributed and self-sovereign identity, along with verified data exchange between different parties, has been an area of our interest at the OP innovation unit for quite some time. After all, when thinking about the next steps of digitalization, secure and privacy-preserving handling of identity is one of the main problem areas. When individuals and organizations can prove facts of themselves digitally, it will enable us to streamline and digitalize many processes that may be still cumbersome today, including those in the banking and insurance sectors.

Since 2019 the Findy team at OP has been working on two fronts. We have collaborated with other Finnish organizations to set up a cooperative to govern a national identity network Findy. At the same time, our developers have researched credential exchange technologies, concentrating heavily on Hyperledger Indy and Aries.

**From scratch to success with incremental cycles**

When we started the development at the beginning of 2019, the verified credential world looked a whole lot different. Low-level indy-sdk was all that a developer had if wanting to work with indy credentials. It contained basic credential manipulation functionality but nothing related to communication between individuals or organizations. We were puzzled because the scenarios we had in mind involved users with mobile applications and organizations with web services and interaction happening between these two.

Soon we realized that we needed to build all the missing components ourselves if we would want to do the experiments. And so, after multiple development cycles and as a result of these experiments became Findy Agency. The path to this publication has not always been straightforward: there have been complete refactorings and changes in the project direction along the way. However, we feel that now we have accomplished something that truly reflects our vision.

**Why the hard way?**

The situation is not anymore so sad for developers wanting to add credential support to their app as it was three years ago. There are several service providers and even open source solutions one can choose from. So why did we choose the hard way and wrote an agency of our own? There are several reasons.
* **Experience**: We believe that verified data technology will transform the internet in a profound way. It will have an impact on perhaps even the most important data processing systems in our society. We want to understand the technology thoroughly so that we know what we are betting on.
* **Open-source**: As we stated in the previous bullet, we want to be able to read and understand the software we are running. In addition, community-given feedback and contributions improve the software quality. There is also a good chance that open-sourced software is more secure than proprietary since it has more eyes looking at the possible security flaws.
* **Pragmatic approach**: We have scarce resources, so we have to concentrate on the most essential use cases. We do not wish to bloat the software with features that are far in the future if valid at all.
* **Performance**: We aim to write performant software with the right tools for the job. We also value developer performance and hence have a special eye for the quality of the API.

**The Vision**

Our solution contains several features that make our vision and that we feel other solutions are missing.

Findy Agency has been **multi-tenant** almost from the beginning of the project. It means single agency installation can securely serve multiple individuals and organizations without extra hassle.

Agency architecture is based on **a cloud strategy**. Credential data is stored securely in the cloud and cloud agents do all the credentials-related hard work on behalf of the agency users (wallet application/API users). The reasoning for the cloud strategy is that we think that individuals store their credential data rather with a confided service provider than worry about losing their device or setting up complex backup processes. Furthermore, the use cases relevant to us are also always executed online, so we have knowingly left out the logic aiming for offline scenarios. This enabled us to reduce the complexity related to mediator implementation.

Due to the cloud strategy, we could drop out the requirement for the mobile application. Individuals can use **the web wallet** with their device browser. Authentication to the web wallet is done with secure and passwordless **WebAuthn/FIDO protocol**.

Agency backend services are implemented with **performance** in mind. That is why we selected performant GoLang and gRPC as the base technologies of the project.


**Next steps**

Our experiments continue with further use case implementations as well as improving the agency with selected features.

We look forward getting feedback from the community.