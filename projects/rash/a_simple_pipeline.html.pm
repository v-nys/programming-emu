#lang pollen
◊h2{A Simple Program Pipeline}
◊commit{a1f1926f179952ff90e507fda50f0bbd3f5758e1}
William's documentation points out that most of the heavy lifting in Rash is done by the shell-pipeline library. Said library is a part of Rash, so we're not getting off easy. Therefore, a reasonable first question is: "What does shell-pipeline do?" The answer: it builds UNIX pipelines. That makes sense. If the first thing you ever did in a shell was run an external program, there's a good chance the second thing was build a pipeline consisting of multiple programs. Indeed, pipelines immediately make a shell much more interesting and useful, so we'll work from there. We will write our own libraries which allow us to conveniently run external programs so that their input and output streams (of bytes only, for now) are conveniently linked together. In Programming Emu fashion, I'll first sketch some concepts, then I'll point you to some useful bits of Racket and, show how my own version compares to William's and finally I'll point out what I picked up.

If you're not particularly comfortable with shells or if you feel like you could use a refresher, ◊a[#:href "https://en.wikipedia.org/wiki/Pipeline_(Unix)"]{the Wikipedia entry on UNIX pipes is a good place to start}. Some more useful resources are ◊a["http://www.linfo.org/pipes.html"]{here}, ◊a["https://swcarpentry.github.io/shell-novice/04-pipefilter/"]{here} and ◊a["http://www.linuxjournal.com/article/2156"]{here}. The last one goes a bit beyond what we'll cover for now, so you can just stick to the information on unnamed pipes. If you want to get a feel for where we're going, check out ◊a[#:href "https://asciinema.org/a/sHiBRIlSM9wHDetDhsVjrCaZi"]{William's demo} or his ◊a[#:href "https://www.youtube.com/watch?v=yXcwK3XNU3Y"]{RacketCon talk}. But don't feel like you need to know everything. I started writing this thing with a relatively vague understanding of how shells typically work.

◊h3{Wiring up subprocesses}
When we run a pipeline in a well-known shell like bash, each "segment" of the pipeline is a separate program. A complete pipeline consists of several programs which run simultaneously and which have connected input and output streams. Suppose we have the following pipeline: ◊code{echo -e "hello world!\nhow are you?\nI'm fine, thanks." | grep -i 'o' | wc -l}. In a UNIX pipeline (unlike in a DOS pipeline), it is ◊em{not} the case that the ◊code{echo} command has to exit before the ◊code{grep} command is started. It's just that ◊code{grep} and ◊code{wc} wait for their input until something comes in. And they know when to quit because of an end-of-file marker.◊;TODO klopt dit wel helemaal?
In a way, that's good news, because it allows for a fairly simple setup.
Specifically, we can create a separate process for each pipeline segment.
We just have to figure out how to connect the input and output streams for the separate processes.
Note that we do not have to connect error streams --- each process has its own error stream that can go wherever we direct it.

Those are enough concepts to write a very crude pipeline, but in addition to concepts, you'll need to know about some tools and techniques. The key tools I used are Racket's ◊code{find-executable-path} and ◊code{subprocess} functions. The former allows you to look up an executable by name (using the ◊a[#:href "http://www.linfo.org/path_env_var.html"]{PATH variable}), so that you can run it. The latter allows you to start external processes and direct input, output and error streams. If either one is new to you, have a quick look at the documentation and don't worry if it doesn't all make sense right away. To be fair, ◊code{subprocess} in particular can be a little confusing if you've never used it before. If you supply a non-false value for the standard output stream, for instance, it has to be an ◊code{output-port?} and a ◊code{file-stream-port?} If you supply ◊code{#f}, the function will return a new ◊em{input port piped from the process’s standard output}. So you either supply an output port, which is then used, or it creates its own port, which is an ◊code{input-port?} and a ◊code{file-stream-port?}

Why does the created port have a different contract than a port which can be supplied? It's because, if the process creates its own output port, you won't want to write to it directly. But you will want to know what the process writes to it, so you'll need to be able to read from it. So to you, the caller, it's an input port.

◊; TODO: techniek: aparte structs voor spec en instantie

◊h3{Checking the crude pipeline}
So, are our processes being run correctly? At this point, I noticed my code did not support sane testing. I checked the output of the final process in a pipeline thusly:

Did this test tell me that my pipeline was running correctly? I suppose it did. Was it a good test? No. Using ◊code{sleep} when a program's logic has nothing to do with time should be a clear indicator that our code does not support testing. 

◊h3{Waiting}

◊h3{Comparing to the original}
