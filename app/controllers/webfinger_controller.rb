# frozen_string_literal: true
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
        href: "https://#{ENV['DOMAIN']}/actor",
      }],
    })
  end

  private

  def acct
    "acct:relay@#{ENV["DOMAIN"]}"
  end
end
