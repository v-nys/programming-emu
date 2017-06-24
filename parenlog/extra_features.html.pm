#lang pollen
◊h2{Extra features}
In this section, we'll add some extra features to our extremely simple Prolog-like language. We'll add these to both versions we've seen so far.
◊h3{Predicate functions in Racket}
Imagine you are writing a Parenlog program and you find yourself writing code for something which is already provided in Racket. For instance, equality of values with ◊code{eq?}. Writing a clause expressing the equality relation seems redundant in that case. It is! Or at least, it will be, after we make a change to our little language. We'll add the possibility of escaping to Racket and using existing predicate functions. Here's an example of a rule which does so, lifted from the Parenlog documentation:

!!! geen geweldig voorbeeld, heb :- nog niet gezien !!!
◊includecode["code/escape-example.rkt"]



So we really just need to take into account two options: our unquoted expression can be a boolean value, or it can be a function call which produces a boolean value.
◊aside{Escaping boolean literals may seem completely useless, but very occasionally it is useful to write a rule with failure built into the body. It's mostly for hacks involving side-effects, but it doesn't cost us a lot of effort.}

◊includecode["code/answer-query-escape.rkt" #:added-lines (stream->list (in-range 6 9))]


Note that "predicate functions" don't ◊em{really} have to express a relation. You can also escape to Racket for side effects, for instance. But you'll want the function with the side effect to return a boolean at the end.
