#lang pollen
◊(require "base-textual-structure-params.rkt" "fonts.rkt" "palette.rkt")

@font-face {
font-family: 'ChunkFive';
src: url("/static/fonts/Chunkfive.woff");
}

aside {
padding-left: ◊aside-padding-left;
background-color: ◊very-light-gray;
border-left: 2px solid gray;
padding-top: .25em;
padding-bottom: .25em;
margin-top: 1em;
margin-bottom: 1em;
}

body {
color: ◊body-text-color;
font-family: ◊general-content-font;
}

content {
display: block;
margin-left: auto;
margin-right: auto;
max-width: ◊content-max-width;
}

exercise {
display: block;
font-weight: bold;
line-height: 150%;
}

h1, h2, h3, h4, h5, h6 {
font-family: ◊header-font-family;
font-variant: ◊header-font-variant;
font-weight: normal;
font-style: normal;
}

h1 {
font-size: 1.6em;
}

h2 {
font-size: 1.4em;
}

h3 {
font-size: 1.2em;
}

output {
font-family: ◊code-font-family;
font-size: ◊code-pt-size;
color: ◊fuchsia;
}

p {
/* could use a class for all blocks of text? */
line-height: 150%;
}

pre {
font-size: ◊code-pt-size;
margin: 0;
}

warning {
display: block;
font-weight: bold;
line-height: 150%;
border: 1px solid red;
background-color: pink;
border-radius: 5px;
padding: .5em;
}

listing {
margin: 0;
}

.non-annotated-listing pre {
width: 100%;
}

.code-annotation {
white-space: normal;
font-family: Gentium Basic;
padding: 0 1em;
font-size: ◊code-pt-size;
}

.counted-lines {
  counter-reset: line;
}

.line {
  display: block;
}

.line:before {
  counter-increment: line;
  content: counter(line);
}
