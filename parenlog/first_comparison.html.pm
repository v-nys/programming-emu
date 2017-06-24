#lang pollen
◊h2{Comparing to the original}
We have now produced enough code to draw a meaningful comparison between our own code and Jay's. To help you get a foothold, here's a table containing bits of code we've already written and their counterparts in Jay's code.
◊table[#:class "counterparts"]{◊tr{◊th{our code}◊th{Jay's code}}◊tr{◊td{◊code{answer-query q th env}}◊td{◊code{model-env-generator/queries th env q}}}◊tr{◊td{◊code{'done}}◊td{◊code{generator-done}}}◊tr{◊td{◊code{deref v env}}◊td{◊code{env-deref env v}}}◊tr{◊td{◊code{extract-vars}}◊td{◊code{variables-in}}}◊tr{◊td{◊code{reyield}}◊td{◊code{reyield}}}◊tr{◊td{◊code{unify}}◊td{◊code{unify}}}◊tr{◊td{◊code{variable?}}◊td{◊code{variable?}}}◊tr{◊td{◊code{unbound-variable? e env}}◊td{◊code{unbound-variable? env e}}}}
Most pairs in this table do contain slight implementation differences, but this should still be enough to give you an accurate idea of what the functions and values on the right are for and how they work.

Jay's version of ◊code{compile-rule}, however, is quite different from what we wrote. Specifically, it's written as a macro◊aside{If you need an introduction to macros, ◊a[#:href "http://www.greghendershott.com/fear-of-macros/"]{Greg Hendershott's article} is mandatory reading for the aspiring Racketeer.}, rather than as a plain old function. This has some implications on how variable renaming is implemented. Here is the "skeleton" for a slightly simplified version of Jay's implementation, next to our existing implementation. The notes in the margin should give you a high-level view of how Jay's code works. You can toggle them on or off, depending on whether you need them.

◊codecmp[#:f1 "code/my-compile-rule.rkt" #:f2 "code/compile-rule-jay.rkt" #:notes `((4 . ,◊note{Jay's ◊code{extract-vars} (not to be confused with our own, which maps to ◊code{variables-in}) is a normal function, used at compile time. Very vaguely, it also extracts variables, but not from a quoted S-expression. More specifically, it extracts ◊em{Racket} syntax for ◊em{Prolog} variables from unquoted S-expressions. So, in something like ◊code{(compile-rule (human X) (mortal X))}, the pattern ◊code{(var ...)} will match the identifier ◊code{X}, because the associated symbol is valid notation for a Prolog variable.}) (5 . ,◊note{This clause transforms syntax for ◊em{Racket} variable symbols into quoted symbols, but only if those symbols are not valid representations of Prolog variables. In other words, ◊code{rewrite-se} would replace the syntax objects ◊code{#'human} and ◊code{#'mortal} with syntax ◊code{#''human} and ◊code{#''mortal}, but it would leave ◊code{#'X} intact. So take the expression "sans vars" with a grain of salt.}) (6 . ,◊note{This does the same, but for S-expressions in the body rather than in the head.}) (11 . ,◊note{This is important. Variables following the Prolog naming conventions are not quoted by ◊code{rewrite-se}, but are instead bound to unique symbols generated at runtime. If you don't see how this line works, we'll discuss it further down.}) (18 . ,◊note{The extra parameter ◊code{yield} to ◊code{reyield} is here for historical reasons. You do not need it.}))]

Now, your job is to replace your existing version of ◊code{compile-rule} with a macro alternative and to make it work. To do that, you'll need to implement the two missing auxiliary functions yourself. You can use the following tests for ◊code{extract-vars} (which we'll call ◊code{extract-stx-vars} to avoid a naming conflict):

◊includecode["code/extract-stx-vars-tests.rkt" #:lang "racket"]

These tests require ◊code{◊a[#:href "http://docs.racket-lang.org/syntax/macro-testing.html?q=phase1-eval#%28form._%28%28lib._syntax%2Fmacro-testing..rkt%29._phase1-eval%29%29"]{phase1-eval}} because you'll have to define ◊code{extract-stx-vars} so that it's usable at compile time. Otherwise, ◊code{compile-rule} won't be able to make use of it.

Here's my implementation, juxtaposed with Jay's:
◊codecmp[#:f1 "code/my-extract-stx-vars.rkt" #:f2 "code/extract-stx-vars-jay.rkt" #:notes '()]

You can use these tests for ◊code{rewrite-se}:

◊includecode["code/rewrite-se-tests.rkt" #:lang "racket"]

Again, my implementation and Jay's:
◊codecmp[#:f1 "code/my-rewrite-se.rkt" #:f2 "code/rewrite-se-jay.rkt" #:notes '()]

At this point you might be wondering if the syntax-based approach is worth it. If so, I commend your critical thinking. For now, the macro doesn't provide us with any benefits and it is trickier to write. But we'll add more features in the next sections and, at that point, the value of the syntax-based approach should become apparent.

There's one more function you'll need to write first, though: ◊code{compile-rule}. You have the puzzle pieces, now it's time to check whether you can make them fit. If you were able to make sense of note 4 above, you should have a go right now. If the note was too vague, here's a hint: because only non-Prolog identifiers are quoted by ◊code{rewrite-se}, Prolog variables in a compiled rule would be unbound identifiers at runtime. That's not allowed, so those identifiers should be bound. Because the rest of our code still relies on variables being represented as symbols starting with a capital letter, the unbound identifiers have to be bound to such symbols. What's more, every identifier which is unique ◊em{inside that rule} has to be bound to a symbol which cannot occur in any conjunction to which the rule is applied. An easy way to guarantee that is to generate an uninterned symbol, i.e. a symbol which has not yet been encountered anywhere in the program. The function ◊code{◊a[#:href "http://docs.racket-lang.org/reference/symbols.html#(def._((quote._~23~25kernel)._gensym))"]{gensym}} does just that and it takes an optional prefix, which helps with readability. Here's what I get from the macro expander for one the rules we used before:
◊includecode["code/compile-rule-expansion.rkt"]
Try to write the macro. If you have to look at the original, that's fine, but don't just memorize. Reprocess the notes, understand how the original works and then start from scratch.

◊popquiz[#:answer "No. Doing so would replace the identifiers with other ones, but those other identifiers would be used on each application of the rule. Therefore, multiple applications of the same rule introduce a naming conflict."]{The identifiers corresponding to Prolog variables have to be bound. Could we use ◊code{gensym} at compile time?}

Here are some updated tests:
◊includecode["code/compile-rule-tests.rkt" #:lang "racket"]

And here is my version, juxtaposed with the original.
◊codecmp[#:f1 "code/my-compile-rule-stx.rkt" #:f2 "code/compile-rule-jay.rkt"]

Next, let's see how well each approach lends itself to interaction with Racket.