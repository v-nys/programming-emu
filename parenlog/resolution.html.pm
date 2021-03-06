#lang pollen
◊h2{Resolution}
◊h3{A mechanism for automated reasoning}
◊glossaryterm[#:canonical "resolution" #:explanation ◊explanation{a rule of inference which is used for automatic theorem proving}]{Resolution} is our second crucial mechanism and it's what enables us to do reasoning in multiple directions. We'll just dive right in with our running example again:
◊includecode["code/theory.pl" #:lang "prolog"]

Let's say we want to prove that Athena likes math. If we unify the first predicate (the ◊glossaryterm[#:explanation ◊explanation{in the context of a ◊glossaryref{rule}, the predicate which precedes the implication symbol}]{head}) of the rule ◊code{likes(X,Y) :- part(Z,Y), likes(X,Z)} with ◊code{likes(athena,math)}, we learn that this can be done by proving that there is an unknown ◊math{Z} which is part of math and which is liked by Athena. In the general case, proving that there is such a ◊math{Z} might involve more deductive reasoning, but here we just have the facts ◊code{part(logic,math)} and ◊code{likes(athena,logic)}, so proving the whole thing just amounts to locating those facts in our knowledge base.

More generally, to answer a query, we need to find a rule (or fact) whose head (or entirety, respectively) unifies with the first ◊glossaryterm[#:explanation ◊explanation{in logic programming, a predicate in a ◊glossaryref{query}}]{conjunct} in the query, apply unification and then prove the body of the unified rule (in addition to the rest of the ◊glossaryterm[#:explanation ◊explanation{in logic programming, an ordered sequence of ◊glossaryref[#:canonical "conjunct"]{conjuncts}}]{conjunction}). And we just need to repeat that process until we reach an empty query, which we'll represent as ◊code{□}. If we can do that, the bindings of the variables in the query will represent an answer. For instance, if the initial query is ◊code{likes(athena,X)} and ◊code{X} ends up bound to ◊code{battle}, ◊code{#hasheq((X . battle))} is an answer. But ◊code{X} could also end up bound to ◊code{logic}, so ◊code{#hasheq((X . logic))} is also an answer. And it could end up bound to ◊code{math}... You get the idea.

Generating ◊em{all} answers is done through backtracking: forgetting the entire deduction that was applied to a goal and then applying a different one. It's easier than it sounds: we just replace the last step in our reasoning with a different step if that's possible. If that doesn't give us a new answer, we replace the next-to-last step, and so on, until our search space is exhausted. The following figure illustrates this:◊todo{Improve diagram. Tree is too wide.}

◊img[#:src "figures/resolution_without_renaming.svg"]

This figure is a representation of the computations that Prolog (or Parenlog) performs. It starts at the root of the tree and expands the tree in a ◊glossaryterm[#:explanation ◊explanation{a strategy for traversing trees in which the leftmost unexplored node is always explored next}]{depth-first} manner. It does so by always picking the first rule which applies to the first predicate in the query. When deepening the tree is no longer possible, the language backtracks. That is, it picks the second rule which applies to the first predicate in the most recent query. Again, it will expand the search tree as far as it can (and may use a third applicable rule later on, depending on the program).

The mechanism is simple, but versatile. There's a minor pitfall to keep in mind, though. Notice how the diagram has ◊code{likes(athena,Something)} in the root, rather than ◊code{likes(athena,X)}. If we applied the steps outlined above and nothing more, some of the computations would not be equivalent:

◊img[#:src "figures/resolution_without_renaming_with_clash.svg"]

What gives? A scoping issue, that's what. Our query is ◊code{likes(athena,X)} and the head of the third applicable rule is ◊code{likes(X,Y)}, which leads to the unification of ◊code{likes(athena,X)} and ◊code{likes(X,Y)}. Those two predicates unify, but the result is ◊code{{X=athena, Y=athena}}. In other words, variables are incorrectly aliased. But there's an easy fix: if we make sure that none of the variables in any rule we apply also occur in a query at any point, there will never be any incorrect aliasing.

We can write code to rename all variables in a rule (represented as an S-expression list) right now, so that they are ◊glossaryterm[#:explanation ◊explanation{in logic programming, indicates that a variable does not currently occur in any existing construct}]{fresh}. I suggest you give it a try. If you're lost, here's how I did it:
◊includecode["code/rename-variables.rkt" #:lang "racket"]

Jay McCarthy's approach is very different, so this is definitely not the only way to go about it. I'll contrast the two approaches when enough of the bigger picture has emerged.

To implement resolution with backtracking, we need a mechanism which allows us to produce an answer to the first predicate in a query, hold off and later produce more answers when backtracking. Racket has a very suitable mechanism for this: ◊a[#:href "http://docs.racket-lang.org/reference/Generators.html"]{generators}. You can think of a generator as similar to a function, in that it can be called and produces a value, but different in that it has state. If you call a generator a second time, it'll pick up from where it left off and produce a second (possibly different) value. In Racket, you can keep calling any generator, but some will reach a point where they just keep producing ◊a[#:href "http://docs.racket-lang.org/reference/void.html"]{#<void>}.

Here's an example. Note the syntactic resemblance to a function written out with ◊code{lambda}:
◊includecode["code/generator-example.rkt" #:lang "racket"]

What you'll see is this:
◊output{The first value is 1
The second value is 2
The next value is 3
The next value is 4
The next value is 5
The next value is 6}

The explanation for this output is simple. Calling the generator the first time causes the first ◊code{yield} call to be evaluated, at which point the generator is suspended. The result of the first call is the argument to the first ◊code{yield}, i.e. ◊code{1}. Calling it a second time causes the second ◊code{yield} to be evaluated. Then, ◊code{for} iterates over a ◊a[#:href "http://docs.racket-lang.org/reference/sequences.html"]{sequence} derived from the generator through ◊code{in-producer}. This generator doesn't loop forever, so at some point there will no longer be any calls to ◊code{yield}. At that point, calls to the generator produce ◊code{#<void>}. We don't want that as a result, so we give provide ◊code{(void)} as a second argument to ◊code{in-producer}, which means that the sequence (and the loop) will end as soon as that specific value is produced. Note that the body of the loop will not be evaluated with this final value.

Those are all the concepts we need write an implementation of the resolution mechanism used by Prolog. But let's establish a conceptual way to go about this, too. The key idea is that rules are generators: the application of a rule can lead to the production of (potentially intermediate) answers if an empty query is eventually reached. To produce an answer, we need to unify the head of the rule with the first predicate in the current query and, if that works, produce an answer to the query represented by the body of the rule.

But finding ◊em{that} answer may require us to apply more rules. So we have a pair of ◊glossaryterm[#:canonical "mutual recursion" #:explanation ◊explanation{situation in which a function A is defined in terms of a function B and vice versa}]{mutually recursive} computations on our hands. The following diagram illustrates this:

◊img[#:src "figures/resolution_flow.svg"]

Here's how I implemented this:
◊includecode["code/resolution.rkt" #:lang "racket"]

You would use this as follows:

◊includecode["code/naive-resolution-example.rkt" #:lang "racket"]

There's a wrinkle, though. This test would fail. The answer you will get --- in my case ◊code{(#hasheq((X . battle)) #hasheq((X . logic)) #hasheq((Y4204 . math) (X4203 . athena) (Z4205 . logic) (X . Y4204)))} --- is technically correct, but it is not as gracefully minimal as ◊code{expected}. It's technically correct because, in the third hash map, if we follow the trail of breadcrumbs, we find out that ◊code{X} is associated with ◊code{math}. But it has kept track of intermediate variable assignments that we do not care about.

We could solve this by writing a function which "follows the trail", as long as there is no risk of a ◊glossaryterm[#:explanation ◊explanation{situation in which a variable A is bound to a variable B and vice versa}]{reference cycle}. Because we always rename clauses before we apply them, there is no such risk: no variable on the right-hand side of an initial unification occurs on the left-hand side (or vice versa) and unification only moves terms from one side of an equality to another if the term on the left-hand side is not a variable and the element on the right-hand side is.

So your next task is to write a function ◊code{restrict-vars}, which takes an environment and a top-level query and follows the trail of breadcrumbs, retaining only the bindings for the variables which occur in the top-level query.

If all goes well, the following test should pass:
◊includecode["code/dereferenced-resolution-example.rkt" #:lang "racket"]

Here's my version:
◊includecode["code/restrict.rkt" #:lang "racket"]