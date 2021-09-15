class HomeController < ApplicationController
  def top
    if EventList.find_by(event_id: params[:event_id]) != nil then
      @event_id = params[:event_id]
      @event = EventList.find_by(event_id: @event_id)
      @event_name = 'イベント名：'+ @event.name
    else
      @event_name = 'イベント名：ななし'
    end
      
    # セッションを確認する
    @s_user_name = session[:username]
    # 全員のデータを取り出す
    # @attendances = Attendance.all
    @attendances = Attendance.where(event_id: @event_id)
    
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
      @attendances = Attendance.find_by(username: params[:username])
      if @attendances.nil?
        @attendances = Attendance.new(username: params[:username])
      end
      
      # 日付でーたを挿入
      @attendances.date = params[:date_maru]
      @attendances.date_sankaku = params[:date_sankaku]
      # 備考欄を挿入
      @attendances.bikou = params[:bikou]
      
      # データ保存
      @attendances.save
      
      # セッションに名前を保存
      session[:username] = params[:username]
      
    end
    # ホーム画面に戻す
    redirect_to("/")
  end
  
  def delete
    # セッションに空にする
    session.delete(:username)
    # 投稿者をDBから探して、あれば消去
    @attendances = Attendance.find_by(username: params[:username])
    if !@attendances.nil?
      @attendances.delete
    end
    # ホーム画面に戻す
    redirect_to("/")
  end
end
