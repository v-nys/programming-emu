#lang pollen
◊h2{Comparing to the original}
Now that we've got basic Prolog-like functionality, let's see how our implementation of resolution measures up to that of an expert Racket programmer. We'll start by locating the "analogs" to the code we've already written to get a foothold. That way, the bits which are very different will at least show up in a familiar context. I won't go into every surface detail that's different between the two implementations, so here's a simple reference for the straightforward bits:


We've already compared ◊code{variable?}, ◊code{unbound-variable?}, ◊code{bound-variable?} and ◊code{unify}, so those are fine.

The next function I introduced was ◊code{extract-vars}, which takes an S-expression argument and returns the set of all symbols we use to model Prolog variables. Jay's version is called ◊code{variables-in-q} and the only differences are superficial, at least if we disregard code for some features we don't have yet.

◊alert{If you're digging into Jay's actual codebase, you'll encounter a function named ◊code{extract-vars}. That actually serves a different purpose, which we'll cover later on.}


◊;M.O. variable? staat in stx.rkt omdat het bij Jay effectief op syntax werkt -> bespreek dit en unbound-variable? iets later.

Even if we don't have the full picture yet, we've spotted a key difference: the original Parenlog implements Prolog variables using Racket variables, whereas my implementation uses symbols to represent Prolog variables.

◊h3{Little details}
A little thing that puzzled me is this:
◊includecode["code/generator-uniq.rkt"]

The purpose of this bit of code is to generate a unique value, which can be used to indicate the end of a generated sequence. I used ◊code{'done} for the same purpose, so defining a unique struct for this purpose alone struck me as odd. Admittedly, there might be a problem if you wanted to generate the value ◊code{'done}, but you might also generate a unique symbol with ◊code{gensym}.◊todo{Explain gensym? Add something like Matthew Butterick's "explainers"?} So I asked Jay about it and, to avoid twisting his words, here's his response:

◊blockquote{Yes, you could just use gensym. I like the idea that the type is unique and in general I like to not re-use things like symbols, lists, and vectors and instead make my own structures. It is an extreme form of anti-Common-Lisp-ism.}

So don't sweat it if you didn't do it exactly like the original.

Meticulous readers might also notice that Jay's implementation of ◊code{reyield} is a little different from mine. The explanation for this is more historical than technical, so rest easy, regardless of how you did it.

◊h3{What's next?}
Now we have two implementations of resolution. In the next chapter, we'll look at how feasible it is to add interaction with Racket ◊glossaryterm[#:canonical "predicate function" #:explanation ◊explanation{Racket functions }]{predicate functions} to both. There's no single right implementation here. For now, at least.