#lang pollen
◊title[metas]{A standalone version of Parenlog}
Our implementations can now be used to compute anything the original Parenlog can compute using the same logic. However, the original still has one feature that our implementations lack: a standalone Racket-based language.

◊a[#:href "https://docs.racket-lang.org/parenlog/Standalone_Parenlog.html"]{The documentation} is clear and concise, so I won't repeat the same explanations here. Please read it before continuing.

There are a few things worth noting in the documentation. First, ◊code{type}, which is used in the example, is not new syntax. It is just a predicate symbol. Similarly, ◊code{if} is not actually a conditional, just the function symbol of a compound term. The current version of the documentation links to the Racket Reference's section on conditionals, but I believe this is due to a parsing error. So the program defines a knowledge base describing a simple type system.

Second, it is not stated whether occurrences of ◊code{(? body-query)} can be interspersed with the theory. For my implementation, I'm going to assume that they cannot and that they should come at the end of the file. They are delayed anyway, so I see no point in interspersing the theory with these statements. That would offer no benefit and add redundant machinery.

Third, a unified mechanism for queries that occur in the Parenlog file and queries that are typed in the REPL would be ideal. Writing ◊code{(? body-query)} at the end of a file is functionally equivalent to typing ◊code{body-query} at the REPL in every respect, including the treatment of ◊code{next}. So it may even be possible to translate these body elements into REPL expressions. I say "may" because this is not an aspect of Racket that I am particularly familiar with.

So here is my thought process:
◊ul{
◊li{◊code{(? body-query)} occurrences should be implemented the same way as queries entered at the REPL}
◊li{everything else should be wrapped inside a module which consists of a model definition}
◊li{REPL interactions are implicitly wrapped in ◊code{#%top-interaction}, so maybe I can just define this so that the queries are run}
◊li{◊code{next} looks like an ◊a[#:href "https://docs.racket-lang.org/guide/pattern-macros.html?q=identifier%20macro#%28tech._identifier._macro%29"]{"identifier macro"} and can probably be translated into a generator call for the most recently started query}
}

Let's start by getting ◊code{#lang parenlog} working and making it define the model before we worry about anything related to actually running queries. As explained in ◊a[#:href "https://docs.racket-lang.org/guide/hash-lang_syntax.html"]{the Racket Guide}, we can start by creating a ◊code{parenlog/lang/reader} module with ◊code{read} and ◊code{read-syntax} functions. This does not involve a lot of work, because we are using Racket syntax, which means we can let ◊a[#:href "https://docs.racket-lang.org/guide/syntax_module-reader.html"]{◊code{#lang s-exp syntax/module-reader}} do the heavy lifting.

So, here's what I did:
◊listing[#:source "code/my-reader.rkt" #:fn "(my) /lang/reader.rkt" #:lang "scheme"]

I put the macros required by the language in that file ◊code{main.rkt}. 

Eerste tussenstap: commit 7ab65634 zorgt dat ik een #lang parenlog2021 file kan runnen en niet meer.
Tweede tussenstap: shiften van (? ...) naar achteraan in de module. Heb dit nog niet.

TODO: Racket Guide, H17 lezen om de vertaling te doen in de mate van het mogelijke. Stukken die niet lukken => spring naar implementatie Jay.

Let's start by examining what the sample module expands into. The first two parenthesized expressions are facts, the third is a rule.