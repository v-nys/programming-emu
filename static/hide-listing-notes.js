$(document).ready(function(){
  $(".listingnote").on("click",function(event) {
    var targetNote = $(this).attr("target-note");
    var clicked = $(this);
    $(this).parents().find("div[id='" + targetNote + "']").each(function() {
      var display = $(this).css("display");
      if (display == "none") {
        display = "block";
        clicked.removeClass("inactive-number-circle");
        clicked.addClass("active-number-circle");
      }
      else {
        display = "none";
        clicked.removeClass("active-number-circle");
        clicked.addClass("inactive-number-circle");
      }
      $(this).css("display", display);
    });
  });
});
