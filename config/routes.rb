Rails.application.routes.draw do
  get 'attendances/index'
  get '/' => "home#top"
  get '/event-create' => "event#top"
  
  post "home/create"  =>  "home#create"
  post "home/user-delete"  =>  "home#delete"
  
  post "event/create" => "event#create"
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
