$(document).on("ready page:load", function(){
  $('#expand_advanced_search_button').on("click", function(){
    var transaction_advanced_search_visible = $('#transaction_advanced_search').is(":visible");

    if (transaction_advanced_search_visible){
      $('#transaction_advanced_search').hide();
      $("i", this).toggleClass("fa-angle-double-up fa-angle-double-down");
    }else{
      $('#transaction_advanced_search').show();
      $("i", this).toggleClass("fa-angle-double-down fa-angle-double-up");
    }
  });
});
