# frozen_string_literal: true
class DeliverWorker
  include Sidekiq::Worker

  sidekiq_options retry: false

  def perform(url, body)
    parsed_url    = Addressable::URI.parse(url).normalize
    host          = parsed_url.host
    date          = Time.now.utc.httpdate
    user_agent    = "pub-relay-prototype"
    content_type  = "application/ld+json;profile=\"https://www.w3.org/ns/activitystreams\""
    digest        = "SHA-256=#{Digest::SHA256.base64digest(body)}"
    signed_string = "(request-target): post #{parsed_url.path}\nhost: #{host}\ndate: #{date}\ndigest: #{digest}"
    signature     = Base64.strict_encode64(Actor.key.sign(OpenSSL::Digest::SHA256.new, signed_string))
    algorithm     = "rsa-sha256"
    header        = 'keyId="' + actor_url + '",algorithm="' + algorithm + '",headers="(request-target) host date digest",signature="' + signature + '"'

    res = http_client.headers({
      'Host': host,
      'Date': date,
      'Digest': digest,
      'Signature': header,
      'User-Agent': user_agent,
      'Content-Type': content_type,
    })
    .post(url, body: body)

    logger.info "#{url}: HTTP #{res.code} (#{res.to_s})"
  ensure
    http_client.close
  end

  private

  def actor_url
    PubRelay::Application.routes.url_helpers.actor_url
  end

  def http_client
    HTTP.use(:auto_inflate)
        .timeout(write: 10, connect: 10, read: 10)
  end
end
