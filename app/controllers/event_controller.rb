class EventController < ApplicationController
  protect_from_forgery
  def top
      
  end
  
  def create
      
    #  イベントのidを既存のイベントと被らないように乱数で作成する
    @event_id = Random.new.rand(1000000)
    while !EventList.find_by(event_id: @event_id).nil? do
        @event_id = Random.new.rand(1000000)
    end
    
    # イベントをDBに保存
    EventList.create(event_id: @event_id, name: params[:eventname], bikou: params[:bikou], password: params[:password])
    
    # そのイベント番号でリダイレクト
    redirect_to("/?event_id=#{ @event_id }")
  end
end
