$(document).ready(function(){
  $(".listingnote").on("click",function(event) {
    var targetNote = $(this).attr("target-note");
    $(this).parents().find("div[id='" + targetNote + "']").each(function() {
      var display = $(this).css("display");
      if (display == "none") {
        display = "block";
      }
      else {
          display = "none";
      }
      $(this).css("display", display);
    });
  });
});
