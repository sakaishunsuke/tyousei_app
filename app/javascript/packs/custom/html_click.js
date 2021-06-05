 /* global $*/
$(function(){
  $('td').click(function(){
    var text = $(this).text().split(' ')[0]  ;
    if ( $(this).text() != "" && $.isNumeric(text)) {
      //文字を数値に変換
      var number = text; 
      
      //クリックした時に色を変更
      $(this).each(function(){
        $(this).toggleClass('calendar-click-color');
      });
      
      // 記録されているテキストを読みこむ
      var date_text = $('textarea[name=date]').text();
      // 一旦Setに変換する
      var date_set = new Set(date_text.split(','));
      // そん際すれば消す、なければ追加
      if( date_set.has(number) ){
        date_set.delete(number);
      }else{
        date_set.add(number);
      }
      // Setからarrayから文字列に変換して保存
      $('textarea[name=date]').text( [...date_set] );
      
    }
    
  });
  
  // ユーザーリストのトグルがクリックされたときの処理
  $('.user_list').click(function(){
    var username = $(this).find(".m-form-radio-text").text();
    $('input[name=username]').val( username );
    var items = Cookies.get( username );
    var dates = items.split(',');
    
    // undefinedでなければデータがproduct_nameに入っている。
    if (items != undefined) {
      for(let count = 1; count < 32; count++) {
        // 1 ~ 31 日　をリセット
        $('#date-masu-'+count).removeClass( 'calendar-click-color' );
      }
      dates.forEach(function(date, index) {
        $('#date-masu-'+date).toggleClass( 'calendar-click-color' );
        // console.log(index + ': ' + date);
      });
      $('textarea[name=date]').text( items );
    }else{ 
      // $('textarea[name=date]').text( "no" );
    }
  });
  
});

