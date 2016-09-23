Rails.application.routes.draw do
  root                               'sessions#new'
  get    'about'                  => 'pages#about'
    get  'help'                     => 'pages#help'

  get    'reports'                => 'reports#index'
  get    'reports/donor'          => 'reports#donor'
  get    'reports/truck'          => 'reports#truck'
  get    'reports/mapquest'       => 'reports#mapquest'
  get    'reports/rejected'       => 'reports#rejected'
  get    'reports/search'         => 'reports#search'
  get    'reports/results'        => 'reports#results'

  get    'days'                   => 'days#index'
  get    'days/new'               => 'days#new'
  get    'days/all'               => 'days#all'
  post   'days/create'            => 'days#create'
  get    'days/:id'               => 'days#show'
  delete 'days/:id'               => 'days#destroy'

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
