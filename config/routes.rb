GitParty::Application.routes.draw do
  root to: "repos#index"
  resources :repos, only: [:index]
  match ":owner/:name" => "repos#show", as: :repo
end
