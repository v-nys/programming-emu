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
◊h2{Introduction}
I'm a poor ◊a[#:href "http://www.racket-lang.org"]{Racket} programmer. If you give me an end-to-end task, I can probably write code that accomplishes it, but said code may be orders of magnitude longer and slower than it needs to be. I can figure out what I need to do at compile time and what I need to do at runtime, but often through trial and error. I only have ◊a[#:href "https://github.com/v-nys/cclp"]{one moderately large Racket codebase} and I'm extremely embarrassed to point you to it. Those are the facts, so what to do?

It's well established that acquiring a skill requires ◊a[#:href "http://expertenough.com/1423/deliberate-practice"]{deliberate practice}. If you want to learn how to do something general (like writing decent Racket code), it's important to have specific goals, to make a conscious effort to learn from mistakes and to seek out feedback. Enter ◊work{Programming Emu}, a project-based book in which I try to reverse engineer interesting Racket projects.

My hope is that, by carefully studying the code of experienced Racketeers, I'll be able to pick up new techniques and better programming habits. Writing a book about the process helps me stay focused on a particular project, it forces me to formulate my findings clearly and it leaves a record for myself and for you. Reverse engineering should serve as proof that I have sufficiently grasped the original code base. I encourage you to write your own implementation of the projects as we go along.

Each chapter will deal with a single project and the chapters will be more or less sorted based on the difficulty of the examined codebase. We'll dive into logic programming with ◊work{Parenlog}. ◊todo{We'll do more stuff, but I haven't decided on what that will be yet.}

The code for this book is on ◊a[#:href "https://github.com/v-nys/programming-emu"]{Github} and I welcome bug reports, feedback about my code, requests to take on specific projects or pull requests. And I would ◊em{love} questions about why I implemented something in one way and not in another. Also, don't be reluctant to contribute if you're not particularly experienced. After all, my own lack of experience is the whole reason I'm currently writing this.