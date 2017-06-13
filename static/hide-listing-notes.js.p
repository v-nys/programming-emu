$(document).ready(function(){
  $("a.listingnote").on("click",function(event) {
    var nn = $(this).attr("note-number");
    $(this).parents(".code-comparison").find("p[note-number='" + nn + "']").each(function() {
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
