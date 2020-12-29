#lang pollen
◊title[metas]{Extra features}
In this section, we'll add some extra features to our extremely simple Prolog-like language. We'll add these to both versions we've seen so far.
◊h3{Predicate functions}
Imagine you are writing a Parenlog program and you need a predicate which is defined as a function in Racket. For instance, equality of values, with the same semantics as ◊code{eq?}. Writing clauses expressing the equality relation just feels redundant in that case. It is! Why rewrite functionality in our guest language when it's already available in the host language? We'll add the possibility of escaping to Racket and using existing predicate functions. Here's an example of a rule which does so, lifted from the Parenlog documentation (with slight modifications because we don't have the surface syntax yet).
◊aside{Adding "escape to Racket" functionality is quite common in Racket-based languages. This way, we can usually implement workarounds for scenarios that are out of scope of the core DSL.}

◊listing[#:source "code/escape-example.rkt" #:fn "core.rkt" #:highlights '((5 4) (5 25))]{Instead of a symbol, our predicate contains a function. We use unquoting to indicate this, because we need to distinguish symbols from identifiers.}

This can be made to work regardless of whether you compile rules using a regular function or a syntax transformation. The general idea is that you can escape to a Racket predicate function call wherever you would write a predicate inside the body of a rule. You can also escape to a boolean literal. This is somewhat similar to most Prolog implementations' "builtins", though there are important limitations. Importantly, this approach cannot bind variables. But, to clarify: "predicate functions" are not limited to deciding some truth value. You may simply want to invoke one or several side-effects, which is possible, as long as your function returns ◊code{#t} or ◊code{#f} at the end (in the latter case, this will enforce backtracking after the side-effect).

You can use the following tests if you extend the runtime approach (because of the minor differences in syntax):
◊code-discussion[
◊listing[#:source "code/escape-test-suite.rkt" #:fn "core.rkt" #:highlights '((34 15) (34 33))]{We can use this to avoid designating someone as their own friend.}
◊listing[#:source "code/escape-test-suite.rkt" #:fn "core.rkt" #:highlights '((48 28) (48 58) (57 31) (57 64))]{We can use boolean literals as well. Prolog implementations generally have special ◊code{true} and ◊code{fail} atoms. We'll simulate them this way. There is no real need to unquote here because boolean literals do not look like identifiers.}]

And here are corresponding tests for the compile-time approach:
◊listing[#:source "code/escape-test-suite-syntax.rkt"]

◊exercise{Add the extension to both versions of your code. Here's a hint: we don't traverse the rule base and try to unify a conjunct with the head of some rule in this case. So find the code where that happens and use that as a starting point. You will probably also need to make a few modifications in other places, because so far we have assumed that rules are represented as lists of lists of symbols, which is no longer the case if you add in functions.}

◊h4{For the runtime approach}
Here are the changes I made.
◊listing[ #:source "code/runtime-predicate-function-changes.rkt" #:fn "core.rkt"]

◊h4{For the syntax-based approach}
Here are the changes I made.
◊listing[ #:source "code/syntax-predicate-function-changes.rkt" #:fn "core.rkt"]

◊h3{Limiting the number of answers}
Our calls to ◊code{answer-query} so far have given us a generator which produces every correct answer to some initial query. Sometimes we don't need every answer, though. For instance, suppose we just want to know whether Athena even has any real friends. The call ◊code{answer-query '((realfriends X athena)) theory #hasheq()} gives us a generator which produces ◊code{ares}, ◊code{eratosthenes} and ◊code{pythagoras}, when just ◊code{ares} is good enough. For those types of situations, there's a little feature in Parenlog: the ◊code{#:limit} keyword. This is an optional parameter for ◊code{answer-query}. It restricts the number of answers produced to some positive integer number.
◊aside{In Prolog, there's a similar mechanism called the ◊a[#:href "http://www.learnprolognow.org/lpnpage.php?pagetype=html&pageid=lpn-htmlse43"]{cut}. It's more versatile because you can put it in rules and not just in top-level queries, but it's also more complicated. Feel free to try implementing it when you've finished the project!}

This is a pretty straightforward change, so give it a whirl. The following test should have you covered:

◊listing[#:source "code/limit-answers-test.rkt"]

Here's one way to do it: just wrap the generator, reyield every generated value while keeping count (and deal with ◊code{'done}). You can use the exact same change for the syntax-based approach:

◊listing[#:source "code/resolution-limited.rkt" #:lang "scheme" #:fn "core.rkt"]