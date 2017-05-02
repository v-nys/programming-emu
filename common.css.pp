#lang pollen
◊;; i.e. percentage of page to left and right (combined) of content which is blank
◊(define body-margin-percentage 32)
◊;; i.e. percentage of page immediately to left and right (combined) of todo notes which is blank
◊(define todo-margin-percentage 2)

body {
  margin-left: auto;
  margin-right: auto;
  width: ◊(- 100 body-margin-percentage)%;
}

.todonote {
  position: absolute;
  right: ◊(/ todo-margin-percentage 2)%;
  width: ◊(- (/ body-margin-percentage 2) todo-margin-percentage)%;
}