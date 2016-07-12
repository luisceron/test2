// function setupDatePicker(){
  
//   var $inputs;

//   if(!Modernizr.inputtypes.date)
//     $inputs = $("input[type=text].date-input, input[type=date]");
//   else
//     $inputs = $("input[type=text].date-input");

//   $inputs
//     .not(".date-picker-installed")
//     .not("[ng-model]")
//     .val(function(index, oldValue){
//       var r = /(\d{4})-(\d{2})-(\d{2})/;
//       if(r.test(oldValue))
//         return oldValue.replace(r, "$3/$2/$1");
//       else
//         return oldValue;
//      })
//     .inputmask("dd/mm/yyyy")
//     .datepicker({format: 'dd/mm/yyyy', autoclose: true, language: $("html").attr("lang")})
//     .addClass("date-picker-installed")

//   $inputs
//     .each(function(index, element){
//       $(element)
//         .parent(".input-group.date")
//         .find("i")
//         .click(function(){
//           $(element).datepicker("show");
//         });
//     });
// }

// $(document).on('ready page:load', setupDatePicker);
