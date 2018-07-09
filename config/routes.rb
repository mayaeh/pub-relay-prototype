Rails.application.routes.draw do
  resource :inbox, only: :create
  resource :actor, only: :show

  get '/.well-known/webfinger', to: 'webfinger#show'
end
