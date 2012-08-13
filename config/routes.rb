GitParty::Application.routes.draw do
  root to: "repos#index"
  resources :repos, only: [:index, :create, :new]
  match ":owner/:name" => "repos#show", as: :repo
end
