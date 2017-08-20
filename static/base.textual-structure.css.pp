#lang pollen
◊(require "base-textual-structure-params.rkt" "fonts.rkt" "palette.rkt")

aside {
padding-left: .5em;
background-color: ◊light-gray;
border-left: 2px solid gray;
padding-top: .5em;
padding-bottom: .5em;
}

body {
color: ◊body-text-color;
font-family: ◊general-content-font;
}

content {
display: block;
margin-left: auto;
margin-right: auto;
width: ◊(- 100 content-margin-percentage)%;
}

exercise {
font-weight: bold;
}

h1, h2, h3, h4, h5, h6 {
font-family: ◊header-font-family;
font-variant: ◊header-font-variant;
}

output {
font-family: ◊code-font-family;
color: ◊fuchsia;
}

p {
line-height: 150%;
}

pre {
border-left: 1px dashed;
font-size: ◊code-pt-size;
padding-left: 1em;
}