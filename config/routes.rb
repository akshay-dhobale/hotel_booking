Rails.application.routes.draw do
  devise_for :users
  resources :rooms
  resources :bookings

  root :to => 'bookings#home'
  get 'home' => "bookings#home"

end
