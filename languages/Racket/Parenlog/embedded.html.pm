#lang pollen
◊title[metas]{Completing the embedded language}
So far, we've written models using ◊code{compile-rule} and answered queries using ◊code{answer-query}. That's fine, but it's a little lower-level than we typically want, even if we are using Parenlog as a library.

To wrap up Parenlog as a library, we'll add ◊code{define-model}, ◊code{:-}, ◊code{query-model} and ◊code{model?}, which are described ◊a[#:href "http://docs.racket-lang.org/parenlog/Embedded_Parenlog.html"]{here}. Note that the current version of Parenlog supports extending an existing model. I started this project when that option was not available yet, so just ignore it for now. This chapter will be updated in the future.

Don't overthink these constructs. Just start with a struct, ◊code{model} with a single field for a list of rules. The ◊code{define-model} macro rearranges syntax slightly, so that the parts you write are supplied as arguments to ◊code{compile-rule}. Finally, ◊code{query-model} translates into ◊code{answer-query}, but restricts the produced substitutions to the variables in the original query and it returns a list (i.e. it is not a generator).

You can use the following tests:

◊listing[#:source "code/embedded-tests.rkt" #:fn "embedded.rkt"]

◊aside{There are no significant differences between the runtime approach and the compile-time approach.}

None of this requires a lot of code, so here's my complete implementation:
◊code-discussion[
◊listing[#:source "code/embedded.rkt" #:fn "embedded.rkt" #:highlights '((3 0) (4 15))]{The struct really is as simple as they come.}
◊listing[#:source "code/embedded.rkt" #:fn "embedded.rkt" #:highlights '((5 16) (5 35) (19 10) (19 55))]{◊code{expand-rule-or-fact} is a helper macro, applied to each rule. This makes it easy to distinguish between rules with the implication operator and bare facts.}
◊listing[#:source "code/embedded.rkt" #:fn "embedded.rkt" #:highlights '((6 20) (6 22) (7 9) (7 11))]{◊code{:-} occurs literally in our rule syntax, so we need to specify that here to avoid seeing it as a pattern. For ◊code{syntax-case}, it does not need to be defined separately.}]

◊aside{I haven't yet gotten around to comparing this to the original implementation.}

Nothing too crazy in this section if you managed to get through the previous ones. If you're still early in your Racket career, the next section should stretch your neurons a little more.