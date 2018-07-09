class InboxesController < ApplicationController
  include SignatureVerification

  def create
    if signed_request_account
      process_payload
      head 202
    else
      render plain: signature_verification_failure_reason, status: 401
    end
  end

  private

  def process_payload
    @body = request.body.read
    @json = Oj.load(@body, mode: :null)

    if @json['type'] == 'Follow'
      subscribe!
    if @json['type'] == 'Undo' && @json['object']['type'] == 'Follow'
      unsubscribe!
    elsif @json['signature'].present?
      pass_through!
    end
  end

  def subscribe!
    subscription   = Subscription.find_by(account_id: signed_request_account['id'])
    subscription ||= Subscription.new(account_id: signed_request_account['id'])
    subscription.inbox_url = signed_request_account['inbox']
    subscription.save
  end

  def unsubscribe!
    Subscription.where(account_id: signed_request_account['id']).delete
  end

  def pass_through!
    Subscription.where.not(account_id: signed_request_account['id']).find_each do |subscription|
      deliver!(subscription.inbox_url)
    end
  end

  def deliver!(url)
    parsed_url    = Addressable::URI.parse(url)
    host          = parsed_url.host
    date          = Time.now.utc.httpdate
    signed_string = "(request-target): post #{parsed_url.path}\nhost: #{host}\ndate: #{date}"
    signature     = Base64.strict_encode64(Actor.key.sign(OpenSSL::Digest::SHA256.new, signed_string))
    header        = 'keyId="' + actor_url + '",headers="(request-target) host date",signature="' + signature + '"'

    HTTP.headers({ 'Host': host, 'Date': date, 'Signature': header })
        .post(url, body: @body)
  end
end
