---
title: "Interoperability Testing Demo"
linkTitle: "Interoperability Demo"
date: 2022-01-19
weight: 5
description: >
  Demo of Findy Agency interoperability testing
---

{{< youtube W1H7ppS2Y6M >}}

<br>

- **Test 1: Findy Agency based issuer/verifier with Lissi Wallet**

  A Findy Agency utilizing [issuer tool](https://github.com/findy-network/findy-issuer-tool) invites [Lissi Wallet](https://lissi.id) to form a pairwise connection. Issuer tool sends and verifies a credential with Lissi Wallet.

- **Test 2: Findy Agency Web Wallet with Trinsic Wallet**

  Findy Agency Web Wallet user forms a pairwise connection with [Trinsic Wallet](https://trinsic.id/trinsic-wallet/) user. Wallet applications send Aries basic messages to each other.

- **Test 3: ACA-Py based issuer/verifier with Findy Agency Web Wallet**

  [Aries Test Harness](https://github.com/hyperledger/aries-agent-test-harness) runs [ACA-Py](https://github.com/hyperledger/aries-cloudagent-python)-based agents that issue and verify credentials with Findy Agency Web Wallet.
