#lang pollen
◊h2{Variables, predicates and unification}
◊h3{Logic variables vs. Racket variables}
Variables in a logic programming language are different from variables in Racket (and most languages). They are more like unknowns in mathematics: they represent one, immutable value, but that value may not yet be known where the variable is used. Consider again our theory from before:◊includecode[#:lang "prolog" "theory.pl" "theory.pl"]

In Prolog, we could write the query likes(X,math) and learn that the query is successful for X equal to eratosthenes, but we could not write something like ◊code{likes(X,math), X = ares}◊todo{Implement cross-referencing}. Or rather, we could, but Prolog will not yield a single answer. Once a value has been assigned to a variable, it cannot be changed until Prolog backtracks. At that point, it will be as if said variable was never assigned in the first place.

With that in mind, we can think about a concrete way to connect logic variables to their values. In Parenlog, this is done using an immutable hash table, with the keys being logic variables and the values being, well, values. This mapping from variables to their assigned values is typically called a "binding environment" or just "environment" for short in PL lingo◊footnote{In logic programming circles, it's more common to talk about a substitution, which is a somewhat more general concept, but the focus here is on implementing a working version of Parenlog.}. The impossibility of reassigning variables is easy to implement: only allow updating the binding environment if the variable is unbound, or if the assignment is compatible with previous assignments to that variable.

So, ◊code{=} can do assignment only if the left-hand side is unbound? No, because ◊code{=} is not assignment, but ◊mechanism{unification}. What's the difference? Well, here's an example: ◊code{writes(X,racket) = writes(vincent,Y)} will succeed in Prolog and will bind ◊code{X} to ◊code{vincent} and ◊code{Y} to ◊code{racket}. More generally, unification finds a ◊glossaryterm{unifier}, i.e. an assignment of variables which causes two terms to become syntactically equal. And we are really only interested in the ◊glossaryterm{most general unifier}, which is a assignment of variables which does not instantiate any variables further than required. For instance, ◊code{greek(X)} and ◊code{greek(Y)} can be made equal by binding ◊code{X} to ◊code{Y}. They can also be made equal by binding ◊code{X} to ◊code{ares} and ◊code{Y} to ◊code{ares}, but that's more specific than what is required.

Unification of two ◊a[#:href "https://docs.racket-lang.org/teachpack/2htdpuniverse.html?q=S-expression#%28tech._universe._s._expression%29"]{S-expression} lists is a good way to get our feet wet, as it can be written without resorting to any auxiliary functions and is, in turn, used in a lot of the rest of the code. The standard algorithm for finding a most general unifier is known as the Martelli-Montanari algorithm and, fortunately, it makes a lot of sense. A sufficient explanation is provided on ◊link{Wikipedia} so I won't come up with my own formulation. However, the version on Wikipedia includes the "occurs check" as the last step. Don't worry about that one. Historically, it's pretty much always been omitted from Prolog implementations because it was too expensive.

Here's a suggested function signature:
;; S-expression -> S-expression -> environment -> (or/c environment #f)

Here are some ◊note{tests} for a function with said signature. I would advise you to read these first, as they can clarify some of the expected behavior. There's one case in which a variable is used on the left-hand side and on the right-hand side. That's something we'll typically avoid, but it still makes for a useful test case.
◊includecode["unify-tests.rkt" "parenlog.rkt"]

For all you eager down-scrollers, I've blurred out my own code. Click the flashlight icon to reveal the code.
◊todo{What it says, again.}
◊includecode["unify.rkt" "parenlog.rkt"]

To be fair, I rebuilt Parenlog twice. Once with some peeking at the original code, once from scratch. My first implementation of unification was a much clunkier near-transliteration of the Martelli-Montanari algorithm. The version just above is cleaner because of the insights I gained from doing this the first time.

Finally, here's Jay McCarthy's code.
◊includecode["unify-jay.rkt" "parenlog.rkt"]
