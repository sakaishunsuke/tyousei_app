class HomeController < ApplicationController
  def top
    # 全員のデータを取り出す
    @attendances = Attendance.all
    # 何日に誰がいるか記録するMAP変数
    @date_map = {} 
    # ユーザーのリスト
    @user_list = []
    @attendances.each do |at|
      # 1人ずつのデータを書く日付に着録していく
      # 名前を読み出す＆ユーザーリストへ記録
      username = at.username
      @user_list.push(at.username)
      # クッキーに投稿者の日付を記録する
      cookies[at.username] = at.date
      # 参加できる日を読みこむ（配列）
      date_list = at.date.split(',')
      date_list.each do |date|
        if date == '' 
          next
        end
        user_list_in_date = [username]
        # ユーザー名を追加したい日が既にある？
        if @date_map.key?(date)
          user_list_in_date = @date_map[date]
          user_list_in_date.push(username)
          @date_map[date] = user_list_in_date
        else
          @date_map[date] = user_list_in_date
        end
          
      end
    end
    
    # 最後にできたMAPの中身を適正な形に書き換える
    # 例１：["ashie","konoa"]　⇨ １："a,k"
    @date_map_name_s = {}
    @date_map.keys.each do |key|
      name_list = ""
      @date_map[key].each  do |name|
        name_list += name[0] + ","
      end
      name_list.chop
      @date_map_name_s[key] = name_list
    end
    
  end
  
  def create
    # 同じ名前があるか確認する
    
    @attendances = Attendance.find_by(username: params[:username])
    if !@attendances.nil?
      @attendances.date = params[:date]
    else
      @attendances = Attendance.new(username: params[:username], date: params[:date])
    end
    
    # データ保存
    @attendances.save
    
    # ホーム画面に戻す
    redirect_to("/")
  end
end
