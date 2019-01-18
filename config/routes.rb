Rails.application.routes.draw do
  get 'direction/index'

  root 'direction#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
