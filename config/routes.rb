Rails.application.routes.draw do
  resources :sheets do
    resources :columns
  end
end
