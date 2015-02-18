$(document).ready(function() { 
  $('.select').select2({
    placeholder: 'Select a Category',
    allowClear: true
  });
});

$('.category').on('click', 'a', function(){
  $(this.parentElement).toggle();
  $(this.parentElement).siblings().toggle();
});
