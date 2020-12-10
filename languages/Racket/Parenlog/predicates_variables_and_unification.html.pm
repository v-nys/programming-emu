#lang pollen
◊title[metas]{Variables, predicates and unification}
Our first step will be to implement a crucial mechanism known as ◊glossaryterm[#:explanation "mechanism by which a unifier for two terms is found"]{unification}, which operates on terms. But to understand and implement unification, we need to understand logic variables.
◊h3{Logic variables vs. Racket variables}
Variables in a logic programming language are different from variables in Racket (and most languages). They are more like unknowns in mathematics: they represent one, immutable value, but that value may not yet be known where the variable is used. Consider again our theory from before: ◊listing[#:source"code/theory.pl"]

In Prolog, we could write the query ◊code{likes(X,math)} and learn that the query is successful for ◊code{X} equal to ◊code{eratosthenes}, but we could not write a query like ◊code{likes(X,math), X = ares}. Or rather, we could, but Prolog will not yield a single answer. Once a value has been assigned to a variable, it cannot be changed until after Prolog has produced an answer or has failed to do so. When an answer is produced or a computation reaches a dead end, backtracking occurs. That is, the most recently applied rule or fact is replaced with the first untried alternative.

With that in mind, we can ◊glossaryterm[#:explanation "to associate a variable with the value"]{bind} logic variables using an immutable hash table. The keys will be variable symbols and the values will be terms. This mapping from variables to their assigned values is typically called a ◊glossaryterm[#:explanation "a mapping from symbols to values, used to track the bindings of variables"]{binding environment} or just "environment" for short.◊aside{In logic programming circles, it's common to talk about a substitution, which is a somewhat more general concept, but the focus here is on implementing a working version of Parenlog.} The impossibility of reassigning variables is easy to implement: only allow updating the binding environment if the variable is unbound, or if the assignment is compatible with previous assignments to that variable. So, ◊code{=} can do assignment only if the left-hand side is unbound? No, because ◊code{=} is not assignment, but explicit ◊glossaryref{unification}. What's the difference? Here's an example: ◊code{chews(X,bone) = chews(misty,Y).} will succeed in Prolog and will bind ◊code{X} to ◊code{misty} and ◊code{Y} to ◊code{bone}. More generally, unification finds a ◊glossaryterm[#:explanation "a substitution which makes two terms syntactically equal"]{unifier}, i.e. an assignment of variables which causes two terms to become syntactically equal. And we are really only interested in the ◊glossaryterm[#:explanation "a unifier for two terms such that all other unifiers for these terms can be obtained by composing another unifier with it"]{most general unifier}, which is a assignment of variables which does not instantiate any variables further than required. For instance, ◊code{greek(X)} and ◊code{greek(Y)} can be made equal by binding ◊code{X} to ◊code{Y}. They can also be made equal by binding ◊code{X} to ◊code{ares} and ◊code{Y} to ◊code{ares}, but that's more specific than what is required, so that doesn't happen when we try to unify ◊code{greek(X)} and ◊code{greek(Y)}.
◊aside{Unification is essentially bidirectional pattern matching. Or, according to logic programmers, pattern matching is one-way unification.}

Unification of two S-expression lists is a good way to get our feet wet, as it can be written without resorting to any auxiliary functions and is, in turn, used in a lot of the rest of the code. The standard algorithm for finding a most general unifier is known as the ◊glossaryterm[#:explanation "a fast algorithm for unification"]{Martelli-Montanari algorithm} and, fortunately, it makes a lot of sense. An adequate explanation is provided on ◊a[#:href "https://en.wikipedia.org/wiki/Unification_(computer_science)#A_unification_algorithm"]{Wikipedia} so I won't come up with my own formulation. However, the version on Wikipedia includes the "occurs check" as the last step. You can leave that one out. Historically, it's pretty much always been omitted from Prolog implementations because it was too expensive and not very useful in practice.

Here's a suggested function signature: ◊code{S-expression -> S-expression -> environment -> (or/c environment #f)}. So: take two S-expressions and an existing environment as input and update the environment if unification is possible or represent failure to unify with ◊code{#f}.

And here are some tests for a function with said signature. I would advise you to read these first, as they can clarify some of the expected behavior. There's one case in which shared variables occur on the left-hand side and on the right-hand side. That's something we'll typically avoid, but it still makes for a useful test case.
◊aside{If you're not familiar with the ◊code{(module+ test ...)} approach to testing in Racket, have a look ◊a[#:href "https://docs.racket-lang.org/guide/Module_Syntax.html"]{here}.}
◊listing[#:source "code/unify-tests.rkt" #:fn "core.rkt"]

Try to come up with code that gets those tests to pass. If you get stuck, have a look at the code below, focus on understanding and remembering the general structure, then try again from memory.

Here's my code, juxtaposed with Jay's. I should point out that this was written after I had studied his code, so both snippets look very similar.

◊code-discussion{
◊listing[#:source "code/unify.rkt" #:fn "core.rkt"]
◊listing[#:source "code/unify-jay.rkt" #:fn "core.rkt"]
}

Conceptually, both do the same things, but there are a few differences. ◊exercise{Name the differences and see whether either snippet contains any improvements over your own code.} ◊exercise{Modify your own code to incorporate any improvements that you see.} ◊exercise{Notify me if you notice any bugs in my code 😁}

Our next stop is the mechanism which allows Prolog to reason in multiple directions: resolution!
