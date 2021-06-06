 /* global $*/
$(function(){
  // カレンダーの日にちが押された時の処理
  $('td').click(function(){
    var text = $(this).text().split(' ')[0]  ;
    if ( $(this).text() != "" && $.isNumeric(text)) {
      //文字を数値に変換
      var number = text; 
      
      // 記録されているテキストを読みこむ
      var date_text_maru = $('textarea[name=date_maru]').text();
      var date_text_sankaku = $('textarea[name=date_sankaku]').text();
      
      // 一旦Setに変換する
      var date_set_maru    = new Set(date_text_maru.split(','));
      var date_set_sankaku = new Set(date_text_sankaku.split(','));
      
      if ( $(this).hasClass('calendar-image-maru') ){
        //〇なら▲にする
        $(this).removeClass('calendar-image-maru');
        date_set_maru.delete(number);
        $(this).toggleClass('calendar-image-sankaku');
        date_set_sankaku.add(number);
        
      }else if($(this).hasClass('calendar-image-sankaku') ){
        // ▲なら消す
        $(this).removeClass('calendar-image-sankaku');
        date_set_sankaku.delete(number);
      }else{
        //〇▲でもないなら〇をつける
        $(this).toggleClass('calendar-image-maru');
        date_set_maru.add(number);
      }
      // Setからarrayから文字列に変換して保存
      $('textarea[name=date_maru]').text( [...date_set_maru] );
      $('textarea[name=date_sankaku]').text( [...date_set_sankaku] );
      
    }
    
  });
  
  // ユーザーリストのトグルがクリックされたときの処理
  $('.user_list').click(function(){
    var username = $(this).find(".m-form-radio-text").text();
    
    // 名前と備考欄をその人に変更
    $('input[name=username]').val( username );
    $('input[name=bikou]').val( $('#'+username+'_bikou').text() );
    
    // 消去ボタンの名前変更＆ボタンの活性化
    $('#user-delete').removeClass( 'inactive' );
    $('#user-delete').prop('disabled', false);
    
    // カレンダーのをいったんリセットさせる
    for(let count = 1; count < 32; count++) {
      // 1 ~ 31 日　をリセット
      $('#date-masu-'+count).removeClass( 'calendar-image-maru' );
      $('#date-masu-'+count).removeClass( 'calendar-image-sankaku' );
    }
    
    // 〇の日の処理
    var date_text_maru = $('#'+username+'_maru').text();
    var date_maru = date_text_maru.split(',');// 1日以上でもあれば反映させる
    if (date_maru.length > 0) {
      date_maru.forEach(function(date, index) {
        $('#date-masu-'+date).toggleClass( 'calendar-image-maru' );
      });
    }
    $('textarea[name=date_maru]').text( date_text_maru );
    
    
    // 〇の日の処理
    var date_text_sankaku = $('#'+username+'_sankaku').text();
    var date_sankaku = date_text_sankaku.split(',');// 1日以上でもあれば反映させる
    if (date_sankaku.length > 0) {
      date_sankaku.forEach(function(date, index) {
        $('#date-masu-'+date).toggleClass( 'calendar-image-sankaku' );
      });
    }
    $('textarea[name=date_sankaku]').text( date_text_sankaku );
  });
  
});

