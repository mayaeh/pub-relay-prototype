require 'rails_helper'

RSpec.describe ProcessWorker, :type => :job do
  let(:actor) do
    {
      'id'    => 'https://example.com/actor',
      'inbox' => 'https://example.com/inbox',
    }
  end

  subject { described_class.new }

  context 'with follow activity' do
    let(:body) do
      Oj.dump({
        '@context': 'https://www.w3.org/ns/activitystreams',
        id: 'https://example.com/follow-0001',
        type: 'Follow',
        actor: 'https://example.com/actor',
        object: 'https://www.w3.org/ns/activitystreams#Public',
      })
    end

    before do
      subject.perform(actor, body)
    end

    it 'creates subscription' do
      subscription = Subscription.find_by(account_id: actor['id'])

      expect(subscription).to_not be_nil
      expect(subscription.inbox_url).to eq actor['inbox']
    end
  end

  context 'with unfollow activity' do
    let(:body) do
      Oj.dump({
        '@context': 'https://www.w3.org/ns/activitystreams',
        id: 'https://example.com/undo-follow-0001',
        type: 'Undo',
        actor: 'https://example.com/actor',
        object: {
          id: 'https://example.com/follow-0001',
          type: 'Follow',
          actor: 'https://example.com/actor',
          object: 'https://www.w3.org/ns/activitystreams#Public',
        },
      })
    end

    before do
      Subscription.create!(account_id: actor['id'], inbox_url: actor['inbox'])
      subject.perform(actor, body)
    end

    it 'removes subscription' do
      subscription = Subscription.find_by(account_id: actor['id'])
      expect(subscription).to be_nil
    end
  end

  context 'with generic activity' do
    let!(:subscription) { Subscription.create(account_id: 'https://subscriber-example.com/actor', inbox_url: 'https://subscriber-example.com/inbox') }

    let(:body) do
      Oj.dump({
        '@context': 'https://www.w3.org/ns/activitystreams',
        id: 'https://example.com/create-note-0001',
        type: 'Create',
        actor: 'https://example.com/actor',
        to: 'https://www.w3.org/ns/activitystreams#Public',
        signature: {
          type: 'RsaSignature2017',
          creator: 'https://example.com/actor',
          signatureValue: '---NOT A REAL SIGNATURE--',
        },
        object: {
          id: 'https://example.com/note-0001',
          type: 'Note',
          attributedTo: 'https://example.com/actor',
          content: 'Hello world',
          to: 'https://www.w3.org/ns/activitystreams#Public',
          cc: 'https://example.com/followers',
        },
      })
    end

    before do
      subject.perform(actor, body)
    end

    it 'delivers to subscribers' do
      expect(DeliverWorker).to have_enqueued_sidekiq_job(subscription.inbox_url, body)
    end
  end
end
