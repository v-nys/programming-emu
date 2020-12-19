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
  font-size: 12pt;
}

.annotated-listing {
  display: flex;
  flex-direction: row;
  align-items: first baseline;
}

.annotated-listing table {
  flex: 1 0 0;
}

.listingtab {
  display: inline-block;
  background: ◊light-gray;
  font-size: ◊code-pt-size;
  padding: .25em .5em;
}

.annotated-listing p {
  flex: 1 0 0;
  margin-top: 0;
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
