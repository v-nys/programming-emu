#lang pollen
◊title[metas]{A standalone version of Parenlog}
Our implementations can now be used to compute anything the original Parenlog can compute using the same logic. However, the original still has one feature that our implementations lack: a standalone Racket-based language.◊aside{If the concept of defining languages intrigues and/or confuses you, check out ◊a[#:href "https://beautifulracket.com"]{Beautiful Racket}.}

Here's an example of a standalone Parenlog program, shamelessly lifted from the Parenlog documentation:

Note that ◊code{type} is not new syntax. It is just a predicate symbol. Similarly, ◊code{if} is not actually a conditional, just the function symbol of a compound term. So the program defines a knowledge base describing a simple type system.

No more ◊code{define-model}, no more ◊code{compile-rule}, 