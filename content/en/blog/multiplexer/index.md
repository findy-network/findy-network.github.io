---
date: 2022-09-27
title: "Ledger Multiplexer"
linkTitle: "Ledger Multiplexer"
description: "Implementing ledger multiplexer in Go for libindy."
author: Harri Lainio
resources:
- src: "**.{png,jpg}**"
  title: "Image #:counter"
---

In this technical blog post I'll explain how I implemented a plugin system to
our Indy SDK Go wrapper and then extended it to work as real multiplexer. The
plugin system allows us to use whatever key/value-based storage system instead
of the normal Indy ledger. And then multiplexing extended the functionality to
use multiple data sources simultaneously and asynchronously. For instance, we
can add memory cache to help Indy ledger which has been proving to make huge
difference in multi-tenant agency that can serve thousands of different wallet
users same time.

## Reduce Setup Complexity

Indy ledger has been bugging me since we met each others:

- Why it was written in Python when everybody must know that it would be
  performance critical part of the system?
- Why it used ZeroMQ when so simple TCP/IP communication was used? (Was it
  because of Python?) Anyway, every dependency is a dependency to handle.
- Why it didn't offer development run mode since beginning? For instance, a
  pseudo node which would just offer local development and test environment?
- Why it didn't offer clear own separated API? You had to build each transaction 
  with three separated functions that weren't general but entity specific like
  `ledger.BuildGetCredDefRequest()`.
- Why the transaction model was so unclear and 'hided' into the rest of the
  Indy SDK functions. (See previous one.)
- Why Indy nodes could not idle? When no one was connected to it, it still used shit
  load of CPU time per node and there was four (4) node minimum in local setup as
  well.

For the record, it's so easy to write the previous list when someone has done
everything ready. So why bother? To learn and share that learning, if me or our
team will ever build anything where a distributed ledger would be used for the
scratch my points are:

- Give clear and separated API.
- Implement some out of the box mocking for development, e.g. use some memory
  database, etc.
- Offer a way setup a production system without the real consensus protocol and
  DLT but to offer a single database and tools to migrate that to real DLT when
  the time comes.

## Support TDD


```go
func (ao *Indy) WriteSchema(
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
`indy_key_for_did()` `indy_get_endpoint_for_did`

```go
// Key returns DIDs key from wallet. Indy's internal version tries to get the
// key from the ledger if it cannot get from wallet. NOTE! Because we have our
// Ledger Plugin system at the top of the wrappers we cannot guarantee that
// ledger fetch will work. Make sure that the key is stored to the wallet.
func Key(pool, wallet int, didName string) ctx.Channel {
	return c2go.KeyForDid(pool, wallet, didName)
}
```

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

