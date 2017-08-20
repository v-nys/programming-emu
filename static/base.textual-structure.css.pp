#lang pollen
◊(require "base-textual-structure-params.rkt" "fonts.rkt" "palette.rkt")

body {
color: ◊body-text-color;
font-family: ◊general-content-font;
}

h1, h2, h3, h4, h5, h6 {
font-family: ◊header-font-family;
font-variant: ◊header-font-variant;
}

pre {
border-left: 1px dashed;
font-size: ◊code-pt-size;
padding-left: 1em;
}

aside {
padding-left: .5em;
background-color: ◊light-gray;
border-left: 2px solid gray;
padding-top: .5em;
padding-bottom: .5em;
}

p {
line-height: 150%;
}

content {
display: block;
margin-left: auto;
margin-right: auto;
width: ◊(- 100 content-margin-percentage)%;
}