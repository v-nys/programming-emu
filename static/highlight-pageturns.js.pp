#lang pollen
$(document).ready(function(){
    $(".c-pageturn-img").hover(
      function(ev){
          $(this).attr("src","/static/images/turn-left-dark.svg");
      },
      function(ev){
          $(this).attr("src","/static/images/turn-left-light.svg");
      });
});
