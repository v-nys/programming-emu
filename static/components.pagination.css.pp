#lang pollen
◊(require "base-textual-structure-params.rkt")

.c-pageturn {
position: fixed;
top: 50%;
text-align: center;
}

.c-pageturn-left {
transform: translate(50%,-50%);
}

.c-pageturn-right {
right: 0;
transform: translate(-50%,-50%);
}

.c-pageturn-right__img{
-moz-transform: scaleX(-1);
-o-transform: scaleX(-1);
-webkit-transform: scaleX(-1);
transform: scaleX(-1);
filter: FlipH;
-ms-filter: "FlipH";
}

.c-pageturn-img {
width: 100%;
}

.c-pageturn-default-img:hover {
visibility: hidden;
}

.c-pageturn-hovered-img:not(:hover) {
visibility: hidden;
}
