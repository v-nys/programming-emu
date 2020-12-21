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

listing {
display: block;
}

.highlighted {
  background-color: yellow;
}

listing code {
border-radius: 0;
font-size: 15pt;
}

.code-discussion {
  font-size: 12pt;
}

.code-discussion-controls {
  display: flex;
  flex-direction: row;
  justify-content: end;
}

.code-discussion pre {
  /* onduidelijk waar bestaande marges vandaan komen */
  margin-top: 0;
  margin-bottom: 0;
}

listing {
  display: flex;
  flex-direction: row;
  align-items: first baseline;
}

.listingtab {
  display: inline-block;
  background: ◊light-gray;
  font-size: ◊code-pt-size;
  padding: .25em .5em;
}

work {
font-style: italic;
}

todonote {
  float:right;
}

signature {
font-family: ◊code-font-family;
font-size: ◊code-pt-size;
}

.hidden {
  display: none;
}
