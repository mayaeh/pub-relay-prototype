# frozen_string_literal: true
class ActorsController < ApplicationController
  def show
    render content_type: 'application/activity+json', json: Oj.dump({
      '@context': %w(https://www.w3.org/ns/activitystreams https://w3id.org/security/v1),

      id: actor_url,
      type: 'Service',
      preferredUsername: 'relay',
      inbox: inbox_url,

      publicKey: {
        id: actor_url + '#main-key',
        owner: actor_url,
        publicKeyPem: Actor.key.public_key.to_pem,
      },
    })
  end
end
