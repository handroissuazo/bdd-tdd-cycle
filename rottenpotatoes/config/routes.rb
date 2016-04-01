Rottenpotatoes::Application.routes.draw do
  root to: 'movies#index'
  
  resources :movies do
    member do
      get 'findWithSameDirector'
    end
  end
end
