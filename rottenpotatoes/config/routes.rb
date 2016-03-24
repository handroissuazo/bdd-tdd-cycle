Rottenpotatoes::Application.routes.draw do
  resources :movies do
    member do
      get 'findWithSameDirector'
    end
  end
end
