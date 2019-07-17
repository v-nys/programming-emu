#lang pollen
◊(require "base-textual-structure-params.rkt")

.c-pageturn {
position: fixed;
top: 50%;
}

.c-pageturn-left {
transform: translate(-120%,-50%);
left: calc(50% - 480px);
}

.c-pageturn-right {
transform: translate(120%,-50%);
right: calc(50% - 480px);
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
