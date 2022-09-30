---
date: 2022-09-30
title: "Ledger Multiplexer"
linkTitle: "Ledger Multiplexer"
description: "I implemented a ledger multiplexer in Go for Indy SDK (libindy).
You'll be able to replace Indy ledger with whatever verified data registry.
You'll be able to have automatic ledger backups. And you'll be able to remove the
ledger's performance bottleneck with just a few simple and standard software
engineering practices."
author: Harri Lainio
resources:
- src: "**.{png,jpg}**"
  title: "Image #:counter"
---

In this technical blog post, I'll explain how I implemented a plugin system into
our [Indy SDK](https://github.com/hyperledger/indy-sdk)
[Go wrapper](https://github.com/findy-network/findy-wrapper-go) and then
extended it to work as a multiplexer. The plugin system allows us to use a
key/value-based storage system instead of the normal Indy ledger. And
multiplexing extended the functionality to use multiple data sources
simultaneously and asynchronously. For instance, we can add a memory cache to
help Indy ledger, which has been proving to make a considerable difference in a
multi-tenant agency that can serve thousands of different wallet users
simultaneously.

{{< figure src="/blog/2022/09/30/ledger-multiplexer/Plugin.svg" >}}
*Package And Interface Structure*

As you can see in the picture above `plugin` package defines just needed types
and interfaces that the `addons` package's plugins implement. The `FINDY_LEDGER`
plugin routes transactions to the authentic Indy ledger. We will show in this
post how it's implemented and used.

## Reduce Setup Complexity

Indy ledger has been bugging me since we met each other:

- Why was it written in Python when everybody had to know that it would be
  a performance-critical part of the system?
- Why it was implemented with ZeroMQ when it used so simple TCP/IP communication? (Was it
  because of Python?) Anyway, every dependency is a dependency to handle.
- Why didn't it offer a development run mode from the beginning? For instance, a
  pseudo node would offer local development and test environment?
- Why it didn't offer a straightforward own separated API? With Indy SDK, you had to build
  each transaction with three separate functions that weren't general but
  entity-specific, like `indy_build_cred_def_request()`.
- Why the transaction model was so unclear and 'hid' from the rest of the
  Indy SDK functions? (See previous one.)
- Why could Indy nodes not idle? When no one was connected to the ledger, it still
  used a shit load of CPU time per node, and there was a four (4) node minimum in
  the local setup.

For the record, first, it's too easy to write the previous list when someone has
done everything ready; second, I appreciate all the work Hyperledger Indy has
done.

So why bother nagging? To learn and share that learning. If our team or I will
ever build anything where we would use a distributed ledger from scratch, we
would follow these guidelines:

- Give a straightforward and separated API for ledger access.
- Implement some out-of-the-box mocking for development, e.g., use a memory
  database.
- Offer a way to set up a production system without an actual consensus protocol and
  DLT but offer a single database and tools to migrate that to real DLT when
  the time comes.

## Support TDD (Test-Driven Development)

I have noticed that we programmers far too easily avoid automating or
documenting our work. Luckily, Go as a language selection supports that very
well. Fortunately, our two-person team focused on how we should rely on
code-centric automated testing in everything from the beginning.

I wanted to support both unit and integration tests without the mock framework's
help and the need to set up a complex environment just for simple testing. My
choice was to have a memory ledger. That would also help with instrumentation
and debugging of our code.

Soon I noticed that the memory ledger was insufficient to support fast phase
development, but we would need some persistence. A JSON file, aka file ledger,
seemed an excellent way to start. The JSON would support tracing and offer
another interface for us humans.

When putting these two together, I ended up building our first plugin system for
VDR.

We were so happy *without* the bloated ledger that we all started to think about
how we could remove the whole ledger out of the picture permanently, but that's
it is own story to tell.

## Reverse-engineering Indy SDK

Before I could safely relay that my solution won't hit my face later, I had to
check what Indy functions don't separate wallet and ledger access, i.e., they
take both wallet handle and ledger connection handle as their argument. I found
two that kinds of functions that we were using at that time:

1. `indy_key_for_did()`
2. `indy_get_endpoint_for_did()`

Both functions check if they can find information from the wallet, and the
ledger is the backup. *For those listening to our presentation on Hyperledger
Global Forum, I mistakenly said that I used -1 for the wallet handle, which is
incorrect. Sorry about that. (1-0, once again, for documentation.)*

I discovered that I could enumerate our ledger connection handles
starting from -1 and going down like -1, -2, and so forth. So I didn't need any extra
maps to convert connection handles, which would add complexity and affect
performance. I could give connection handles with negative values to
the above functions, and `libindy` accepted that.

Here you can see what the first function (`indy_key_for_did()`) looks like in
our wrapper's API. And I can assure you that `c2go.KeyForDid` internal
implementation wrapper for Go's CGO, which is a C-API bridge, doesn't treat
`pool` and `wallet` handles differently before passing them to Indy SDK's Rust
code. The pool handle can be -1, -2, etc.

```go
// Key returns DIDs key from wallet. Indy's internal version tries to get the
// key from the ledger if it cannot get from wallet. NOTE! Because we have our
// Ledger Plugin system at the top of the wrappers we cannot guarantee that
// ledger fetch will work. Make sure that the key is stored to the wallet.
func Key(pool, wallet int, didName string) ctx.Channel {
	return c2go.KeyForDid(pool, wallet, didName)
}
```

Some versions of `libindy` worked so well that if the connection handle wasn't
valid, it didn't crash but just returned that it could not fetch the key. Of course,
that helped my job.

## The Plugin Interface

I started with a straightforward key/value interface first. But when we decided to
promote Indy ledger to one of the plugins, which it wasn't before multiplexing,
we brought transaction information to a still simple interface. It has only
`Write` and `Read` functions.

```go
// Mapper is an property getter/setter interface for addon ledger
// implementations.
type Mapper interface {
	Write(tx TxInfo, ID, data string) error

	// Read follows ErrNotExist semantics
	Read(tx TxInfo, ID string) (string, string, error)
}
```

Naturally, the plugin system has an interface `Plugin`, but it's even more
straightforward, and it does not interest us now, but you see it in the UML
picture above.

The following code block shows how transaction information is used to keep
the public interface simple and generic.

```go
func (ao *Indy) Write(tx plugin.TxInfo, ID, data string) error {
	switch tx.TxType {
	case plugin.TxTypeDID:
		return ao.writeDID(tx, ID, data)

	case plugin.TxTypeSchema:
		return ao.writeSchema(tx, ID, data)

	case plugin.TxTypeCredDef:
		return ao.writeCredDef(tx, ID, data)

	}

	return nil
}
```

The following code block is an example of how the Indy ledger plugin implements
*schema* writing transaction with `libindy`:

```go
func (ao *Indy) writeSchema(
	tx plugin.TxInfo,
	ID string,
	data string,
) (err error) {
	defer err2.Return(&err)

	glog.V(1).Infoln("submitter:", tx.SubmitterDID)

	r := <-ledger.BuildSchemaRequest(tx.SubmitterDID, data)
	try.To(r.Err())

	srq := r.Str1()
	r = <-ledger.SignAndSubmitRequest(ao.handle, tx.Wallet, tx.SubmitterDID, srq)
	try.To(r.Err())

	try.To(checkWriteResponse(r.Str1()))
	return nil
}
```

The `readFrom2` is the heart of the cache system of our multiplexer. As you can
see, it's not a fully dynamic multiplexer with *n* data sources. It's made for
just two, which is enough for all our use cases. It also depends on the
actuality that the Indy ledger plugin is the first, and the cache plugin is the
next. Please note that cache can still be whatever type of the plugins, even
`immuDB`.

Thanks to Go's powerful channel system, goroutines, and an essential control
structure for concurrent programming with channels, the `select` -statement, the
algorithm is quite simple, short, and elegant. Faster wins the reading contest,
and if the Indy ledger wins, we can assume that the queried data is only in the
Indy ledger. Like the case where other DID agents use the same Indy ledger, we
are using DLT for interoperability.

And yes, you noticed, we think that the ledger is always the slower one, and if
it's not, it doesn't matter that we tried to write it to cache a second time. No
errors and no one waits for us because writing is async.

```go
func readFrom2(tx plugin.TxInfo, ID string) (id string, val string, err error) {
	defer err2.Annotate("reading cached ledger", &err)

	const (
		indyLedger  = -1
		cacheLedger = -2
	)
	var (
		result    string
		readCount int
	)

	ch1 := asyncRead(indyLedger, tx, ID)
	ch2 := asyncRead(cacheLedger, tx, ID)

loop:
	for {
		select {
		case r1 := <-ch1:
			exist := !try.Is(r1.err, plugin.ErrNotExist)

			readCount++
			glog.V(5).Infof("---- %d. winner -1 (exist=%v) ----",
				readCount, exist)
			result = r1.result

			// Currently first plugin is the Indy ledger, if we are
			// here, we must write data to cache ledger
			if readCount >= 2 && exist {
				glog.V(5).Infoln("--- update cache plugin:", r1.id, r1.result)
				tmpTx := tx
				tx.Update = true
				err := openPlugins[cacheLedger].Write(tmpTx, ID, r1.result)
				if err != nil {
					glog.Errorln("error cache update", err)
				}
			}
			break loop

		case r2 := <-ch2:
			notExist := try.Is(r2.err, plugin.ErrNotExist)

			readCount++
			glog.V(5).Infof("---- %d. winner -2 (notExist=%v, result=%s) ----",
				readCount, notExist, r2.result)
			result = r2.result

			if notExist {
				glog.V(5).Infoln("--- NO CACHE HIT:", ID, readCount)
				continue loop
			}
			break loop
		}
	}
	return ID, result, nil
}
```

I hope you at least tried to read the previous function even when you aren't
familiar with Go because that might be the needed trigger point to start to understand
**why Go is such a powerful tool for distributed programming.** I, who have written
these kinds of algorithms with almost everything which existed before Go, even to
OS, which didn't have threads but only interrupts, has been so happy. Those who
are interested in computer science, please read them
[Hoare's paper of CSP](https://dl.acm.org/doi/10.1145/359576.359585). Of course,
Go inventors aren't the only ones using the paper since 1978.

## Putting All Together

At the beginning of the document, I had a relatively long list of what's not so
good in Indy SDK, and that was even all. I tried to leave out those things
caused because C-API has put together quite fast, I think. The `libindy` is
written in Rust.

But still, the C-API has hints of namespacing, and luckily I have been following
the namespace structure in our Go wrapper's package structure by the book. So,
we have these Go packages:
- `did`
- `wallet`
- `pairwise`
- `crypto`
- `ledger`
- `pool`, this was very important, because it gave as the entry point to
above layer. The layer was using our Go wrapper.

The following picture illustrates the whole system where the ledger connection *pool* is replaced
with our own `pool` package.

{{< figure src="/blog/2022/09/30/ledger-multiplexer/Main.svg" >}}
*Connection Pool's Relation To Ledger Multiplexer*

The code using our Go wrapper looks like **the same as it has been
since the beginning.**

```go
// open real Indy ledger named "iop" and also use Memory Cache
r = <-pool.OpenLedger("FINDY_LEDGER,iop,FINDY_MEM_LEDGER,cache")
try.To(r.Err())

try.To(ledger.WriteSchema(pool, w1, stewardDID, scJSON))

sid, scJSON = try.To2(ledger.ReadSchema(pool, stewardDID, sid))
```

All of this just by following sound software engineering practices like:
- abstraction hiding
- polymorphism
- modular structures

I hope this was helpful. Until the next time, see you!
