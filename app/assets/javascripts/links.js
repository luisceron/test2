$(document).ready(function(){ Turbolinks.enableProgressBar();})

.on("click", "tr[data-href] td", function(e) {
  var $td = $(this);
  if($td.find("a.btn").length === 0)
    Turbolinks.visit($td.parents("tr:first").data("href"));
})

.on("click", "li[data-href]", function(e) {
  Turbolinks.visit($(this).data("href"));
})

.on("page:change", function() {
  $('[data-toggle="tooltip"]').tooltip();
});
