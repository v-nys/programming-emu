#lang scribble/manual
@title{Annotated code}
The annotated code library offers two tags functions and one decoding function. The former are includecode and codenote. The includecode tag introduces a code sample not suitable for inline presentation. The codenote tag follows it (or another codenote tag) immediately and is associated with the preceding sample. No other elements can be inserted between the sample and the note(s).

The decoding function, postprocess-notes, operates on the root of the document tree. The reason why it is needed is because notes cannot be linked to the correct code fragments without considering their position inside the larger whole, i.e. the document tree.