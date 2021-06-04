 /* global $*/
//クリックした時に色を変更
$(function(){
  $('td').click(function(){
    if ( $(this).text() != "") {
      $(this).each(function(){
        $(this).toggleClass('calendar-click-color');
      });
    }
  });
  
  
});

