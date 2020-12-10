#lang pollen
◊title[metas]{Extra features}
In this section, we'll add some extra features to our extremely simple Prolog-like language. We'll add these to both versions we've seen so far.
◊h3{Predicate functions}
Imagine you are writing a Parenlog program and you need a predicate which is defined as a function in Racket. For instance, equality of values, with the same semantics as ◊code{eq?}. Writing clauses expressing the equality relation just feels redundant in that case. It is! Or at least, it will be, after we make a change to our little language. We'll add the possibility of escaping to Racket and using existing predicate functions. Here's an example of a rule which does so, lifted from the Parenlog documentation (with slight modifications because we don't have the surface syntax yet).

◊listing[#:source "code/escape-example.rkt"]

This can be made to work regardless of whether you compile rules using a regular function or a syntax transformation. The general idea is that you can escape to a Racket predicate function call wherever you would write a predicate inside the body of a rule. You can also escape to a boolean literal.

You can use the following tests if you extend the runtime approach:
◊listing[#:source "code/escape-test-suite.rkt"]



And here are corresponding tests for the compile-time approach:
◊todo{Make modifications so these tests apply to the compile-time approach!}
◊listing[#:source "code/escape-test-suite-syntax.rkt"]

◊exercise{Add the extension to both versions of your code. If you need a good place to start, try ◊code{answer-query}.}

◊todo{Extract modified, relevant code from own two approaches and from Jay's code}

Just to cap off the part on this feature: "predicate functions" don't ◊em{really} have to express a truth value. You can also escape to Racket for side effects, for instance. But you'll want the function with the side effect to return a boolean at the end.

◊h3{Limiting the number of answers}
Our calls to ◊code{answer-query} so far have given us a generator which produces every correct answer to some initial query. Sometimes we don't need every answer, though. For instance, suppose we just want to know whether Athena even has any real friends. The call ◊code{answer-query '((realfriends X athena)) theory #hasheq()} gives us a generator which produces ◊code{ares}, ◊code{eratosthenes} and ◊code{pythagoras}, when just ◊code{ares} is good enough. For those types of situations, there's a little feature in Parenlog: the ◊code{#:limit} keyword. This is an optional parameter for ◊code{answer-query}. It restricts the number of answers produced to some positive integer number.
◊aside{In Prolog, there's a similar mechanism called the ◊a[#:href "http://www.learnprolognow.org/lpnpage.php?pagetype=html&pageid=lpn-htmlse43"]{cut}. It's a bit more versatile, but it's also a little more complicated.}

This is a pretty straightforward change, so give it a whirl. The following test should have you covered:

◊listing[#:source "code/limit-answers-test.rkt"]