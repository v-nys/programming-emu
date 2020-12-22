#lang pollen
◊title[metas]{Parenlog}
◊abstract{◊a[#:href "https://github.com/jeapostrophe/parenlog"]{Parenlog} is a both an embedded and a standalone language for logic programming in Racket. It can be used for automated deductive reasoning and integrates with existing Racket predicate functions.} If you're into deductive reasoning and logic puzzles, this project is for you. You'll need to know some Racket, but not a lot. Roughly, you've built ◊em{something} in Racket on your own, or you've gone through ◊a[#:href "https://www.nostarch.com/realmofracket.htm"]{◊work{Realm of Racket}}. You'll also need to know just a little bit about macros (I strongly recommend ◊a[#:href "http://www.greghendershott.com/fear-of-macros/"]{◊work{Fear of Macros}}).
 
◊aside{The original code and my own reimplementation are LGPL code.}

◊h3{Table of contents}
◊(toc-for-descendants metas)
◊;toc[#:ptree "parenlog.ptree" #:depth 2 #:exceptions '(parenlog.html) #:ordered? #t]