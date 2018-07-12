Rails.application.routes.draw do
  resource :inbox, only: :create
  resource :actor, only: :show

  get '/.well-known/webfinger', to: 'webfinger#show'

  root 'application#root'

  match '*unmatched_route', via: :all, to: 'application#raise_not_found', format: false
end
