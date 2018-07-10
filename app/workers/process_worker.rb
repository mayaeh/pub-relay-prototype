class ProcessWorker
  include Sidekiq::Worker

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
    (Array(@json['to']) + Array(@json['cc'])).include?('https://www.w3.org/ns/activitystreams#Public')
  end

  def supported_type?
    !(Array(@json['type']) & %w(Create Delete Announce Undo)).empty?
  end

  def subscribe!
    subscription   = Subscription.find_by(account_id: @actor['id'])
    subscription ||= Subscription.new(account_id: @actor['id'])
    subscription.inbox_url = @actor['inbox']
    subscription.save
  end

  def unsubscribe!
    Subscription.where(account_id: @actor['id']).delete_all
  end

  def pass_through!
    Subscription.where.not(account_id: @actor['id']).find_each do |subscription|
      DeliverWorker.perform_async(subscription.inbox_url, @body)
    end
  end
end
