class WebfingerController < ApplicationController
  def show
    if params[:resource] != acct
      head(404) and return
    end

    render content_type: 'application/json', json: Oj.dump({
      subject: acct,
      links: [{
        rel: 'self',
        type: 'application/activity+json',
        href: actor_url,
      }],
    })
  end

  private

  def acct
    'acct:relay@' + Rails.application.default_url_options[:host]
  end
end
