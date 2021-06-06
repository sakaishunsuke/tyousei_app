 /* global $*/
$(function(){
  // カレンダーの日にちが押された時の処理
  $('td').click(function(){
    var text = $(this).text().split(' ')[0]  ;
    if ( $(this).text() != "" && $.isNumeric(text)) {
      //文字を数値に変換
      var number = text; 
      
      //クリックした時に色を変更
      $(this).each(function(){
        $(this).toggleClass('calendar-click-color');
        $(this).toggleClass('calendar-image-maru');
      });
      
      // 記録されているテキストを読みこむ
      var date_text = $('textarea[name=date_maru]').text();
      // 一旦Setに変換する
      var date_set = new Set(date_text.split(','));
      // そんざいすれば消す、なければ追加
      if( date_set.has(number) ){
        date_set.delete(number);
      }else{
        date_set.add(number);
      }
      // Setからarrayから文字列に変換して保存
      $('textarea[name=date_maru]').text( [...date_set] );
      
    }
    
  });
  
  // ユーザーリストのトグルがクリックされたときの処理
  $('.user_list').click(function(){
    var username = $(this).find(".m-form-radio-text").text();
    
    // 名前と備考欄をその人に変更
    $('input[name=username]').val( username );
    $('input[name=bikou]').val( Cookies.get( username+"_bikou" ) );
    
    // 消去ボタンの名前変更＆ボタンの活性化
    $('#user-delete').removeClass( 'inactive' );
    $('#user-delete').prop('disabled', false);
    
    var items = Cookies.get( username );
    var dates = items.split(',');
    
    for(let count = 1; count < 32; count++) {
      // 1 ~ 31 日　をリセット
      $('#date-masu-'+count).removeClass( 'calendar-click-color' );
      $('#date-masu-'+count).removeClass( 'calendar-image-maru' );
    }
    // undefinedでなければデータがproduct_nameに入っている。
    if (items != undefined) {
      dates.forEach(function(date, index) {
        $('#date-masu-'+date).toggleClass( 'calendar-click-color' );
        $('#date-masu-'+date).toggleClass( 'calendar-image-maru' );
        // console.log(index + ': ' + date);
      });
      $('textarea[name=date_maru]').text( items );
    }else{ 
      // $('textarea[name=date]').text( "no" );
    }
  });
  
});

