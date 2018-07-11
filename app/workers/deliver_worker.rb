class DeliverWorker
  include Sidekiq::Worker

  sidekiq_options retries: false

  def perform(url, body)
    parsed_url    = Addressable::URI.parse(url).normalize
    host          = parsed_url.host
    date          = Time.now.utc.httpdate
    signed_string = "(request-target): post #{parsed_url.path}\nhost: #{host}\ndate: #{date}"
    signature     = Base64.strict_encode64(Actor.key.sign(OpenSSL::Digest::SHA256.new, signed_string))
    header        = 'keyId="' + actor_url + '",headers="(request-target) host date",signature="' + signature + '"'

    res = http_client.headers({ 'Host': host, 'Date': date, 'Signature': header })
                     .post(url, body: body)

    logger.debug "#{url}: HTTP #{res.code} (#{res.to_s})"
  ensure
    http_client.close
  end

  private

  def actor_url
    PubRelay::Application.routes.url_helpers.actor_url
  end

  def http_client
    HTTP.use(:auto_inflate)
        .timeout(:per_operation, write: 10, connect: 10, read: 10)
  end
end
