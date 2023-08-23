---
date: 2023-08-23
title: "GopherCon UK 2023"
linkTitle: "GopherCon UK 2023"
description: "Go is gaining more and more popularity among developers. The GopherCon UK conference is a great place to meet fellow Gophers, share and learn about the latest developments in the Go world."
author: Laura Vuorenoja
resources:
- src: "**.{png,jpg}"
  title: "Image #:counter"
---


At the beginning of this year, I set myself a target to speak at a Go programming language conference.
There were several reasons to do so. Go has been one of my favorite tools for years, and I have
longed for an excuse to join a Go event. Giving a speech was perfect for that purpose. Plus, I have
multiple excellent topics to share with the community as we do open-source development in our project,
and I can share our learnings along with our code more freely. Furthermore, I want to do my part
in having more diverse speakers at tech conferences.

As Go released 1.20, it inspired me to experiment with [the new feature to gather coverage data](https://go.dev/testing/coverage/)
for binaries built with Go tooling. I refactored our application testing pipelines and thought this would
be an excellent topic to share with the community. I was lucky to get my speech accepted at
[GopherCon UK](https://www.gophercon.co.uk/) in London, so it was finally time to join my first Go conference.

{{< imgproc cover Fit "925x925" >}}
<em>The Brewery hosted the event. Surprisingly for London, weather was excellent during the whole conference.
</em>
{{< /imgproc >}}

The conference was held in the Brewery, a relaxed event venue in London City. The word on the conference
halls was that the number of event sponsors had decreased from the previous year, and therefore it
had been challenging to organize the event. Luckily the organizers were able to pull things still together.

Apart from the recession, the times are now interesting for Gophers. Many good things are happening
in the Go world. As Cameron Balahan pointed out in his talk "State of the Go Nation,"
Go is more popular than ever. More and more programmers have been adding Go to their tool pack in
recent years, pushing language developers to add new and better features. Moreover, Go is not only
a programming language anymore; it is a whole ecosystem with support for many kinds of tooling.
Newcomers have a way easier job to start with development than, for example, I had seven years ago.
Balahan stated that improving the onboarding of new developers is still one of the Go team's top priorities.

{{< imgproc cameron Fit "925x925" >}}
<em>Cameron Balahan is the product lead for Go.
</em>
{{< /imgproc >}}

## Automated Testing and Test Coverage

The topic of my talk was "Boosting Test Coverage for Microservices." I described in the presentation
how vital automated testing has become for our small team. Automated testing is usually the part you
skip when time is running out, but I tried to convince the audience that this might not be
the best approach – missing tests may bite you back in the end.

{{< imgproc laura Fit "925x925" >}}
<em>On the stage
</em>
{{< /imgproc >}}

Furthermore, I discussed test coverage in the presentation along with how one can measure
test coverage for unit tests and now even - with the Go new tooling – for application tests, i.e.,
tests you run with the compiled application binary instead of unit testing tooling.

The audience received the talk well, and I got many interesting questions. People are struggling
with similar issues when it comes to testing. It is tough to decide which functionality to simulate
in the CI pipeline. Also, we discussed problems when moving on to automated testing with
a legacy code base. The Go's new coverage feature was unknown to most people, and some were eager
to try it out instantly after my session.

{{< imgproc gophers Fit "925x925" >}}
<em>All participants were given adorable Gopher mascots.
</em>
{{< /imgproc >}}

Unfortunately, when you are a speaker at a conference, you cannot concentrate fully on
the conference program because one needs to prepare for the talk. However, I was lucky enough
to join some other sessions as well. There were mainly three themes that I gained valuable insights from.

## Logging and tracing

Generating better logs and traces for applications seems to be a hot topic – and no wonder why.
Services with high loads can generate countless amounts of data, and for the developers to use
the logs for fixing issues efficiently, they must be able to filter and search them.
The ability to debug each request separately is essential.

Jonathan Amsterdam from Google gave an inspiring presentation on [the slog package](https://go.dev/blog/slog),
the newest addition
to the standard library regarding logging. Go's default logging capabilities have always lacked
features. Now, the slog package fixes these shortcomings, with the ability to handle and merge
the data from existing structured logging tools. The presentation revealed how the team refined
the requirements for the new package together with the developer community. Also, it was fascinating
to hear which kind of memory management tricks the team used, as the performance requirements
for logging are pretty demanding.

{{< imgproc konstantin Fit "925x925" >}}
<em>Konstantin Ostrovsky presenting OpenTelemetry usage with Go.
</em>
{{< /imgproc >}}

Another exciting presentation handled also the capability of solving problems quickly, but instead
of logs, the emphasis was on tracing. Konstantin Ostrovsky described how their team is using
[OpenTelemetry](https://opentelemetry.io/docs/instrumentation/go/getting-started/)
to add traceability to incoming requests. Using this approach, they do not need
other logs in their codebase (excluding errors). Tracing uses the concept of spans in the code.
One can utilize the spans to store the request data parameters and call relationships. Different
analysis tools can then visualize this data for a single request. According to Konstantin, these
visualizations help developers to solve problems faster than searching and filtering ordinary logs.
However, in the presentation Q&A, he reminded us that one should use the spans sparingly
for performance reasons.

## Service Weaver

[Service Weaver](https://serviceweaver.dev/) is an open-source project that another Google developer,
Robert Grandl, presented
at the conference. The tool allows one to develop a system as a monolith, as a single binary,
but the underlying framework splits the components into microservices in deployment time.
Therefore, development is easier when you do not have to worry about setting up the full microservices
architecture on your local machine. In addition, the deployment might be more straightforward when
you can work at a higher level.

I participated in [a workshop](https://github.com/serviceweaver/workshops) that allowed participants
to try the Service Weaver hands-on.
The target was to build a full-blown web application with a web UI and a backend service from
which the UI could request data. Other sections described testing the weaver components, routing
from one service to another, and even calling external 3rd party services. The workshop suited me well;
I could learn more than just listening to a presentation. Furthermore, the topic interested me, and
I will dig into it more in the coming days. The workshop organizer promised that Google would invest
in the product also in the future. They are searching for collaborators to get more feedback
to develop the product further.

## UI development with Go

Another topic that got my interest was a discussion group for UI development with Go.
Andrew Williams hosted this discussion and presented a project called [Fyne](https://fyne.io/) that allows
Gophers to write applications with graphical user interfaces for several platforms. UI development
is not my favorite thing to spend my time on; therefore, I am always curious to find better,
more fun ways to implement the mandatory user-clickable parts. Using Go would undoubtedly click
the fun box. So I added another technology experiment to my TODO list.

{{< imgproc patrycja Fit "925x925" >}}
<em>Patrycja hacking the audience with JWTs.
</em>
{{< /imgproc >}}

In addition to these three themes, one session that handled JWT security was also memorable.
Patrycja Wegrzynowicz hacked the audience live with the help of a small sample application
she had built for this purpose. It demonstrated which kind of vulnerabilities our JWT implementations
may have. The presentation was informative and entertaining with the live hacking, and the audience
understood the problems well due to the hands-on examples. The session proved that there is
no well-known battle-tested documentation on handling the JWTs. We have (too) many different
libraries with different qualities, and it is easy to make mistakes with the token generation
and validation. No wonder the audience asked for a book on the subject from Patrycja – we need
better resources for a topic as important as this.

## See you in Florence

Overall the event was well-organized, had a great atmosphere, and was fun to visit.
Meeting fellow Gophers, especially [the Women Who Go](https://www.womenwhogo.org/) members,
was a unique treat. Let's set up our
chapter in Finland soon. (If you are a Finland-based woman who writes Go code, please reach out!)
I also got the chance to spend some free time in London and even share the World Cup final atmosphere
with the English supporters cheering for their team.

{{< imgproc football Fit "925x925" >}}
<em>Public viewing event for the World Cup final.
</em>
{{< /imgproc >}}

Bye til the next event; I hope we meet in [Florence](https://golab.io/) in November! In the meantime,
check out videos of the GopherCon UK 2023 sessions once they are published - I will do the same for
the ones I missed live!
