Rails.application.routes.draw do
  get 'attendances/index'
  get '/' => "home#top"
  
  post "home/create"  =>  "home#create"
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
