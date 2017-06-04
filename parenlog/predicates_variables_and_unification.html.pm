#lang pollen
◊h2{Variables, predicates and unification}
Our first stem will be to implement a crucial mechanism known as ◊glossaryterm[#:explanation ◊explanation{mechanism by which a ◊glossaryref{unifier} for two ◊glossaryref[#:canonical "term"]{terms} is found}]{unification}, which operates on terms. But to understand and implement unification, we need to understand logic variables.
◊h3{Logic variables vs. Racket variables}
Variables in a logic programming language are different from variables in Racket (and most languages). They are more like unknowns in mathematics: they represent one, immutable value, but that value may not yet be known where the variable is used. Consider again our theory from before: ◊includecode["code/theory.pl" #:lang "prolog"]

In Prolog, we could write the query ◊code{likes(X,math)} and learn that the query is successful for ◊code{X} equal to ◊code{eratosthenes}, but we could not write a query like ◊code{likes(X,math), X = ares}. Or rather, we could, but Prolog will not yield a single answer. Once a value has been assigned to a variable, it cannot be changed until Prolog backtracks. At that point, it will be as if said variable was never assigned in the first place.

With that in mind, we can connect logic variables to their values. This is done using an immutable hash table, with the keys being variable symbols and the values being, well, values. This mapping from variables to their assigned values is typically called a ◊glossaryterm[#:explanation ◊explanation{a mapping from symbols to values, used to track the bindings of variables}]{binding environment} or just "environment" for short◊aside{In logic programming circles, it's more common to talk about a substitution, which is a somewhat more general concept, but the focus here is on implementing a working version of Parenlog.}. The impossibility of reassigning variables is easy to implement: only allow updating the binding environment if the variable is unbound, or if the assignment is compatible with previous assignments to that variable.

So, ◊code{=} can do assignment only if the left-hand side is unbound? No, because ◊code{=} is not assignment, but unification. What's the difference? Here's an example: ◊code{writes(X,racket) = writes(vincent,Y).} will succeed in Prolog and will bind ◊code{X} to ◊code{vincent} and ◊code{Y} to ◊code{racket}. More generally, unification finds a ◊glossaryterm[#:explanation ◊explanation{a ◊glossaryref{substitution} which makes two ◊glossaryref[#:canonical "term"]{terms} syntactically equal}]{unifier}, i.e. an assignment of variables which causes two terms to become syntactically equal. And we are really only interested in the ◊glossaryterm[#:explanation ◊explanation{a unifier for two ◊glossaryref[#:canonical "term"]{terms} such that all other unifiers for these terms can be obtained by composing another unifier with it}]{most general unifier}, which is a assignment of variables which does not instantiate any variables further than required. For instance, ◊code{greek(X)} and ◊code{greek(Y)} can be made equal by binding ◊code{X} to ◊code{Y}. They can also be made equal by binding ◊code{X} to ◊code{ares} and ◊code{Y} to ◊code{ares}, but that's more specific than what is required.

Unification of two S-expression lists is a good way to get our feet wet, as it can be written without resorting to any auxiliary functions and is, in turn, used in a lot of the rest of the code. The standard algorithm for finding a most general unifier is known as the ◊glossaryterm[#:explanation ◊explanation{a fast algorithm for ◊glossaryref{unification}}]{Martelli-Montanari algorithm} and, fortunately, it makes a lot of sense. A sufficient explanation is provided on ◊a[#:href "https://en.wikipedia.org/wiki/Unification_(computer_science)#A_unification_algorithm"]{Wikipedia} so I won't come up with my own formulation. However, the version on Wikipedia includes the "occurs check" as the last step. Don't worry about that one. Historically, it's pretty much always been omitted from Prolog implementations because it was too expensive.

Here's a suggested function signature:
◊highlight['racket]{;; S-expression -> S-expression -> environment -> (or/c environment #f)}

Here are some ◊note{tests} for a function with said signature. I would advise you to read these first, as they can clarify some of the expected behavior. There's one case in which shared variables occur on the left-hand side and on the right-hand side. That's something we'll typically avoid, but it still makes for a useful test case.
◊includecode["code/unify-tests.rkt" #:lang "racket"]

Try to come up with code that gets those tests to pass. If you get stuck, have a look at professor McCarthy's code below or my own, then try again from memory.

Here's my code:
◊includecode["code/unify.rkt" #:lang "racket"]

Finally, here's Jay McCarthy's code.
◊includecode["code/unify-jay.rkt" #:lang "racket"]

Next stop: resolution!