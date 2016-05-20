Rails.application.routes.draw do
  root                               'sessions#new'
  get    'about'                  => 'pages#about'

  get    'home/home1'             => 'pages#home1'
  get    'home/home2'             => 'pages#home2'
  get    'home/home3'             => 'pages#home3'
  
  get    'reports'                => 'reports#index'
  get    'reports/donor'          => 'reports#donor'
  get    'reports/truck'          => 'reports#truck'

  get    'reports/rejected_history'   => 'reports#rejected_history'

  get    'days'                   => 'days#index'
  get    'days/new'               => 'days#new'
  get    'days/all'               => 'days#all'
  post   'days/create'            => 'days#create'
  get    'days/:id'               => 'days#show'
  delete 'days/:id'               => 'days#destroy'
  
  get    'template'               => 'pages#template'
  get    'login'                  => 'sessions#new'
  post   'login'                  => 'sessions#create'
  delete 'logout'                 => 'sessions#destroy'
  
  get    'users/index'            => 'users#index'
  get    'accounts/account'       => 'users#show'
  
  get     'pickups/:id/reject'       => "pickups#reject"
  post    'users/prune'           => 'users#prune'
  resources :pickups
  resources :users

end
