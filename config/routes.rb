Rails.application.routes.draw do
  devise_for :users
  resources :rooms do
    collection do
      get :check_availability
    end
  end
  resources :bookings

  root :to => 'bookings#home'
  get 'home' => "bookings#home"

end
