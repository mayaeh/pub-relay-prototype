# frozen_string_literal: true
class ApplicationController < ActionController::API
  def root
    render plain: PubRelay::Application.default_url_options[:host]
  end

  def raise_not_found
    render plain: 'Not Found', status: 404
  end
end
