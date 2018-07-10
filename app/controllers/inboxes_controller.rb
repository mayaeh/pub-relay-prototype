class InboxesController < ApplicationController
  include SignatureVerification

  def create
    if signed_request_account
      ProcessWorker.perform_async(signed_request_account, request.body.read)
      render plain: 'OK', status: 202
    else
      render plain: signature_verification_failure_reason, status: 401
    end
  end
end
