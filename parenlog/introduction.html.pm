#lang pollen
◊h2{Introduction to Parenlog and Prolog}
Parenlog is a logic programming language. Logic programming is its own programming paradigm, like object-oriented or functional programming. There was a time when people thought it would become just as widespread as those other paradigms, but the fact is that it did not. Therefore, I won't assume that you have any experience with it. Don't be fooled into thinking that logic programming is not relevant, however. On the one hand, there are large, industrial codebases that rely on logic programming. On the other, "plain old" logic programming has inspired many more specialized programming styles, such as constraint programming. It's worth having in your toolkit, as it can make the right problems far easier to solve.

The mother of all logic programming languages is ◊link{Prolog}. A large part of its appeal comes from ◊mechanism{resolution},◊todo{add mechanism tag} which is a mechanism for the application of knowledge in ◊link{predicate logic}. What's nice about programming with knowledge is that (unlike when programming with instructions in imperative programs) you can reason in multiple directions. Let's say you are given the following bits of information:

◊ol{
 ◊li{If two people like the same thing, they are friends.}
 ◊li{Ares likes battle.}
 ◊li{Athena likes battle.}
}

You'll agree that Ares and Athena are friends. So will Prolog. And if you are asked to name a pair of friends, you would say "Ares and Athena". Now, you could pretty easily encode computations that tell you this into more or less any language, but in Prolog there's nothing to encode other than the knowledge.

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

Now, you'll agree that Eratosthenes, Pythagoras and Athena are all friends. Again, so will Prolog. And you (and Prolog) will agree that Ares and Athena are friends who should be feared. Or that every one of these individuals has a friend who should be feared. And all you have to do is write down this knowledge (the “◊glossaryterm{theory}”) using the following syntax:

friends(X,Y) :- likes(X,Z), likes(Y,Z).◊todo{Add syntax highlighting}
likes(ares,battle).
likes(athena,battle).
feared(X) :- likes(X,battle).
part(primes,math).
part(triangles,math).
part(logic,math).
likes(eratosthenes,primes).
likes(pythagoras,triangles).
likes(athena,logic).
likes(X,Y) :- part(Z,Y), likes(X,Z).
likes(father(athena),lightning).
greek(X).

Pretty straightforward, right? There are only a few bits of syntax worth pointing out. First, ◊predicate{friends}, ◊predicate{likes},... are all ◊glossaryterm{predicate}s. They are ◊glossaryterm[#:canonical "term"]{terms} which provide information about other terms which are ◊glossaryterm{logic variable}s (which begin with an upper case letter), ◊glossaryterm[#:canonical "atom"]{atoms} (which begin with a lower case letter), or ◊glossaryterm[#:canonical "compound"]{compounds} (which begin with a lower case letter and have other terms as their arguments, so they look like predicates, but predicates only occur in the outermost syntactic position as far as we're concerned). That information can take the form of a ◊glossaryterm{fact}, which is just "raw" information or the form of a ◊glossaryterm{rule}, which is knowledge that can be used in a deduction. Facts are written as predicates immediately followed by a period (e.g. likes(ares,battle).) and rules are written as one predicate, followed by the ◊glossaryterm{implication} symbol ◊shortcode{:-}, followed by a non-zero number of predicates again.

Your typical Prolog program is also different from most programs in that, when you start it up... nothing happens. Well, one thing happens. You get a prompt. From that prompt, you can write ◊glossaryterm[#:canonical "query"]{queries}. Essentially, you can ask Prolog questions. You could ask for someone who likes mathematics by writing a predicate with a variable in it: likes(X,math). And you could ask for three individuals who like mathematics by separating predicates with a comma: likes(X,math), likes(Y,math), likes(Z,math).◊aside{If most of this sounds suspiciously like SQL, know that SQL is almost a logic programming language in disguise --- though most databases do not allow deduction of implicit knowledge.}

Prolog will answer these queries by providing a ◊glossaryterm{substitution} for your query: an assignment of a value to each input variable. For the three individuals who like math, you might get:

X = eratosthenes
Y = pythagoras
Z = athena

However, that won't be the only answer you'll get, nor will it be the first. The first answer you'll get is actually a little tricky:

X = eratosthenes
Y = eratosthenes
Z = eratosthenes

This is because, strictly according to the knowledge in the system, this is correct. We haven't specified that X, Y and Z need to be different values. And the reason we get the value ◊shortcode{eratosthenes} is because the knowledge base is ordered: no one explicitly likes math, so Prolog first looks for someone who likes some part of math. And the first part of math it finds is prime numbers. And the person who likes primes is Eratosthenes. There's a somewhat more technical explanation, but I'll refer you to the mechanisms section if you're interested.◊todo{Mechanisms section with grammar, unification, resolution, rule application, backtracking} You will ◊em{also} get the more intuitive answer, though. This is because Prolog uses a technique called ◊mechanism{backtracking}. Backtracking means that, once we cannot continue a derivation (because we have an answer or because no rules apply any more), Prolog will undo the most recent step in the derivation and try to come up with a new solution. If there are no more ways to come up with a new solution, it will undo the second most recent step, and so on. Again, look at the mechanisms section if you want to know more details.

That's all we need to know about Prolog for now. Jay McCarthy's ◊link{Parenlog} is a strongly Prolog-inspired logic programming language which uses S-expression lists to represent terms. As an added perk, Parenlog makes it possible to mix predicates defined in the DSL itself with predicate functions, defined in Racket (or some other Racket-based language). I advise you to just read the ◊link{documentation} for Parenlog for a moment, to get a feel for the different notation.

The codebase is small (really, all the actual work happens in one file) and it can be broken up into two parts: a part related to embedded language and a part related to the standalone language. It should make for a manageable first project.
