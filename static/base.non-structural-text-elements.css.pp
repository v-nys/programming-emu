#lang pollen
◊(require "fonts.rkt"
          "palette.rkt"
          "base-non-structural-text-elements-params.rkt"
          "base-textual-structure-params.rkt")

code {
background-color: ◊very-light-gray;
font-family: ◊code-font-family;
border-radius: 3px;
border: 1px solid ◊light-gray;
font-size: ◊code-pt-size;
}

work {
font-style: italic;
}

todonote {
position: absolute;
right: ◊(/ todo-margin-percentage 2)%;
width: ◊(- (/ content-margin-percentage 2)
           todo-margin-percentage)%;
}

signature {
font-family: ◊code-font-family;
font-size: ◊code-pt-size;
}
