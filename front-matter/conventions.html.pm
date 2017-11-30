#lang pollen
◊;{MIT License

 Copyright (c) 2017 Vincent Nys

 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.}
◊h2{Conventions}
This book uses a few typographical conventions and has some features. Here's a by-example overview.

Standard output looks like this:
◊output{Something that was displayed.}

Inline code snippets look like this: ◊code{(+ 1 2 3)}. Longer code samples show the name of the source file in the top bar. You can click the icon next to the file name to copy the source code. You can click on the note numbers in the margins to toggle explanations about particular lines.

◊newincludecode["code/example-code.rkt" #:fn "source-file.rkt"]
◊codenote[#:line 1]{Behold the power of Racket!}

When code samples are compared, each variant will use a different accent color.

◊newincludecode["code/example-code.rkt" #:fn "source-file-a.rkt"]
◊codenote[#:line 1]{This file is written in Racket.}
◊newincludecode["code/example-code.rkt" #:fn "source-file-b.rkt" #:comparison-index 2]
◊codenote[#:line 1]{This file is also written in Racket.}