---
date: 2023-04-29
title: "Implementation - FSM Part II"
linkTitle: "FSM Implementation"
description: "In today's software development landscape, the need for efficient
and robust state management systems is more critical than ever. Finite state
machines (FSMs) together with Go's Communicating Sequential Processes (CSP)
concurrency mechanism, we can provide a powerful and elegant approach to
modeling and controlling complex systems with discrete states and transitions."
author: Harri Lainio
resources:
- src: "**.{png,jpg}**"
  title: "Image #:counter"
---

As I said in [my previous blog
post](https://findy-network.github.io/blog/2023/03/13/no-code-ssi-chatbots-part-i/),
the idea of chatbots came quite naturally for our SSI development team. Think
tanks or research labs are wonderful workplaces when you have something to chew.
And how juicy topic the SSI has been, oh boy.

FSM chatbots started as a thought experiment, but now, when I think the
invention it has been quite clever foreseeing of the genuine user needs. The
same goes for technology. We desperately needed [better abstraction
layers](http://findy-network.github.io/blog/2022/03/05/the-missing-network-layer-model/)
over DID-shit.

(*Do you know the nagging feeling that something is wrong? We are
starting to get our hands around it; thanks to these PoCs and technology spikes. My upcoming blog post will be all about that.*)

{{< imgproc layers.png Resize "1600x" >}}
<em>Network Layers For SSI Are Clarifying Them Selves</em>
{{< /imgproc >}}

Implementing the FSM chatbots with our protocol-agnostic API has been eye
opening. With our API we have managed to solve one problem and brought in an
elegant communication layer which hide most of the ugliness of DID-system which
is not application development ready as-is.

## Concurrency \\(\ne\\) Parallelism

When I started to play with Go's channels and its [CSP programming
model](https://en.wikipedia.org/wiki/Communicating_sequential_processes), I
learned how easy it was when compared to some other asynchronous or
multithreading programming models. I have been using multithreading programming
models almost whole of my career and for that closely monitoring paradigms of
multithreading programming since 90's.

{{< imgproc interrupt.jpg Resize "463x" >}}
<em>Interrupt Based Scheduling</em>
{{< /imgproc >}}

If I look at the phases I have gone thru, they follow harshly these steps:
1. Using interrupts to achieve concurrency.
1. Using event-driven system to achieve concurrency.
1. Using OS (and later HW) threads to achieve concurrency.
1. Sharing work loads between CPU and GPU to achieve maximum parallel execution.
1. Using libraries and frameworks (tasks, work queues, actor model, etc.) to
   achieve parallel execution for performance reasons.
1. Using frameworks to bring parallel execution to application level, wondering
   why industry starts to take steps back and prefer asynchronous programming
   models over e.g. worker threads. (One answer: keep everything in the main thread)
1. Using CSP to hide HW details and still achieve speedup of parallel execution,
   but only if it's used correctly.

Like so many other things the circle is closed and now we're using hybrid
execution model where the scheduler is combination of OS treads and co-operative
event handling. But like everything in performance optimization, this model
isn't the fastest or doesn't give you the best possible parallelization results
for every algorithm. But it seem to give enough, and it offers a simple and
elegant programming model that almost all developers are able to reason.

The objective of this blog post is to present a comprehensive exploration of my
Go-based finite state-machine implementation that leverages Go's CSP concurrency
mechanism. Through this post, we aim to showcase the practical applications
and benefits of using Go and CSP in building reliable and concurrent state
management systems.

Our FSM follows the exact same principle as SCXML processor does:

> An SCXML processor is a pure event processor. The only way to get data into an
> SCXML state machine is to send external events to it. The only way to get data
> out is to receive events from it.

By utilizing the CSP model, we embrace a paradigm that emphasizes the
coordination and communication between independently executing components, known
as goroutines, in a safe and efficient manner. This combination of Go's
built-in concurrency primitives, empowers us developers to create
highly concurrent systems while maintaining clarity and simplicity in their
code.

Throughout this document, we will delve into the design, implementation, and
testing aspects of our Go-based finite state-machine solution. We will explore
the fundamental concepts of FSMs, discuss the CSP concurrency mechanism in Go,
present our design choices, explain the implementation details, and evaluate the
system's performance and correctness.

By the end you should have
understanding of the benefits and practical implications of employing Go's CSP
concurrency mechanism in conjunction with finite state machines. Whether you are
a software developer interested in building concurrent systems or a researcher
seeking insights into effective state management, this document aims to provide
valuable insights and inspiration for your own projects.

Now that we have set the stage, let us delve into the exciting world of finite
state machines, Go's CSP concurrency mechanism, and our Go-based implementation
for SSI chatbot state-machine language.

```plantuml
title Credential has one time value/vote

actor "Voter" as Voter
participant "Voter" as Prover  <<holder>>
participant "Poll Station" as Verifier <<verifier/issuer>>
database "Votes and Ballots" as DB

== 0. Make secure connection  ==
Prover -> Verifier: Connection Request {Voting Room ID}
note right
	Voting room is in the invite and
	the invite is presented during
	the meeting
end note
Verifier -> Prover: Connection Response
|||
== 1. Start Voting Session ==
Verifier -> Prover: Proof Request
note right
 	Poll Station/Voting room request
 	the proof (Sts Protocol Msg)
end note

Prover -> Verifier: Present Proof {Ballot ID}
note right
 	When proof is valid, and it is
 	when proof is verified, then
 	the Unique ballot ID is valid
end note

== 2. Vote / Spend ==
Verifier -> DB: Is Ballot ID already used?
note left
 	We just check that ballot is not used yet.
 	Note! we could mark it "under process"
 	Test_and_set -transaction?
end note

alt invalid Ballot
	Verifier -> Prover: **NACK**
	Prover -> Voter: Error message
else VALID
	Verifier -> Prover: Vote/Selection/Spend/Cancel -**Question**
	Prover -> Voter: Ask decision
end
alt decision is to vote #
	Voter -> Prover: My decision
	Prover -> Verifier: Use the ballot for vote
	activate Verifier
	Verifier -> DB: transaction{invalidate\nballot ID AND vote}
	== 3. Issue Receipt ==

	Verifier -> Prover: Issue Receipt/Confirmation/Replacement
	deactivate Verifier
	note right
		We combine prove and issu protocols
	end note
else decides cancel
	Voter -> Prover: Cancel
	Prover -> Verifier: Cancel
end
```

Introduction: chatGPT

```plantuml
a -> b : hello
a -> b : hello2
b -> a

```

<UML Drawings: class diagram>
Machine instances, conversation, Backend aka Service, channels, etc.

And since 2004 I started to study more of parallel algorithms and managed to
design and implement an algorithm to rip of transformation matrix for readily
tessellated 3D objects. Think about stadium which have 100.000 similar chairs.
Each chair has 3.000 polygons. Let's say one polygon needs only 10 bytes of
memory (which isn't possible). Chairs would need 3GB VRAM. With the algorithm we
could have only one chair tessellation, and 100.000 transformation matrices.
Each matric 4x4x8 = 98 bytes. 1MB VRAM. We can present the stadium with out
performance, or memory hickups, or out-core-algorithms. 

I did learn that almost all of software platforms I was using around 2004-2010
started to build abstractions to hide actual OS threads. Maybe the most
interesting SDK was TBB (Threading Building Blocks) because it came from Intel.
I knew their debuggers, but otherwise it wasn't so famous SW house, at least for
me.

Hold on, I'll stop just a moment. My point is that, because my interest of
threading libraries and abstraction models, I was interested about Go. First
native language (I don't have anything against managed languages, but..) where
multi-core support was in the language itself. Now, I think, I'm ready to get to
the point.



, it did notice that even a multi-tenant
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

## Chatbot From Go code

The start of the chat bot is pretty easy as you can see from the next Go block:

```go 
	intCh := make(chan os.Signal, 1)
	signal.Notify(intCh, syscall.SIGTERM, syscall.SIGINT)

	chat.Bot{
		Conn:        conn,      // gRPC connection including JWT, etc.
		MachineData: md,        // primary FSM data, i.e. pairwise lvl
		ServiceFSM:  mdService, // optional backend/service lvl FSM
	}.Run(intCh)                // let machine to know when it's time to quit
```

Pretty simple, huh? Yes, it is.

The app logic is in the state-machines. Most of the solutions don't even need a
service level machine, because the DIDComm has been one-on-one protocol. What we
are talking in these discussions are for our eyes only, no one else.

The service machine step in when we need to implement something more complex
like voting, chat room, etc. Something where participants need to be controlled
by common factor: voting subject, chat room = subject of the conversation.

This model has proven to be easy to understand and implement.

```go
func Multiplexer(info MultiplexerInfo) {
	glog.V(3).Infoln("starting multiplexer", info.ConversationMachine.FType)
	termChan := make(fsm.TerminateChan, 1)

	var backendChan fsm.BackendInChan
	if info.BackendMachine.IsValid() {
		b := newBackendService()
		backendChan = b.BackendChan
		b.machine = fsm.NewMachine(*info.BackendMachine)
		try.To(b.machine.Initialize())
		b.machine.InitLua()

		glog.V(1).Infoln("starting and send first step:", info.BackendMachine.FType)
		b.send(b.machine.Start(fsm.TerminateOutChan(b.TerminateChan)))
		glog.V(1).Infoln("going to for loop:", info.BackendMachine.FType)
	}

	for {
		select {
		// NOTE. It's OK to listen nil channel in select.
		case bd := <-backendChan:
			backendMachine.backendReceived(bd)

		case d := <-ConversationBackendChan:
			c, ok := conversations[d.ToConnID]
			assert.That(ok, "backend msgs to existing conversations only")
			c.BackendChan <- d
		case t := <-Status:
			connID := t.Notification.ConnectionID
			c, ok := conversations[connID]
			if !ok {
				c = newConversation(info, connID, termChan)
			}
			c.StatusChan <- t
		case question := <-Question:
			connID := question.Status.Notification.ConnectionID
			c, ok := conversations[connID]
			if !ok {
				c = newConversation(info, connID, termChan)
			}
			c.QuestionChan <- question
		case <-termChan:
			// One machine has reached its terminate state. Let's signal
			// outside that the whole system is ready to stop.
			info.InterruptCh <- syscall.SIGTERM
		}
	}
}
```

```go
func (b *Backend) backendReceived(data *fsm.BackendData) {
	if transition := b.machine.TriggersByBackendData(data); transition != nil {
		b.send(transition.BuildSendEventsFromBackendData(data))
		b.machine.Step(transition)
	}
}
```

```go
func (c *Conversation) Run(data fsm.MachineData) {
	c.machine = fsm.NewMachine(data)
	try.To(c.machine.Initialize())
	c.machine.InitLua()
	c.send(c.machine.Start(fsm.TerminateOutChan(c.TerminateChan)), nil)

	for {
		select {
		case t := <-c.StatusChan:
			c.statusReceived(t)
		case q := <-c.QuestionChan:
			c.questionReceived(q)
		case hookData := <-c.HookChan:
			c.hookReceived(hookData)
		case backendData := <-c.BackendChan:
			c.backendReceived(backendData)
		}
	}
}
```

### Conceptual Meta-Model

## Future Features

