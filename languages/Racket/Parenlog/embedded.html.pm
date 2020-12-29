#lang pollen
◊title[metas]{Completing the embedded language}
So far, we've written models using ◊code{compile-rule} and answered queries using ◊code{answer-query}. That's fine, but it's a little lower-level than we typically want, even if we are using Parenlog as a library.

To wrap up Parenlog as a library, we'll add ◊code{define-model}, ◊code{:-}, ◊code{query-model} and ◊code{model?}, which are described ◊a[#:href "http://docs.racket-lang.org/parenlog/Embedded_Parenlog.html"]{here}.

Don't overthink these. Just start with a struct, ◊code{model} with a single field for a list of rules.

My version of the struct and the original:
◊todo{Code comparison invoegen.}

Next, a side-by-side comparison of ◊code{define-model} and ◊code{:-}.

◊todo{Toevoegen.}

Incidentally, why do we need to define ◊code{:-} outside of ◊code{define-model} if it can only occur inside the latter?

◊todo{Toelichten.}

Finally, both versions of ◊code{query-model}.

Nothing too crazy in this section if you managed to get through the previous ones. If you're still early in your Racket career, the next section should stretch your neurons a little more.