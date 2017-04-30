#lang pollen
◊h1{Introduction}
Logic programming is its own programming paradigm, like object-oriented or functional programming. There was a time when people thought it would become just as prominent as the other paradigms, but the fact is that it is not. Therefore, I won't assume that you have any experience with it. Don't be fooled into thinking that logic programming is not relevant, however. On the one hand, there are large, industrial codebases that rely on logic programming. On the other, "plain old" logic programming has inspired a lot of more specialized programming styles, such as constraint programming.

The mother of all logic programming languages is a language known as ◊link{Prolog}. A large part of its appeal comes from a mechanism called ◊glossaryterm{resolution}, which is a mechanism for the application of knowledge in ◊link{predicate logic}.

Jay McCarthy's ◊link{Parenlog} is strongly Prolog-inspired logic programming language which uses a more Racket-like notation. As an added perk, Parenlog makes it possible to mix predicates defined in the DSL itself with predicate functions, defined in Racket (or some other Racket-based language).

The codebase is small (really, all the actual work happens in one file) and it can be broken up into two parts: a part related to embedded language and a part related to the standalone language.
It should make for a manageable first project.