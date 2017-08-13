#lang pollen
◊(require "fonts.rkt")

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