#lang pollen
◊h2{Comparing to the original}
Now that we've got basic Prolog-like functionality, let's see how our implementation of resolution measures up to that of an expert Racket programmer.
...
Even if we don't have the full picture yet, we've spotted a key difference: the original Parenlog treats 

A little thing that has puzzled me for a while is this:
◊includecode["code/generator-uniq.rkt"]

The purpose of this bit of code is to generate a unique value, which can be used to indicate the end of a generated sequence. I used ◊code{'done} for the same purpose, so defining a unique struct for this purpose alone struck me as odd. Admittedly, there might be a problem if you wanted to generate the value ◊code{'done}, but you might also generate a unique symbol with ◊code{gensym}.◊todo{Explain gensym? Add something like Matthew Butterick's "explainers"?} So I asked Jay about it and, to avoid twisting his words, here's his response:

◊blockquote{Yes, you could just use gensym. I like the idea that the type is unique and in general I like to not re-use things like symbols, lists, and vectors and instead make my own structures. It is an extreme form of anti-Common-Lisp-ism.}

So don't sweat it if you didn't do it exactly like the original.

Meticulous readers might also notice that Jay's implementation of ◊code{reyield} is a little different from mine. The explanation for this is more historical than technical, so rest easy, regardless of how you did it.

Now we have two implementations of resolution. In the next chapter, we'll look at how feasible it is to add interaction with Racket ◊glossaryterm[#:canonical "predicate function" #:explanation ◊explanation{Racket functions }]{predicate functions} to both.