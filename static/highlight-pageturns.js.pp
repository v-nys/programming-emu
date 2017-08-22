#lang pollen
$(document).ready(function(){
    $(".c-pageturn-img").hover(
      function(ev){
          $(this).attr("src","/images/turn-left-dark.svg");
      },
      function(ev){
          $(this).attr("src","/images/turn-left-light.svg");
      });
});
