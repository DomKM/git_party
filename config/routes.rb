GitParty::Application.routes.draw do
  root to: "repos#index"
  resources :repos, only: [:index, :create]
  match ":owner/:name" => "repos#show", as: :repo
end
