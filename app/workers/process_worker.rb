# frozen_string_literal: true
class ProcessWorker
  include Sidekiq::Worker

  PUBLIC_COLLECTION = 'https://www.w3.org/ns/activitystreams#Public'

  def perform(actor, body)
    @actor = actor
    @body  = body
    @json  = Oj.load(@body, mode: :null)

    if follow?
      subscribe!
    elsif unfollow?
      unsubscribe!
    elsif valid_for_rebroadcast?
      pass_through!
    end
  end

  private

  def follow?
    @json['type'] == 'Follow'
  end

  def unfollow?
    @json['type'] == 'Undo' && @json['object']['type'] == 'Follow'
  end

  def valid_for_rebroadcast?
    signed? && addressed_to_public? && supported_type?
  end

  def signed?
    @json['signature'].present?
  end

  def addressed_to_public?
    (Array(@json['to']) + Array(@json['cc'])).include?(PUBLIC_COLLECTION)
  end

  def subscribe_to_public?
    if @json['object'].is_a?(Hash)
      @json['object']['id'] == PUBLIC_COLLECTION
    else
      @json['object'] == PUBLIC_COLLECTION
    end
  end

  def supported_type?
    !(Array(@json['type']) & %w(Create Update Delete Announce Undo)).empty?
  end

  def subscribe!
    return unless subscribe_to_public?

    subscription   = Subscription.find_by(domain: domain)
    subscription ||= Subscription.new(domain: domain)
    subscription.inbox_url = @actor['endpoints'].is_a?(Hash) && @actor['endpoints']['sharedInbox'].present? ? @actor['endpoints']['sharedInbox'] : @actor['inbox']
    subscription.save
    
    accept_activity = Oj.dump({
      '@context': %w(https://www.w3.org/ns/activitystreams https://w3id.org/security/v1),
      id: URI.join(Rails.application.routes.url_helpers.root_url, "/actor#accepts/follows/#{domain}"),
      type: 'Accept',
      actor: URI.join(Rails.application.routes.url_helpers.root_url, "/actor"),
        object: {
          id: @json['id'],
          type: "Follow",
	  actor: @actor['id'],
          object: @json['id']
        },
    })

    DeliverWorker.perform_async(subscription.inbox_url, accept_activity)
  end

  def unsubscribe!
    Subscription.where(domain: domain).destroy_all
  end

  def pass_through!
    DeliverWorker.push_bulk(active_subscriptions) do |_domain, inbox_url|
      [inbox_url, @body]
    end
  end

  def active_subscriptions
    records = Rails.cache.fetch('subscriptions') { Subscription.pluck(:domain, :inbox_url) }
    records.reject! { |record_domain, _| record_domain == domain }
    records
  end

  def domain
    @domain ||= Addressable::URI.parse(@actor['id']).normalized_host
  end
end
