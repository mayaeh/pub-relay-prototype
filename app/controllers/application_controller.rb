# frozen_string_literal: true
class ApplicationController < ActionController::API
  def root
    render plain: "URL of the relay inbox: #{inbox_url}"
  end

  def raise_not_found
    render plain: 'Not Found', status: 404
  end
end
