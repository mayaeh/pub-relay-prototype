class DeliverWorker
  include Sidekiq::Worker

  def perform(url, body)
    parsed_url    = Addressable::URI.parse(url)
    host          = parsed_url.host
    date          = Time.now.utc.httpdate
    signed_string = "(request-target): post #{parsed_url.path}\nhost: #{host}\ndate: #{date}"
    signature     = Base64.strict_encode64(Actor.key.sign(OpenSSL::Digest::SHA256.new, signed_string))
    header        = 'keyId="' + actor_url + '",headers="(request-target) host date",signature="' + signature + '"'

    HTTP.headers({ 'Host': host, 'Date': date, 'Signature': header })
        .post(url, body: body)
  end

  private

  def actor_url
    Application.routes.url_helpers.actor_url
  end
end
