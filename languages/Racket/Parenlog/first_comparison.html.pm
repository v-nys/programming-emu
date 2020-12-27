#lang pollen
◊title[metas]{Comparing to the original}
We have now produced enough code to draw a meaningful comparison between our own code and Jay's. To help you get a foothold, here's a table containing bits of code we've already written and their counterparts in Jay's code (which I'm not assuming you've read, but I am accounting for the possibility).
◊table[#:class "counterparts"]{◊tr{◊th{my code}◊th{Jay's code}}◊tr{◊td{◊code{answer-query q th env}}◊td{◊code{model-env-generator/queries th env q}}}◊tr{◊td{◊code{'done}}◊td{◊code{generator-done}}}◊tr{◊td{◊code{deref v env}}◊td{◊code{env-deref env v}}}◊tr{◊td{◊code{extract-vars}}◊td{◊code{variables-in}}}◊tr{◊td{◊code{reyield}}◊td{◊code{reyield}}}◊tr{◊td{◊code{unify}}◊td{◊code{unify}}}◊tr{◊td{◊code{variable?}}◊td{◊code{variable?}}}◊tr{◊td{◊code{unbound-variable? e env}}◊td{◊code{unbound-variable? env e}}}}
Most pairs in this table do contain slight implementation differences, but this should still be enough to give you an accurate idea of what the functions and values on the right are for and how they work.

Jay's version of ◊code{compile-rule}, however, is quite different from what we wrote. Specifically, it's written as a macro, rather than as a plain old function.◊aside{If you need an introduction to macros, ◊a[#:href "http://www.greghendershott.com/fear-of-macros/"]{Greg Hendershott's article} is mandatory reading for the aspiring Racketeer.} This has some implications on how variable renaming is implemented. Here is a comparison between a "skeleton" for a slightly simplified version of Jay's implementation and our existing implementation.

◊code-discussion[
◊listing[#:source "code/my-compile-rule.rkt" #:fn "(my) core.rkt" #:lang "scheme"]
◊listing[#:source "code/compile-rule-jay.rkt"  #:fn "(Jay's) core.rkt" #:highlights '((5 11) (8 46)) #:lang "scheme"]{Jay's ◊code{extract-vars} (not to be confused with our own, which maps to Jay's ◊code{variables-in}) is a normal function, used at compile time. Very vaguely, it also extracts variables, but not from a quoted S-expression. More specifically, it extracts ◊em{Racket} syntax for ◊em{Prolog} variables from S-expressions. So, in something like ◊code{(compile-rule (human X) (mortal X))}, the pattern ◊code{(var ...)} will match the identifier ◊code{X}, because the associated symbol is valid notation for a Prolog variable.}
◊listing[#:fn "(Jay's) core.rkt" #:source "code/compile-rule-jay.rkt" #:highlights '((9 11) (9 45)) #:lang "scheme"]{This clause transforms syntax for ◊em{Racket} variable symbols into quoted symbols, but only if those symbols are not valid representations of Prolog variables. In other words, ◊code{rewrite-se} would replace the syntax objects ◊code{#'human} and ◊code{#'mortal} with syntax ◊code{#''human} and ◊code{#''mortal}, but it would leave ◊code{#'X} intact. So take the expression "sans vars" with a grain of salt. ◊code{rewrite-se} also avoids application of a symbol by introducing a ◊code{list} functor (see tests).}
◊listing[#:fn "(Jay's) core.rkt" #:source "code/compile-rule-jay.rkt" #:highlights '((11 11) (12 50)) #:lang "scheme"]{This does the same as the previously discussed part, but for S-expressions in the body rather than in the head.}
◊listing[#:fn "(Jay's) core.rkt" #:source "code/compile-rule-jay.rkt" #:highlights '((15 11) (16 0)) #:lang "scheme"]{This is important. Variables following the Prolog naming conventions are not quoted by ◊code{rewrite-se}, but are instead bound to unique symbols generated at runtime. If you don't see how this line works, we'll discuss it further down.}
◊listing[#:fn "(Jay's) core.rkt" #:source "code/compile-rule-jay.rkt" #:highlights '((24 16) (29 34)) #:lang "scheme"]{The extra argument ◊code{yield} to ◊code{reyield} is here for historical reasons. You do not need it.}
]



◊exercise{Replace your existing version of ◊code{compile-rule} with this macro alternative and make the auxiliary functions work. You don't need to make the whole thing work (yet), just replace the existing code for ◊code{compile-rule} and fill in the parts that are missing. You'll come back to the runtime approach a bit further down the line, so I recommend creating a separate branch in your version control system at this point.}

You can use the following tests for ◊code{extract-vars} (which we'll call ◊code{extract-stx-vars} to avoid a naming conflict with code from before):
◊listing[#:source "code/extract-stx-vars-tests.rkt" #:fn "core.rkt"]

These tests require ◊code{◊a[#:href "http://docs.racket-lang.org/syntax/macro-testing.html?q=phase1-eval#%28form._%28%28lib._syntax%2Fmacro-testing..rkt%29._phase1-eval%29%29"]{phase1-eval}} because you'll have to define ◊code{extract-stx-vars} so that it's usable at compile time. Otherwise, ◊code{compile-rule} won't be able to make use of it.

◊exercise{If you're not familiar with ◊code{◊a[#:href "http://docs.racket-lang.org/syntax/macro-testing.html?q=phase1-eval#%28form._%28%28lib._syntax%2Fmacro-testing..rkt%29._phase1-eval%29%29"]{phase1-eval}}, see what happens when you omit it and try to explain the effect.}

Here's my implementation, juxtaposed with Jay's:

◊code-discussion[
◊listing[#:source "code/my-extract-stx-vars.rkt" #:fn "core.rkt" #:highlights '((8 14) (8 44))]{I use ◊code{append-map} to keep the intermediate lists of variables flat.}
◊listing[#:source "code/extract-stx-vars-jay.rkt" #:fn "core.rkt" #:highlights '((8 15) (8 18) (14 4) (14 10))]{Using ◊code{map} is also fine, if you flatten the list afterwards.}
]

You can use these tests for ◊code{rewrite-se}:
◊listing[#:source "code/rewrite-se-tests.rkt"]

Again, my implementation and Jay's:
◊code-discussion[
◊listing[#:source "code/my-rewrite-se.rkt" #:fn "core.rkt"]
◊listing[#:source "code/rewrite-se-jay.rkt" #:fn "core.rkt"]
]

At this point you might be wondering if the syntax-based approach is worth it. My own impression is that, for now, it doesn't seem necessary. It does avoid tracking duplicate symbols and replacing all of those with the same renamed variable, but that isn't particularly hard in this case. Regardless, the point is to pick up new ideas, so we'll add the same extensions to both approaches. There's just one thing we still need to do, which is to rewrite ◊code{compile-rule}.

Here's the trick to assigning symbols to variables represented with Prolog syntax as in Jay's version. Because our code still relies on Prolog variables being represented as symbols starting with a capital letter, unbound identifiers have to be bound to such symbols. What's more, every identifier which is unique ◊em{inside that rule} has to be bound to a symbol which cannot occur in any conjunction to which the rule is applied. An easy way to guarantee that is to generate an uninterned symbol, i.e. a symbol which has not yet been created anywhere in the program. The function ◊code{◊a[#:href "http://docs.racket-lang.org/reference/symbols.html#(def._((quote._~23~25kernel)._gensym))"]{gensym}} does just that and it takes an optional prefix, which helps with readability. Here's what I get from the macro expander as the compiled version of one the rules we've used before:
◊listing[#:source "code/compile-rule-expansion.rkt" #:fn "core.rkt"]

Here are some updated tests:
◊listing[#:source "code/compile-rule-tests.rkt" #:fn "core.rkt"]

◊exercise{Now write the ◊code{compile-rule} macro. If you have to look at the original, that's fine, but don't just memorize. Reprocess the notes, understand how the original works and then start from scratch.}

◊popquiz{The identifiers corresponding to Prolog variables have to be bound. We bind them at runtime using ◊code{gensym}. Could we also use ◊code{gensym} for this at compile time? Why?}
◊answer{No. Doing so would associate the identifiers with symbols, but those symbols would be compiled into the rule. Therefore, multiple applications of the same rule could introduce a naming conflict.}

Here is my version.
◊listing[#:source "code/my-compile-rule-stx.rkt" #:fn "core.rkt"]

Next, let's see how well each approach lends itself to interaction with Racket.
