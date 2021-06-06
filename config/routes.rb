Rails.application.routes.draw do
  get 'attendances/index'
  get '/' => "home#top"
  
  post "home/create"  =>  "home#create"
  post "home/user-delete"  =>  "home#delete"
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
