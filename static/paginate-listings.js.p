$(document).ready(function(){
  $(".previoustab").click(function(e) {
    let currentListing = $(this).parents('.code-discussion').attr('current-listing');
    let newListing = Math.max(1,Number(currentListing) - 1);
    $(this).parents('.code-discussion').attr('current-listing',newListing);
    $(this).parents('.code-discussion').find('namedlisting').removeClass('hidden');
    $(this).parents('.code-discussion').find('namedlisting').each(function(index) {
      if ($(this).attr('listing-number') != newListing) {
        $(this).addClass('hidden');
      }
    });
  });
  $(".nexttab").click(function(e) {
    let currentListing = $(this).parents('.code-discussion').attr('current-listing');
    let numListings = $(this).parents('.code-discussion').attr('num-listings');
    let newListing = Math.min(numListings,Number(currentListing) + 1);
    $(this).parents('.code-discussion').attr('current-listing',newListing);
    $(this).parents('.code-discussion').find('namedlisting').removeClass('hidden');
    $(this).parents('.code-discussion').find('namedlisting').each(function(index) {
      if ($(this).attr('listing-number') != newListing) {
        $(this).addClass('hidden');
      }
    });
  });
});
