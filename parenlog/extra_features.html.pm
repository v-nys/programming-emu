#lang pollen
◊h2{Extra features}
In this section, we'll add some extra features to our extremely simple Prolog-like language. We'll add these to both versions we've seen so far.
◊h3{Predicate functions}
Imagine you are writing a Parenlog program and you need a predicate which is defined as a function in Racket. For instance, equality of values, with the same semantics as ◊code{eq?}. Writing clauses expressing the equality relation just feels redundant in that case. It is! Or at least, it will be, after we make a change to our little language. We'll add the possibility of escaping to Racket and using existing predicate functions. Here's an example of a rule which does so, lifted from the Parenlog documentation (with slight modifications because we don't have the surface syntax yet).

◊includecode["code/escape-example.rkt" #:notelinenumbers '(2 5)]
◊codenote{Note the use of the backtick symbol ◊code{`} as opposed to the regular single quote ◊code{'}. If you're not familiar, this is called a ◊gt{quasiquote} and allows us to break out of the quote.}
◊codenote{This is where we break out of the quote. Because of the comma, the last element of the top-level S-expression will contain a function as its first element.}

This can be made to work in the runtime approach and in the compile time approach. You can escape to a Racket predicate function call wherever you would write a predicate inside the body of a rule. You can also escape to a boolean literal.

Add the following tests to your test suite and then try making the modifications. The most educational thing to do would be to make them to both versions. If you need a good place to start, try ◊code{answer-query}.

◊includecode["code/escape-test-suite.rkt"]

... (the modifications)

◊todo{Extract modified, relevant code from commits 3151d1956 + 7ddadab6a88ef18 and from Jay's code}

Just to cap off the part on this feature: "predicate functions" don't ◊em{really} have to express a truth value. You can also escape to Racket for side effects, for instance. But you'll want the function with the side effect to return a boolean at the end.

◊h3{Limiting the number of answers}
Our calls to ◊code{answer-query} so far have given us a generator which produces every correct answer to some initial query. Sometimes we don't need every answer, though. For instance, suppose we just want to know whether Athena even has any real friends. The call ◊code{answer-query '((realfriends _ athena)) theory #hasheq} gives us a generator which produces ◊code{ares}, ◊code{eratosthenes} and ◊code{pythagoras}, when just ◊code{ares} is good enough. For those types of situations, there's a little feature in Parenlog: the ◊code{#:limit} keyword. This is an optional parameter for ◊code{answer-query}. It restricts the number of answers produced to some positive integer number.
◊aside{In Prolog, there's a similar, but not identical mechanism called the ◊a[#:href "http://www.learnprolognow.org/lpnpage.php?pagetype=html&pageid=lpn-htmlse43"]a{cut}.}

This is a pretty straightforward change, so give it a whirl. The following test should have you covered:

◊includecode["code/limit-answers-test.rkt"]