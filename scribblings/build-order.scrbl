#lang scribble/manual
@title{Build order}
Programming Emu requires that certain build order is followed. There are multiple reasons for this:
@itemlist[@item{A glossary is constructed from the source and pages which follow the page introducing a certain term can contain a reference to the glossary to jog the reader's memory.}@item{Page titles are inserted the generated tables of contents (which are only built using page nodes).}]

For this reason, pagenodes containing tables of contents are processed after their descendants and the glossary is handled after the actual contents of the book. This does not mesh well with Pollen's use of the Racket web server, because the contents of a page can be affected by the contents of a different page. For this reason, the Makefile simply generates the output and serves it through a Dockerized Apache web server. Changes to the text mean that the output must be fully regenerated and sent to the Apache web server.
