Rails.application.routes.draw do
  root                               'sessions#new'
  get    'about'                  => 'pages#about'

  get    'home/home1'             => 'pages#home1'
  get    'home/home2'             => 'pages#home2'
  get    'home/home3'             => 'pages#home3'
  

  
  get    'admin/admin1'           => 'pages#admin1'
  get    'admin/admin2'           => 'pages#admin2'
  get    'admin/admin3'           => 'pages#admin3'
  
  get    'reports'                => 'reports#index'
  get    'reports/donor'          => 'reports#donor'
  get    'reports/truck'          => 'reports#truck'
<<<<<<< HEAD
    get    'reports/history'    => 'reports#history'
=======
  get    'reports/history'        => 'reports#history'
  get    'reports/rejected_history'  => 'reports#rejected_history'
  get    'reports/pickup_history' => 'reports#pickup_history'
>>>>>>> eff6ff8368010b3c4c5a076a4ffcd9e5afc40437
  
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
  
  resources :pickups
  resources :users

end
