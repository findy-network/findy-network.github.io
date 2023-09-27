---
date: 2023-08-26
title: "How To Write Readable & Performant Go Code"
linkTitle: "Performant Go Code"
description: "The Go programming language has an excellent [concurrency 
model](https://findy-network.github.io/blog/2023/06/22/beautiful-state-machines-fsm-part-ii/)
that offers great potential to utilize the power of multiple CPU cores. For the
overall software performance, we need to understand the basics of the single
core of the modern CPU. The common knowledge says that you shouldn't think
performance before other [software architecture quality
attributes](https://en.wikipedia.org/wiki/List_of_system_quality_attributes).
You shouldn't sacrifice, for instance, readability or maintainability for the
sake of the performance. I complain that you can write more readable code
when you know how compilers and underlaying HW work. In this post I'll go thru
some basics of the Go's tooling and triks that you should know if you want to
achive decent execution speed of your (Go) software."
author: Harri Lainio
resources:
- src: "**.{png,jpg}**"
  title: "Image #:counter"
---

Since jumping the OSS wagon I have started to learn new things about software
development or get proof for certain ways of doing thins. Two of my favorite
ones are **readability** and **modifiability**. The later is an old friend 
form SW architecture's quality attributes, which is natural, but it is not well aligned with
the current practises and tools -- everything is text-centric. Software
architecture is something that must be expressed wide variety of notations which
most are graphical their nature. So, it's easy to forget software quality
attributes during the programming when we are using tools only manage sequential
text, i.e. code.

However, since my studies of SW architecture's quality attributes I have
understood that modifiability is a lot of more than modularity, reusability,
architecture styles like pipe&filter, 
etc. For instance, now we understand the importance of
[TTD](https://en.wikipedia.org/wiki/Test-driven_development), [continuous
deployment](TODO), [DevOps](TODO), etc. Any of mentioned practises doesn't work only on one
engineering domain. The best results are achieved **cross engineering domain
practise**. 

# Perfect Code?

I suppose all of us programmers has heard of premature optimization:

> *The real problem is that programmers have spent far too much time worrying
> about efficiency in the wrong places and at the wrong times; premature
> optimization is the root of all evil (or at least most of it) in programming.*

That's the full quote from *The Art of Computer Programming, Donald Knuth*. Like
so many wisdoms they are child of their own time, and more importantly separated
from their context, which, by the way, time and its current tools are part of.
For example, usually the infamous quote is: 

> *premature optimization is the root of all evil in programming.*

if you are writing assembler don't optimize everything first
iteration. However, if you learn to **think performance as your second nature
it'll not ruin other quality attributes of your code, but opposite**.

## Performance Rules

We want to maximise our code's readability. One of the Go code's problems is
that it over uses if statement, which prevents you notice the important ones,
i.e., those that are decision points of the algorithm.

Go standard library includes quite few of the following code blocks:

```go
if p == nil {
    panic("input argument p cannot be nil")
}
...
err := w.Close()
if err != nil {
    log.Fatal(err)
}
```

It's easy to see that together with Go's if-based error checking these two hides
the actual happy path and makes difficult to follow the algorithm and skim the
code.

### Function inlining

Let's make a famous helper function to show how function inlining can help the
readability without sacrificing the performance.

```go
func assert(term bool, msg string) {
    if !term {
        panic(msg)
    }
    ...

func doSomething(p any) {\
    assert(p!=nil, "interface value p cannot be nil")
    ...
```




## Memory Allocations

Similarly as function calls the memory allocations from heap are expensive. So,
it's good practise to prevent unnecessary allocations even the programming
language currently used is garbage collected.

Go's benchmarking tool gives you extra information about allocations when
needed. Just add the following argument.


## Learnings

1. Closure, reference to your variables, how escaping?
1. Pointer to something, this case to interface, `error`
1. No side effects, just values in and values out.
    - can be expensive in some cases, but **surprisings benefits**


### How We Can Get More information (cmdline tools of Go for help)

In this paper we concentrate one of the all time high methods of performance
which one of the easiest ways to make your app fast, and it’s function
inlining. Others are memory allocation which might be even more important. And
some others are how memory is used because of cache lines.
