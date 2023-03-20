---
date: 2023-03-13
title: "Chatbot Language - Part I"
linkTitle: "Chatbot Language"
description: "I implemented a new
[FSM](https://en.wikipedia.org/wiki/Finite-state_machine) language for our SSI
chatbots a couble of years ago. It started as an experiment, a technology spike,
but ended as a new feature of our SSI agency. Since then, we have had capability
to build multi-tenant agent applications without coding, which is huge if you
compare to other DID agents. Maybe in the future, we'll able to offer these
tools to the end-users as well."
author: Harri Lainio
resources:
- src: "**.{png,jpg}**"
  title: "Image #:counter"
---

In this blog post, I'll explain the syntax of our chatbot language. There'll be
a second post where we'll make a deep dive into the implementation details. Good
news is that the language itself is simple and we already offer some development
tools like UML rendering. Our ultimate goal is to find proper model checker and
theorem proofer for the correctness of the chatbot applications.

Our team got an idea of chatbots quite early after we've started to play with
verifiable credentials and SSI.

I think that chatbots and zero UI is some sort of a lost opportunity for
SSI/DID. The backbone of the DID network is its peer to peer communication
protocol. Even, that the client/server API model is very convenient to use and
understand, [DIDComm](https://identity.foundation/didcomm-messaging/spec/) based
apps need something different -- more conversational. What would be more
conversational than chatting?

Anyhow, we have been positively surprised how far you can get without NLP but
just a strict state machine guided conversation where each party is able to
proof facts about them selves when needed. And of course, you can build perfect
hybrid where you fix structural parts of the discussion with the FSM and leave
unstructured parts for the NLP engine.

## Hello World

The chatbot state machines are written in YAML (JSON accepted). Currently, a
YAML file includes one state machine at the time.

As all programming books and manuals start with the hello world app, we do the
same.

```YAML
initial:                                             # (1)
  target: INITIAL
states:                                              # (2)
  INITIAL:                                           # (3)
    transitions:                                     # (4)
    - trigger:                                       # (5)
        protocol: basic_message                      # (6)
      sends:                                         # (7)
      - data: Hello! I'm Hello-World bot.
        protocol: basic_message                      # (8)
      target: INITIAL                                # (9)
```

The previous machine is almost as simple as it can be that it does something.
Let's see what the lines are for:
1. **Initial state transition** is mandatory. It's executed when machine is
   started. It's same as all the state transitions in our syntax but it doesn't
   have transition trigger.
2. **States** are listed next. There are no limits how many states the machine
   holds.
3. We have only one **state** named `INITIAL`. Each state must have an unique
   name.
4. States include **transitions** to next states (`target`). We have one in this
   machine, but there is no limit how many transitions a state can have.
5. Each transition has **a trigger event**.
6. Triggers have [**protocol**](#protocol) that is in this case `basic_message`.
7. We can **send** limitless a mount of `events` during the state transition.
8. In this machine we send a `basic_message` where the `data` is `Hello! I'm
   Hello-World bot.`
9. Our `transition` `target` is the `INITIAL` state. It could be what ever state
   that exist in the machine.

Did you get what the machine does? You can try it by following the instructions
in [Findy CLI's readme](https://github.com/findy-agent-cli/README.md) to setup
your playground/run-environment. After you have setup pairwise connection
between two agents, execute this to other agents terminal:

```console
findy-agent-cli bot start <Hello-World.yaml> # or what name you saved above
```

For other agent use two terminals and give these commands to them:
```console
# terminal 1
findy-agent-cli bot read # listens and show other end's messages
```
```console
# terminal 2
findy-agent-cli bot chat # sends basic_message's to other end thru the pairwise
```

And when you want to render your state machine in UML, give this command:
```console
findy-agent-cli bot uml <Hello-World.yaml> # name of your FSM
```
The result looks like this:

{{< figure src="/blog/2023/03/13/chatbot-language-part-i/hello1.svg" >}}
*Hello World Chat Bot FSM*

Maybe the UML rendering helps understanding. It's also very good tool for manual
verification. Automatic model checking is something we are studying in the
future.

## The FSM Language

The YAML-based state machine definition language is currently as simple as
possible.

### State Machine

First level is the **states**, which are the primary building blocks
of the machine. A machine has one or more states. During the execution the
machine can be only one state at the time. Sub- or embedded states aren't
supported because they are only convenient, not mandatory. Also parallel states
are out-scoped.

**One of the states must be market as `initial`**. Every chatbot conversation
runs its own state machine instance, and the current implementation of machine
termination *terminates all running instances* of the machine. **The state
machine can have multiple termination states.** Note, most of the real-world
multi-tenant use cases don't need machine termination. Termination is especially
convenient for the *one time use as in scripts*. But chatbot services *shouldn't
use termination* because it stops all of the state machine instances. Depending
of the feedback we get, we might change that later.

Each state can include relations to other states including itself. These
relations are **state-transitions** which include:
- **a trigger event**
- **send events**
- **a target state**

### Meta-Model

Information about meta-model behind each state machine can be found from
the following diagram. As you can see the **Machine** receives and sends
**Events**. And **States** controls which inputs, i.e., **triggers** are *valid,
when and how.*

{{< figure src="/blog/2023/03/13/chatbot-language-part-i/Main.svg" >}}
*Conceptual Meta-Model*

Next we will see how the *Event* is used to running the state machine. After the
next chapter we should learn to declare all supported types of input and output
events.

## Event

As we previously defined state transitions are input/output entities. Both
input and output are event-based. An input event is called `trigger:` and
outputs are `sends:`.

The event has important fields which we describe next more detailed.
- `rule:` Defines an operation to be performed when send an event or what
should happen when input an event.
- `protocol:` Defines a protocol to be executed when sending or a protocol event 
that triggers a state transition.
- `data:` Defines additional data related to the event in `string` format.

```YAML
      ...
      trigger:                                             # 1
        data: stop                                         # 2
        protocol: basic_message                            # 3
        rule: INPUT_EQUAL                                  # 4
```
1. Simple example of the *trigger event*:
2. `stop` is a *keyword* in this trigger because of the rule (see # 4).
3. The keyword is received thru the `basic_message` Aries DIDComm protocol.
4. `INPUT_EQUAL` means that if incoming data is equal to `data:` field, the
   event is accepted, and a state transition triggered.


### Rule

The following table includes all the accepted rules and their meaning.

| Rule | Meaning |
|------|---------|
| "OUR_STATUS" | Monitors our multi-state protocol progress. |
| "INPUT" | Copies input event data as-is to output event data. Rarely needed, more for tests. |
| "INPUT_SAVE" | Saves input data to a named register. The`data:` defines the name of the register. |
| "FORMAT" | Calls `printf` type formatter for send events where format string is in `data:` and value is input `data:` field. |
| "FORMAT_MEM" | Calls `Go template` type formatter for send events where format string is in the `data:` field, and named values are in memory register. |
| "GEN_PIN" | A new random 6 digit number is generated and stored into PIN-named register, and FORMAT_MEM is executed according to the `data:` field. |
| "INPUT_VALIDATE_EQUAL" | Validates that received input is equal to register value. Register name is in `data:` field. |
| "INPUT_VALIDATE_NOT_EQUAL" | Negative of previous, e.g. allows us to trigger transition if input doesn't match. |
| "INPUT_EQUAL" | Validates that coming input data is same in the `data:` field machine definition (YAML). |
| "ACCEPT_AND_INPUT_VALUES" | Accepts and stores a proof presentation and its values. |
| "NOT_ACCEPT_VALUES" | Declines a proof presentation. |

### Protocol

The following table includes all the accepted Aries protocols and their
properties.

| Protocol | In/Out | RFC | Meaning |
|----------|--------|-----|---------|
| `basic_message`| Both | [0095](https://github.com/hyperledger/aries-rfcs/blob/main/features/0095-basic-message/README.md) | Send or receive a messaging protocol (text) |
| `trust_ping`| Both | [0048](https://github.com/hyperledger/aries-rfcs/blob/main/features/0048-trust-ping/README.md) | A ping protocol for a DIDComm connection|
| `issue_cred`| Out | [0036](https://github.com/hyperledger/aries-rfcs/blob/main/features/0036-issue-credential/README.md) | Issue a verifiable credential thru DIDComm |
| `present_proof`| Out | [0037](https://github.com/hyperledger/aries-rfcs/blob/main/features/0037-present-proof/README.md) | Request a proof presentation thru DIDComm |
| `connection`| In | [0023](https://github.com/hyperledger/aries-rfcs/blob/main/features/0023-did-exchange/README.md) | A new pairwise connection (DID exchange) is finnished for the agent |

The following table includes currently *recognized* general protocols and their
properties. Recognized protocols aren't currently fully tested or implemented,
only keywords are reserved and properties listed.

| Protocol | In/Out | Spec | Meaning |
|----------|--------|-----|---------|
| `email`| Both | JSON | Send or receive an email message (text) |
| `hook`| Both | Internal | Currently reserved only for internal use |

On the design table we have ideas like REST endpoints, embedded scripting
language (Lua), file system access, etc.

### Data

The `data` field is used to transport event's data. Its function is determined by
both `rule` and `protocol`. Please see the next chapter, **Event Data**.

### Event Data

The `event_data` field is used to transport event's type checked data. Its **type**
is determined by both `rule` and `protocol`. Currently, it's explicitly used
only in the `issue_cred` protocol:

```YAML
  ...
  data:
  event_data:
    issuing:
      AttrsJSON: '[{"name":"foo","value":"bar"}]'
      CredDefID: <CRED_DEF_ID>
  protocol: issue_cred
```

We are still *work-in-progress* to determine what will be the final role of `data`
and `event_data`. Are we going to have them both or something else? That will be
decided according the feedback we get from the FSM chatbot feature.

## Issuing Example

The following chatbot is illustration from our real-world chatbot from our
[Identity Hackathon 2023 repository.](https://github.com/findy-network/identity-hackathon-2023/blob/master/cli/issue-bot.template.yaml)
It's proven to extremely handy to be able kick these chatbots up during the demo
or development without forgetting the production in the future.

{{< figure src="/blog/2023/03/13/chatbot-language-part-i/issue-one.svg" >}}
*Automatic Issuing Chat Bot*

### Omni-Channel Chatbot

The diagram below presents another example of the automatic issuing chatbot
for verified an email address. Please read carefully the state transition
arrows. They define triggers and events to send. There is a transition that
sends an Aries `basic_message` and an `email` in same transition. The email
message that's built by the machine, includes a random PIN code. As you can see
the PIN-code can be properly verified by the state machine.

{{< figure src="/blog/2023/03/13/chatbot-language-part-i/issue.svg" >}}
*Automatic Email Credential Chat Bot*

It's been rewarding to notice how well chatting and using verifiable credentials
fit together. As a end-user you don't face annoying context switches but
everything happens in the same logical conversation.

## Future Features

The most important task in the future will be the documentation. Hopefully, this
blog post help us to get it going.

Something we have thought during the development:
- transition triggers are currently SSI-only which can be changing in the
  future
- extremely simple memory model
    - no persistence model
- verification/simulation tools: model checker
- simple scripting language inside the state machine
- deployment model: cloud, end-user support
- end-user level tools

Please take it for the test drive and let us know what you think. Until the next
time, see you!

