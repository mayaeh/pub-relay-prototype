# frozen_string_literal: true
class InboxesController < ApplicationController
  include SignatureVerification

  def create
    if signed_request_account && !blocked?
      ProcessWorker.perform_async(signed_request_account, request.body.read.force_encoding('UTF-8'))
      render plain: 'OK', status: 202
    else
      render plain: signature_verification_failure_reason, status: 401
    end
  end

  private

  def blocked?
    domain = Addressable::URI.parse(signed_request_account['id']).normalized_host
    Rails.cache.fetch("block:#{domain}") { Block.where(domain: domain).exists? }
  end
end
