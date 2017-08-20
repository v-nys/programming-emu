#lang pollen
◊(require "fonts.rkt"
          "palette.rkt"
          "base-non-structural-text-elements-params.rkt"
          "base-textual-structure-params.rkt")

inline-code {
background-color: ◊very-light-gray;
font-family: ◊code-font-family;
}

work {
font-style: italic;
}

warning {
font-weight: bold;
}

todonote {
position: absolute;
right: ◊(/ todo-margin-percentage 2)%;
width: ◊(- (/ content-margin-percentage 2)
           todo-margin-percentage)%;
}