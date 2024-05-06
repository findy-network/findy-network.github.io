---
title: Findy Agency
---

{{< blocks/cover title="Findy Agency" image_anchor="top" height="full" >}}
<a class="btn btn-lg btn-primary me-3 mb-4" href="/blog/">
  Blog <i class="fas fa-arrow-alt-circle-right ms-2"></i>
</a>
<a class="btn btn-lg btn-secondary me-3 mb-4" href="https://github.com/findy-network">
  Archive <i class="fab fa-github ms-2 "></i>
</a>
<p class="lead mt-5">Findy Agency is an open-source project for a decentralized identity agency.
OP Lab developed it from 2019 to 2024. The project is no longer actively maintained,
but the codes are still available.
The team occasionally writes updates on <a href="/blog">the project blog</a> on related topics
and software development in general.
</p>
{{< blocks/link-down color="info" >}}
{{< /blocks/cover >}}

{{% blocks/lead color="primary" %}}
Findy Agency is a Hyperledger-Aries compatible identity agent service. It provides a web wallet for
individuals and an API for organizations to utilize functionality related to verified data exchange:
issuing, holding, verifying, and proving credentials.

Findy Agency operates using DIDComm messaging and [Hyperledger Aries](https://www.hyperledger.org/use/aries) protocols.
The supported verified credential format is [Hyperledger Indy Anoncreds](https://github.com/hyperledger/indy-sdk).

{{% /blocks/lead %}}

{{% blocks/section color="dark" type="row" %}}
 {{% blocks/feature icon="fa-users" title="Multitenancy" %}}
Single agency installation can serve multiple individuals and organisations.
 {{% /blocks/feature %}}

 {{% blocks/feature icon="fa-cloud" title="Cloud Strategy" %}}
Credential data is stored securely in the cloud. Cloud agents do all the credentials-related hard work on behalf of the agency users.
 {{% /blocks/feature %}}

 {{% blocks/feature icon="fa-desktop" title="Web Wallet" %}}
Individuals can use their device browser without the need to install a mobile application.
 {{% /blocks/feature %}}
{{% /blocks/section %}}

{{% blocks/section color="dark" type="row" %}}
 {{% blocks/feature icon="fa-tachometer-alt" title="Speed" %}}
Backend services are implemented with highly performant [Go](https://golang.org/).
 {{% /blocks/feature %}}

 {{% blocks/feature icon="fa-fingerprint" title="Security" %}}
Web wallet and API authentication are utilizing secure [WebAuthn/FIDO protocol](https://webauthn.guide/).
 {{% /blocks/feature %}}

 {{% blocks/feature icon="fa-bolt" title="Modern API" %}}
Agency API is implemented on top of [the gRPC framework](https://grpc.io/). This technology ensures excellent performance with out-of-the-box support for a variety of languages.
 {{% /blocks/feature %}}

{{% /blocks/section %}}

{{< blocks/section>}}
 <div class="col">
  <h1 class="text-center">Demo: Findy Bots</h1>
  <p class="text-center">Example scenario implemented using Findy Agency.</p>
  <div class="text-center">
   <iframe style="max-width:100%" width="1120" height="630" src="https://www.youtube.com/embed/gVr8KwISMS4" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
  </div>
 </div>
{{< /blocks/section>}}
