---
date: 2024-03-19
title: "FSM Implementation - Part II"
linkTitle: "FSM Implementation"
description: "Before I implemented a new FSM language for our SSI chatbots, I
did a study what's available. Few things did pop up, and I explain them more
detailed in this post. None of those existing solutions wasn't good enough for
the purposes we needed. I also explain our needs in the post more detailed."
author: Harri Lainio
resources:
- src: "**.{png,jpg}**"
  title: "Image #:counter"
---

FSM chatbots started as an experiment, a technology spike, but ended as a new
key feature of our SSI agency. As I said my [previous
post](https://findy-network.github.io/blog/2023/03/13/no-code-ssi-chatbots-part-i/)
chatbots came quite naturally for our team.

When I started to play with Go's
channels and the CSP programming model, it did notice that even a multi-tenant
chatbot "language", i.e. just text file's lines were echoed back to other end,
was just a few lines of code. The technical idea was ready: we needed a
transcript language that would guide a chatbot take simple steps according other
end's inputs (Aries protocol events). And because Aries protocols 'hide' the
complex stuff like presenting a proof or issuing a credential' (we used as a
receipt since the first bot).

<picture from our slides?>

# State-Of-The-Art

One of my own design principles has always been that never create a new
language, but always use existing. I tried to search proper candidates and I did
find a few. The most promising and interesting was
[SCXML](https://www.w3.org/TR/scxml/), but I didn't find a suitable embedded
engine to run these machine. Also the XML based format isn't so human friendly
as we now all know.

During these searches I found out that there was [Go-native implementation of Lua](link)
which was open-source. And Lua is now included as and embedded scripting
language *for the FSM*. I can be used to implement custom triggers (LINK-to-part1)
as well as custom output events.

I saw during the studies that all-in for the *embedded* Lua would had brought at least following
challenges:
1. Whole new API and bridge to Aries protocols. Note that simple C/S API
   wouldn't be enough but notifications as well.
2. Lua is turing-complete language

I studied
 which still is an option for the future.
It's standard and there are good tools for it. Unfortunately, proper open-source
tools were missing. So, our decision was to build as simple language with tools
that exist in Unix and build it as fast as possible. The end result is better
than we could have guessed -- and, of course, it proved our hypothesis.

# The Requirements

The original idea for pairing SSI with FSM came from the fact that agent-based
DIDComm is also message driven. And that's very suitable for states and their
triggers, events.

## Encapsulation

Our FSM follows the exact same principle as SCXML processor does:

> An SCXML processor is a pure event processor. The only way to get data into an
> SCXML state machine is to send external events to it. The only way to get data
> out is to receive events from it.

In this blog post, I'll explain the syntax of our chatbot language. Before the
design, and implementation I made a comprehensive study of what was available
(state of the art) and thought what our actual needs would be. For a short
period of time I even considered to use some touring complete language, but
understood that it wouldn't have been a good idea when proofing the correctness
of such a chatbot.

There'll be a second post where we'll make a deep dive what happens under the
hood. Good news is that the language itself is simple and we already offer some
development tools like UML rendering.

Our team got an idea of chatbots quite early after we started to play with
verifiable credentials and SSI. I still think that chatbots and zero UI is some
sort of lost opportunity for SSI/DID.

Even the client/server API model is very convenient to use and understand,
self-sovereignty needs something different -- more conversational. What would be
more conversational than chatting? (Show me yours and I show mine)

Anyhow, we have been positively surprised how far you can get without NLP but
just a strict state machine guided conversation where each party is able to
proof needed facts about them selves when needed.

## FSM Syntax

The chatbot state machines are written in YAML (or JSON). Currently, a YAML
file includes only one state machine.

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
6. Triggers have **protocol** that is in this case `basic_message`. It could be
   any of the these Aries protocols:
   - `basic_message`: send or receive messaging protocol
   - `issue_cred`: we issue a verifiable credential
   - `trust_ping`: we initiate ping protocol
   - `present_proof`: we request a proof presentation 
   - `connection`: new pairwise is created
   - or other protocols like email, http, etc. which are in design table
7. We can **send** limitless a mount of `events` during the state transition.
8. In this machine we send a `basic_message` where the `data` is `Hello! I'm
   Hello-World bot.`
9. Our `transition` `target` is the `INTIAL` state. It could be what ever state
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
# terminal 2
findy-agent-cli bot chat # sends basic_message's to other end thru the pairwise
```

And when you want to render your state machine in UML, give this command:
```console
findy-agent-cli bot uml <Hello-World.yaml> # or name of your FSM
```
The result looks like this. Maybe the UML rendering helps understanding.


## The FSM Language

The YAML-based state-machine definition language is currently as simple as
possible. First level is the **states**, which are the primary building blocks
of the machine. A machine has one or more states. During the execution the
machine can be only one state at the time. Sub- or embedded states aren't
supported because they are only convenient, not mandatory. Also parallel states
are out-scoped.

**One of the states must be market as `initial`**. Every chatbot
conversation runs its own state-machine, and the current implementation of
machine termination *terminates all running instances* of the machine. **The state
machine can have multiple termination states.** Note, most of the real-world
multi-tenant use cases don't need machine termination. Termination is especially
convenient for the one time script use as we can see later.

Each state can include relations to other states including itself. These
relations are **state-transitions**. Each state-transition has **a trigger
event**, **send events**, and **a target state**.

### Conceptual Meta-Model

More information about meta-model behind each state machine can be found from
the following diagram. As you can see the **Machine** receives and sends
**Events**. And **States** controls which inputs, i.e., **triggers** are *valid,
when and how.*

{{< figure src="/blog/2023/03/13/finite-state-machine-language-part-i/Main.svg" >}}
*Conceptual Meta-Model*

## Event

### Rule

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

| Protocol | In/Out | Meaning |
|----------|--------|---------|
| `basic_message`| Both | Send or receive messaging protocol |
| `trust_ping`| Both | we initiate ping protocol |
| `issue_cred`| Out | we issue a verifiable credential |
| `present_proof`| Out | we request a proof presentation |
| `connection`| In | new pairwise is created |


### Data

## Issuing Example

The diagram below presents a real-world example of the automatic issuing chat
bot for verified an email address. Please read carefully the state transition
arrows. They define triggers and events to send. There is a transition that
sends an Aries `basic_message` and an `email` in same transition. The email
message that's built by the machine, includes a random PIN code. As you can see
the PIN-code can be properly verified in the machine.

{{< figure src="/blog/2023/03/13/finite-state-machine-language-part-i/issue.svg" >}}
*Automatic Email Credential Chat Bot*

It's been rewarding to notice how well chatting and using verifiable credentials
fit together. As a end-user you don't face annoying context switches but
everything is some logical conversation.

## Future Features

- transition triggers are currently SSI-centric which can be changin in future.
- extremely simple memory model
    - no persistence model
- verification/simulation tools
- simple scriptin language inside the state machine
- deployment model
- end-user level tools


The state machines are written in YAML (or it accepts JSON as well).

NOTE. Memory leaks: we could offer some sort of the verification tool for this.
NOTE. Run initialize for FSM file before start if possible? To check syntax.

