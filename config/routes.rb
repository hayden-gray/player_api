Rails.application.routes.draw do
  get '/players/:id', to: 'players#show'
  get '/player_search', to: 'players#search'
end
