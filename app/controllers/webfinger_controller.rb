class WebfingerController < ApplicationController
  def show
    if params[:resource] != 'acct:relay@' + request.domain
      head(404) and return
    end

    render content_type: 'application/json', json: {
      subject: 'acct:relay@' + request.domain,
      links: [{
        rel: 'self',
        type: 'application/activity+json',
        href: actor_url,
      }],
    }
  end
end
