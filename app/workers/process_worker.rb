class ProcessWorker
  include Sidekiq::Worker

  def perform(actor, body)
    @actor = actor
    @body  = body
    @json  = Oj.load(@body, mode: :null)

    if @json['type'] == 'Follow'
      subscribe!
    if @json['type'] == 'Undo' && @json['object']['type'] == 'Follow'
      unsubscribe!
    elsif @json['signature'].present?
      pass_through!
    end
  end

  private

  def subscribe!
    subscription   = Subscription.find_by(account_id: @actor['id'])
    subscription ||= Subscription.new(account_id: @actor['id'])
    subscription.inbox_url = @actor['inbox']
    subscription.save
  end

  def unsubscribe!
    Subscription.where(account_id: @actor['id']).delete
  end

  def pass_through!
    Subscription.where.not(account_id: @actor['id']).find_each do |subscription|
      DeliverWorker.perform_async(subscription.inbox_url, @body)
    end
  end
end
