#lang pollen
◊title[metas]{Introduction to Parenlog and Prolog}
Parenlog is a logic programming language. Logic programming is its own programming paradigm, like object-oriented or functional programming. There was a time when people thought it would become just as widespread as those other paradigms, but the fact is that it did not. Therefore, I won't assume that you have any experience with it. Don't be fooled into thinking that logic programming is not relevant, however. There are ◊a[#:href "https://www.cs.nmsu.edu/ALP/2010/06/25-years-of-applications-of-logic-programming-in-italy/"]{lots of industrial codebases} that rely on logic programming. There are also ◊a[#:href "http://www.constraintsolving.com/"]{many applications for constraint programming}, which is descended from and often extends logic programming. And it's pretty fun, to boot. In short, logic programming is worth having in your toolkit.

The mother of all logic programming languages is ◊a[#:href "https://en.wikipedia.org/wiki/Prolog"]{Prolog}. What's unusual about Prolog is that you, as a programmer, encode knowledge much more directly than you would in most languages. And knowledge, unlike your typical imperative instructions, is flexible. It works in several directions, so to speak. Let's say you are given the following bits of information:

◊ol{
 ◊li{If two people like the same thing, they are friends.}
 ◊li{Ares likes battle.}
 ◊li{Athena likes battle.}
}

You'll agree that Ares and Athena are friends. So will Prolog. Now, you could pretty easily encode computations that tell you this into more or less any language, but in Prolog there's nothing to encode other than the knowledge. We'll go into detail a bit further on, but the code just looks like this:
◊listing[#:source "code/theory_part_one.pl" #:lang "prolog"]

Let's step it up. Suppose we have the following knowledge in addition to what we already had.
◊ol['((start "4"))]{
  ◊li{Anyone who likes battle should be feared.}
  ◊li{Prime numbers are part of mathematics.}
  ◊li{Triangles are part of mathematics.}
  ◊li{Logic is a part of mathematics.}
  ◊li{Eratosthenes likes prime numbers.}
  ◊li{Pythagoras likes triangles.}
  ◊li{Athena likes logic.}
  ◊li{Anyone who likes a part A of a whole B also likes B.}
  ◊li{Athena's father likes lightning.}
  ◊li{Everyone is Greek.}
}

Now, you'll agree that Eratosthenes, Pythagoras and Athena are all friends. Again, so will Prolog. And you (and Prolog) will agree that Ares and Athena are friends who should be feared. Or that every one of these individuals has a friend who should be feared. Here's how you would encode the rest of the knowledge base (the ◊glossaryterm[#:explanation "an ordered sequence of clauses which together make up a logic program"]{theory} in Prolog speak):
◊listing[#:source "code/theory_part_two.pl" #:lang "prolog"]

Even if you don't know the exact syntax yet, this looks like a very concise and readable representation of our theory, right? Let's go into a bit more detail regarding the structure of this theory before we start doing computations. First, ◊predicate{friends(X,Y)}, ◊predicate{likes(eratosthenes,primes)},... are all ◊glossaryterm[#:canonical "predicate" #:explanation "in logic programming, a term indicating that its argument belongs to a set of values with some property (in the case of one argument), a relation between its arguments (in the case of multiple arguments), a set of values (in the case of one argument), or a mathematical relation between sets to which those arguments belong"]{predicates}. These are ◊glossaryterm[#:canonical "term" #:explanation "in logic programming, either a logic variable, an atom or a compound"]{terms} which indicate a relation between their arguments. Prolog's terms consist of ◊glossaryterm[#:canonical "logic variable" #:explanation "a mathematical unknown which can be bound only once to a term"]{logic variables} (which begin with an upper case letter and are best considered as "mathematical unknowns" rather than being like variables in most other languages), ◊glossaryterm[#:canonical "atom" #:explanation "in logic programming (assuming no extra-logical features such as built-in arithmetic), a constant"]{atoms} (which begin with a lower case letter), or ◊glossaryterm[#:canonical "compound" #:explanation "a term consisting of a symbol and several nested terms"]{compounds} (which begin with a lower case letter and have other terms as their arguments, so predicates are represented as compounds that only occur in the outermost syntactic position as far as we're concerned). That information can take the form of a ◊glossaryterm[#:explanation "in logic programming, an axiomatic encoding of information"]{fact}, which is just "raw", axiomatic information or that of a ◊glossaryterm[#:explanation "in logic programming, an encoding of an allowed deduction"]{rule}, which is knowledge that can be used in a deduction. Facts are written as predicates immediately followed by a period (e.g. ◊code{likes(ares,battle).}) and rules are written as one predicate, followed by the ◊glossaryterm[#:explanation "in logic programming, an operator expressing \"if A, then B\""]{implication} symbol ◊code{:-}, followed by a non-zero number of predicates and terminated by a period. Facts and rules are collectively known as ◊glossaryterm[#:canonical "clause" #:explanation "either a fact or a rule"]{clauses}.

Unfortunately, the term "predicate" is a little overloaded. In addition to what I've described above, a "predicate" can also be a mathematical relation between sets, rather than a relation between specific terms belonging to these sets. It's usually clear from the context which meaning is intended, but when we talk about a mathematical relation, we'll write something like ◊code{friends/2}, ◊code{greek/1}, where the number indicates the number of arguments in an actual term instantiating that predicate.

With the terminology out of the way, let's look at what happens when you run a simple Prolog program like the one above. The answer is... nothing. Well, one thing happens. You get a prompt. From that prompt, you can write ◊glossaryterm[#:canonical "query" #:explanation "a predicate or a conjunction for which an answer is found through deductive reasoning"]{queries}. Essentially, you can ask Prolog questions. You could ask for someone who likes mathematics by writing a predicate with a variable in it (the query itself), followed by a dot: ◊code{likes(X,math).}. And you could ask for three individuals who like mathematics by separating predicates with a comma and, again, ending with a dot: ◊code{likes(X,math), likes(Y,math), likes(Z,math).}.

Prolog will answer these queries by providing a ◊glossaryterm[#:explanation "in logic programming, an assignment of terms to variables"]{substitution} for your query: an assignment of ◊glossaryref[#:canonical "term"]{terms} to input variables. For the three individuals who like math, you might get:

◊output{
X = eratosthenes,
Y = pythagoras,
Z = athena
}

However, that won't be the only answer you'll get, nor will it be the first. The first answer you'll get may be a little confusing:

◊output{
X = eratosthenes,
Y = eratosthenes,
Z = eratosthenes
}

This is because, strictly according to the knowledge in the system, this is correct. We haven't specified that ◊code{X}, ◊code{Y} and ◊code{Z} need to be different values. And the reason we get the value ◊code{eratosthenes} is because the theory is ordered: rules and facts are applied from top to bottom. No one in our theory ◊em{explicitly} likes math, so Prolog first looks for someone who likes some part of math. And the first part of math it finds is prime numbers. And the person who likes primes is Eratosthenes. You will ◊em{also} get the more intuitive answer, though. The reason for this is Prolog's use of ◊glossaryterm[#:explanation "mechanism by which a logic programming language generates multiple solutions to a single query"]{backtracking}. This means that, once we cannot continue a logical derivation, Prolog will undo the most recent step in the derivation and try to come up with a new solution. If there are no more ways to come up with a new solution, it will undo the second most recent step, and so on.

That's all we need to know about Prolog for now. Jay McCarthy's ◊a[#:href "https://github.com/jeapostrophe/parenlog"]{Parenlog} is a Prolog-inspired ◊glossaryterm[#:explanation "a computer language built for a specific application domain, rather than for general-purpose programming"]{domain-specific language} (or DSL) which uses ◊glossaryterm[#:explanation (list "roughly a nested list of basic data, defined " '(a ((href "https://docs.racket-lang.org/teachpack/2htdpuniverse.html?q=S-expression#%28tech._universe._s._expression%29")) "here"))]{S-expression} lists to represent terms. As an added perk, Parenlog makes it possible to mix predicates defined in the DSL itself with predicate functions defined in Racket (or a Racket-based language). I advise you to just read the ◊a[#:href "http://docs.racket-lang.org/parenlog/index.html"]{documentation} for Parenlog for a moment, to get a feel for the different notation.

The codebase is small (really, all the actual work happens in one file) and it can be broken up into two parts: a part related to the embedded language and a part related to the standalone language. It should make for a manageable project, even if you are fairly new to language development in Racket. We'll start out with a small subset of features and refactor code whenever we can't achieve parity with Jay's implementation for the maximum learning benefit.
