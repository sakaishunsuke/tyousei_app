class HomeController < ApplicationController
  protect_from_forgery
  def top
    if EventList.find_by(event_id: params[:event_id]) != nil then
      @event_id = params[:event_id]
      @event = EventList.find_by(event_id: @event_id)
    else
      # 該当するイベントがないので、イベント作成画面に飛ばす
      redirect_to("/event-create")
    end
      
    # 今日の日付を取得
    @dt = Date.today
    # 検索の年があるか？
    if params[:year].nil?
      @year = @dt.year.to_s
    else
      @year = params[:year].to_s
      # 数値かどうかと適正範囲かの確認　不適切ならリダイレクト
      if !(@year =~ /^[0-9]+$/ && 2021 <= @year.to_i && @year.to_i <= 3000)
        # 開いていたイベント画面に戻す
        redirect_to("/?event_id=#{ @event_id }")
        return
      end
        
    end
    # 検索の月があるか？
    if params[:month].nil?
      @month = @dt.month.to_s
    else
      @month = params[:month].to_s
      # 数値かどうかと適正範囲かの確認　不適切ならリダイレクト
      if !(@month =~ /^[0-9]+$/ && 1 <= @month.to_i && @month.to_i <= 12)
        # 開いていたイベント画面に戻す
        redirect_to("/?event_id=#{ @event_id }")
        return
      end
    end
    
    # 前月と翌月を求める
    @dt = Date.new(@year.to_i, @month.to_i, 1) - 1.month
    @year_zen = @dt.year
    @month_zen = @dt.month
    @dt = Date.new(@year.to_i, @month.to_i, 1) + 1.month
    @year_yoku = @dt.year
    @month_yoku = @dt.month
    
    # ここからカレンダーの変数設定処理
    @dt = Date.new(@year.to_i, @month.to_i, 1)
    # 最初に何日分開けるのかを決める変数
    @date_preset = @dt.wday
    
    @dt = Date.new(@year.to_i, @month.to_i, -1)
    # 月末の日付
    @date_end = @dt.day
    
    # セッションを確認する
    @s_user_name = session[:username]
    # 全員のデータを取り出す
    # 検索時には、イベントのidと年月を指定する
    @attendances = Attendance.where(event_id: @event_id, ym: @year.to_s+@month.to_s)
    
    if @attendances != nil then
    
      # 何日に誰がいるか記録するMAP変数
      @date_map_maru = {} 
      @date_map_sankaku = {} 
      # JSへの受け渡し変数
      @js_datas = {}
      # 1~31日を空配列で埋める
      for i in 1..31 do
        @date_map_maru[i.to_s] = []
        @date_map_sankaku[i.to_s] = []
      end
      
      # ユーザーのリスト
      @user_list = []
      @attendances.each do |at|
        # 1人ずつのデータを書く日付に着録していく
        # 名前を読み出す＆ユーザーリストへ記録
        username = at.username
        @user_list.push(at.username)
        # クッキーに投稿者の日付を記録する
        @js_datas[at.username+'_maru'] = at.date
        @js_datas[at.username+'_sankaku'] = at.date_sankaku
        @js_datas[at.username+'_bikou'] = at.bikou
        
        # 参加できる〇日を読みこむ（配列）
        date_list_maru = at.date.split(',')
        date_list_maru.each do |date|
          if date == '' 
            next
          end
          user_list_in_date_maru = [username]
          # ユーザー名を追加したい日が既にある？
          if @date_map_maru.key?(date)
            user_list_in_date_maru = @date_map_maru[date]
            user_list_in_date_maru.push(username)
            @date_map_maru[date] = user_list_in_date_maru
          else
            @date_map_maru[date] = user_list_in_date_maru
          end
        end
        
        # 参加できる▲日を読みこむ（配列）
        date_list_sankaku = at.date_sankaku.split(',')
        date_list_sankaku.each do |date|
          if date == '' 
            next
          end
          user_list_in_date_sankaku = [username]
          # ユーザー名を追加したい日が既にある？
          if @date_map_sankaku.key?(date)
            user_list_in_date_sankaku = @date_map_sankaku[date]
            user_list_in_date_sankaku.push(username)
            @date_map_sankaku[date] = user_list_in_date_sankaku
          else
            @date_map_sankaku[date] = user_list_in_date_sankaku
          end
        end
        
      end
      
      # 最後にできたMAPの中身を適正な形に書き換える
      # 例１：["ashie","konoa"]　⇨ １："a,k"
      @date_map_maru_name_s = {}
      @date_map_maru.keys.each do |key|
        name_list = ""
        @date_map_maru[key].each  do |name|
          name_list += name[0] + ","
        end
        name_list.chop
        @date_map_maru_name_s[key] = name_list
      end
      
    end
    
  end
  
  def create
    # データが欠損していないか確認
    if !params[:username].nil?
      
      # 同じ名前があるか確認する
      @attendances = Attendance.find_by(username: params[:username], event_id: params[:event_id], ym: params[:ym])
      if @attendances.nil?
        @attendances = Attendance.new(username: params[:username], event_id: params[:event_id], ym: params[:ym])
      end
      
      # 日付でーたを記述
      @attendances.date = params[:date_maru]
      @attendances.date_sankaku = params[:date_sankaku]
      # 備考欄を記述
      @attendances.bikou = params[:bikou]
      # イベントidを記述
      @attendances.event_id = params[:event_id]
      # ymを記述
      @attendances.ym = params[:ym]
      
      # データ保存
      @attendances.save
      
      # セッションに名前を保存
      session[:username] = params[:username]
      
    end
    # 開いていたイベント画面に戻す
    redirect_to("/?event_id=#{ params[:event_id] }&year=#{params[:year]}&month=#{params[:month]}")
  end
  
  def delete
    # セッションに空にする
    session.delete(:username)
    # 投稿者をDBから探して、あれば消去
    @attendances = Attendance.find_by(username: params[:username], event_id: params[:event_id], ym: params[:ym])
    if !@attendances.nil?
      @attendances.delete
    end
    # 開いていたイベント画面に戻す
    redirect_to("/?event_id=#{ params[:event_id] }&year=#{params[:year]}&month=#{params[:month]}")
  end
end
