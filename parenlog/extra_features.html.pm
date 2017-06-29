#lang pollen
◊h2{Extra features}
In this section, we'll add some extra features to our extremely simple Prolog-like language. We'll add these to both versions we've seen so far.
◊h3{Predicate functions}
Imagine you are writing a Parenlog program and you need a predicate which is defined as a function in Racket. For instance, equality of values, with the same semantics as ◊code{eq?}. Writing clauses expressing the equality relation just feels redundant in that case. It is! Or at least, it will be, after we make a change to our little language. We'll add the possibility of escaping to Racket and using existing predicate functions. Here's an example of a rule which does so, lifted from the Parenlog documentation (with slight modifications because we don't have the surface syntax yet).

◊; can I avoid giving explicit ID to the code sample? code notes should always pertain to the immediately preceding includecode, anyway...
◊;includecode["code/escape-example.rkt" #:notes '((2 1) (5 2))]
◊codenote[#:number 1]{Note the use of the backtick symbol ◊code{`} as opposed to the regular single quote ◊code{'}. If you're not familiar, this allows us to break out of the quote.}
◊;codenote[#:number 2]{This is where we break out of the quote. Because of the comma, the last element of the top-level S-expression will contain a function as its first element.}

This can be made to work in the runtime approach and in the compile time approach. 

So we really just need to take into account two options: our unquoted expression can be a boolean value, or it can be a function call which produces a boolean value.
◊aside{Escaping boolean literals may seem completely useless, but very occasionally it is useful to write a rule with failure built into the body. It's mostly for hacks involving side-effects, but it doesn't cost us a lot of effort.}

◊includecode["code/answer-query-escape.rkt" #:added-lines (stream->list (in-range 6 9))]


Note that "predicate functions" don't ◊em{really} have to express a relation. You can also escape to Racket for side effects, for instance. But you'll want the function with the side effect to return a boolean at the end.