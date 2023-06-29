---
date: 2023-06-22
title: "Beautiful State-Machines - FSM Part II"
linkTitle: "Beautiful State-Machines"
description: "In today’s software development landscape, efficient and robust
state management systems are more critical than ever. Finite state machines
(FSMs), together with Go’s Communicating Sequential Processes (CSP) concurrency
mechanism, we can provide a robust and elegant approach to modeling and
controlling complex systems with discrete states and transitions."
author: Harri Lainio
resources:
- src: "**.{png,jpg}**"
  title: "Image #:counter"
---

As I explained in [my previous blog
post](https://findy-network.github.io/blog/2023/03/13/no-code-ssi-chatbots-part-i/),
the idea of chatbots came quite naturally for our SSI development team. Think
tanks or research labs are outstanding workplaces when you have something to chew.
And how juicy topic the SSI has been, oh boy.

FSM chatbots started as a thought experiment, but now, when I think of the
invention, it has been quite clever in foreseeing genuine user needs. It has
lead us towards the following layer model.

{{< imgproc layers.png Resize "2553x" >}}
<em>Network Layers For SSI Are Clarifying Themselves</em>
{{< /imgproc >}}

The preceding drawing presents our ongoing layer architecture. It's (still)
based on DIDComm, but because our protocol engine implements a
technology-agnostic API, we can change the implementation to something better
without disturbing the above layers. The subject of this blog post is **our FSM
engine's** (*3rd layer from bottom*) CSP implementation that offers even more
abstraction and helps the application development with [no-code chatbot
language](https://findy-network.github.io/blog/2023/03/13/no-code-ssi-chatbots-part-i/#the-fsm-language).

## Abstraction Layers

Implementing the FSM chatbots with our protocol-agnostic API has been
eye-opening. With our API, we have solved most of the complexity problems and
brought in an elegant communication layer that hides most of the horror of DID
system, which, by to way, is not application development ready.

The objective of this blog post is to present a comprehensive exploration of my
Go-based finite state-machine implementation that leverages Go's CSP concurrency
mechanism. This post will showcase the practical applications and benefits of
using Go and CSP in building reliable and concurrent state management systems.

## Concurrency \\(\ne\\) Parallelism

I have been using multithreading programming all my career and closely
monitoring paradigms of multithreading programming since the 90s. When I started
playing with Go’s channels and [CSP programming
model](https://en.wikipedia.org/wiki/Communicating_sequential_processes), I
learned how easy it was compared to other asynchronous or multithreading
programming models.

{{< imgproc interrupt.jpg Resize "463x" >}}
<em>Interrupt Based Scheduling -- Mark Siegesmund, in Embedded C Programming, 2014</em>
{{< /imgproc >}}

If I look at the phases I have gone thru, they follow these steps harshly:
1. Using interrupts to achieve concurrency. (*MS-DOS drivers and
   [TSRs](https://en.wikipedia.org/wiki/Terminate-and-stay-resident_program),
   modem-based distributed systems, games, etc.*)
1. Using the event-driven system to achieve concurrency. (*Game development, GUI
   OS Win&Mac, transport-agnostic, i.e., modems, [proprietary protocols for
   interconnection](https://people.ece.ubc.ca/gillies/pages/9802net.html),
   [Winsocks](https://tangentsoft.com/wskfaq/articles/history.html) file
   transport framework, etc.*)
1. Using OS and HW threads to achieve concurrency. (*Unix daemon and Win
   NT service programming, C/S transport framework implementations, telehealth
   system implementation, etc.*)
1. Sharing workloads between CPU and GPU to achieve maximum parallel execution.
   (*The front/back-buffer synchronization, i.e., [culling
    algorithms](https://algorithm-wiki.csail.mit.edu/wiki/Culling) and
    [LOD](https://en.wikipedia.org/wiki/Level_of_detail_(computer_graphics)) are
    running simultaneously in a CPU during the GPU is rendering the polygons of
    the previous frame, etc.*)
1. Using libraries and frameworks
   ([tasks](https://developer.apple.com/documentation/swift/task), work queues,
    [actor model](https://en.wikipedia.org/wiki/Actor_model), etc.) to
   achieve parallel execution for performance reasons. (*Using
   [TPL](https://learn.microsoft.com/en-us/dotnet/standard/parallel-programming/task-parallel-library-tpl)
   to instantiation (i.e., common transformation matrix) pipeline for tessellated
   graphic units, etc.*)
1. Using frameworks to bring parallel execution to the application level,
   wondering why the industry starts taking steps back and prefers asynchronous
   programming models over, for example, worker threads. One answer: keep
   everything in the main thread. (*iOS [recommended] network programming, Dart
   language, node.js, etc.*)
1. Using CSP to hide HW details and still achieve a speedup of parallel execution,
   but only if it's used correctly. (*Example: Input routine -> Processing -> Output
   routine -pattern to remove blocking IO waits, etc.*)

As you can see, distributed computing goes hand in hand with concurrency. And
now distributed systems are more critical than ever.

And what goes around comes around. Now we're using a [hybrid
model](https://github.com/golang/go/issues/51071#issuecomment-1033108591) where
the scheduler combines OS threads (preemptive multitasking) and cooperative
event handling. But like everything in performance optimization, this model
isn't the fastest or [doesn't give you the best possible
parallelization](https://go.dev/blog/waza-talk) results for every algorithm. But
it seems to provide enough, and it offers a simple and elegant programming model
that almost all developers can reason with.

> Note. Go offers [`runtime.LockOSThread`
> function](https://pkg.go.dev/runtime#LockOSThread) if you want to maximize
> parallelization by allocating an OS thread for a job. 

## FSM -- State-Of-The-Art

Previous technology spikes have proven that state machines would be the right
way to go, but I would need to try it with, should I say, complete state
machines. And that was our hypothesis: *FSM perfectly matches SSI and
DIDComm-based chatbots*.

One of my design principles has always been that never create a new language,
always use an existing one. So, I tried to search for proper candidates, and I
did find a few.

### SCXML

The most promising and exciting one was
[SCXML](https://www.w3.org/TR/scxml/), but I didn't find a suitable embedded
engine to run these machines, especially as an open-source. Nevertheless, very
interesting [commercial high-end
tools](https://blogs.itemis.com/en/how-to-create-robust-system-models-with-yakindu-statechart-tools-and-verification-tools)
supported
[correctness](https://en.wikipedia.org/wiki/Correctness_(computer_science))
verification using [proving theorems](https://en.wikipedia.org/wiki/Proof_theory).

### Lua

During these state-machine language searches, I discovered [a Go-native
implementation of Lua](https://github.com/Shopify/go-lua), which was
open-source. Naturally, I considered using embedded Lua's model of
states. But I realized that some event engine would be needed, and it
would have brought at least the following challenges:

1. Whole new API and bridge to Aries protocols would be needed. A simple C/S API
   wouldn't be enough, but a notification system would also be required.
1. Lua is a Turing-complete language (correctness guarantees, the halting
   problem, etc.)
1. And final question: what extra would we be brought in when compared to
   offering Lua stubs to our current gRPC API, i.e., Lua would be treated the
   same as all the other languages that gRPC supports?

### YAML

I soon discovered that YAML might be an excellent language for FSM because it’s
proven to work for [declarative
solutions](https://en.wikipedia.org/wiki/Declarative_programming) like container
orchestration and many cloud frameworks.

Naturally, I tried to search OSS solution that would be based on YAML and would
offer a way to implement a state-machines event processor. Unfortunately, I
didn’t find a match, so we made our hybrid by offering two languages, YAML and
Lua.

Lua is now included as an embedded scripting language *for
our FSM*. It can be used to [implement custom
triggers](https://findy-network.github.io/blog/2023/03/13/no-code-ssi-chatbots-part-i/#event)
and custom output events.

You can write Lua directly to YAML files or include a file link and write Lua
scripts to external files. (*Depending on the deployment model, that could be
a security problem, but we are in an early stage of the technology. Our
deployment model is closed. The final step to solve all security problems
related to deployment and injection is when we have an integrated correctness
tool.*)

## The Event Processor 

Our FSM engine follows the exact same principle as [the SCXML processor](https://en.wikipedia.org/wiki/SCXML) does:

> An SCXML processor is a pure event processor. The only way to get data into an
> SCXML state machine is to send external events to it. The only way to get data
> out is to receive events from it.

In the software industry, there are some other similar systems, like, for example,
[eBPF](https://ebpf.io/), where correctness is provided without formal language.
eBPF automatically **rejects programs without strong exit guarantees**, i.e.,
for/while loops without exit conditions. That's achieved with static code
analysis, which allows using conventional programming languages.

Now that *we have brought Lua-scripting into our FSMs*, we should also get
*code analysis for the exit guarantees*, but let's first figure out how
good a fit it is. My first impressions have been excellent.


## Services and Conversations

The drawing below includes our multi-tenant model. FSM instances and their
memory containers are on the right-hand side of the diagram. The smaller ones
are conversation instances that hold the state of each pairwise connection
status. The larger one is *the service state machine*.

{{< imgproc cover-logical.png Resize "1630x" >}}
<em>Two Tier Multi-tenancy</em>
{{< /imgproc >}}

The service FSM is needed if the SSI agent implements a chatbot that needs to keep
track of all of the conversations like polling, voting, **chat rooms** (used as
an example), etc.

```plantuml
title Chat Room Example

actor "Dude" as Dude
participant "Dude" as ChatUI  <<chat UI>>
collections "Dudes" as ReadUI  <<read UI>>
collections "Conversation Bots" as PWBot <<pairwise FSM>>
control "Chat Room Service Bot" as Backend

== A Dude writes line ==
Dude -> ChatUI: Yo!

ChatUI -> PWBot: BasicMessage{"Yo!"}
|||
== Conversation FSM forwards msg to service FSM ==
PWBot -> Backend: BackendMsg{"Yo!"}
loop conversation count
   Backend -> PWBot: BackendMsg{"Yo!"}
== transport message thru pairwise connection ==
   PWBot -> ReadUI: BasicMessage{"Yo!"}
end
|||
```

As the sequence diagram above shows, the service FSM conceptually presents a
chat room and works as a mediator between chat room participants.

The next Go code block shows how the above FSM instances are declared at the
programming level. Note that `ServiceFSM` is optional and seldom needed. The
rest of the data is pretty obvious: 
- gRPC connection, `conn`
- conversation FSM, `md`
- and interrupt channel is given as a startup argument, `intCh`, because here,
the machine is started from the CLI tool

```go 
	intCh := make(chan os.Signal, 1)
	signal.Notify(intCh, syscall.SIGTERM, syscall.SIGINT)

	chat.Bot{
		Conn:        conn,      // gRPC connection including JWT, etc.
		MachineData: md,        // primary FSM data, i.e. pairwise lvl
		ServiceFSM:  mdService, // optional backend/service lvl FSM
	}.Run(intCh)                // let machine to know when it's time to quit
```


By utilizing the CSP model, we embrace a paradigm that emphasizes the
coordination and communication between independently executing components, known
as goroutines, in a safe and efficient manner. This combination of Go's
built-in concurrency primitives empowers us developers to create highly
concurrent systems while maintaining clarity and simplicity in their code.

## CSP & Go Code

The app logic is in the state machines written in YAML and Lua. But
surprising is how elegant the Go implementation can be when CSP is
used for the state-machine processor. And all of that without a single mutex or
other synchronization object.

The code block below is the crucial component of the FSM engine solution. It is
presented as it currently is in the code repo, because I want to show honestly
how simple the implementation is. Even the all lines aren't relevant for
this post. They are left for you to study and understand how powerful the CSP
model for concurrency is.

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
			c, alreadyExists := conversations[d.ToConnID]
			assert.That(alreadyExists, "backend msgs to existing conversations only")
			c.BackendChan <- d
		case t := <-Status:
			connID := t.Notification.ConnectionID
			c, alreadyExists := conversations[connID]
			if !alreadyExists {
				c = newConversation(info, connID, termChan)
			}
			c.StatusChan <- t
		case question := <-Question:
			connID := question.Status.Notification.ConnectionID
			c, alreadyExists := conversations[connID]
			if !alreadyExists {
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

It runs in its goroutine and serves all the input and output at the process
level. For those who come from traditional multi-thread programming, this might
look weird. You might ask why a lock doesn't make `conversations` map thread-safe.
That's the beauty of the CSP. Only this goroutine modifies `conversations`
data—no one else.

You might ask if there's a performance penalty in this specific solution, but
there is not. The `Multiplexer` function doesn't do anything that's
computationally extensive. It listens to several Go channels and delegates the
work to other goroutines.

This model has proven to be easy to understand and implement.


### Discrete State Transitions

As we saw, the `Multiplexer` function calls a function below, `backendReceived`,
when `data` arrives from `backendChan`.

```go
func (b *Backend) backendReceived(data *fsm.BackendData) {
	if transition := b.machine.TriggersByBackendData(data); transition != nil {
		b.send(transition.BuildSendEventsFromBackendData(data))
		b.machine.Step(transition)
	}
}
```

Both state-machine types (conversation/service level) follow typical transition
logic:
1. Do we have a trigger in the current state of the machine?
1. If the trigger exists, we'll get a transition object for that.
1. Ask the `transition` to build all send events according to input data.
1. Send all output events.
1. If previous steps did succeed, make a state transition step explicit.

### "Channels orchestrate; mutexes serialize"

I'm not a massive fan of the [idiomatic
Go](https://dave.cheney.net/2020/02/23/the-zen-of-go) or [Go
proverbs](https://go-proverbs.github.io/). My point is that you shouldn't
need them. The underlying semantics should be strong enough.

Luckily the world isn't black and white. So, let's use one proverb to state
something quite obvious.

> "Channels orchestrate; mutexes serialize"

That includes excellent wisdom because it isn't prohibiting you from using the
mutexes. It clearly states that we need both, but they are used differently.
That said, the below code block shows the *elegance* you can achieve with Go
channels.

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

If you have never seen a code mess where a programmer has tried to solve a
concurrence task by only having common control flow statements like if-else,
attempt to envision an amateur cook that tries to make at least four dishes
simultaneously with poor multitasking capabilities. He has to follow recipes
literally for every dish from several cookbooks. I think then you get the
picture.

## Conclusion

I hope I have shown you how well FSM and CSP fit together. Maybe I even
encouraged you to agree that SSI needs [better abstraction
layers](http://findy-network.github.io/blog/2022/03/05/the-missing-network-layer-model/)
before we can start full-scale application development. If you agree we're 
on the right path, please join and start coding with us!
